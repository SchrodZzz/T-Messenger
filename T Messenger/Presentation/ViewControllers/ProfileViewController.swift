//
//  ProfileViewController.swift
//  T Messenger
//
//  Created by Suspect on 14.02.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImageChoiceButton: UIButton!
    @IBOutlet weak var profileEditButton: UIButton!

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var aboutMeTextView: UITextView!

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    private var notificationMethods: NotificationMethods!
    private var dataManager: DataManagerProtocol!
    private var profile: ProfileModel!

    private var editModeIsActive = false

    // MARK: - Lifecycle

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.setUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        readProfile()

        notificationMethods = NotificationMethods(for: self)

        userNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Button Actions

    @IBAction func profileImageChoiceButtonPressed(_ sender: Any) {
        showImagePickerActionSheet()
    }

    @IBAction func editButtonPressed(_ sender: Any) {
        if editModeIsActive {
            if profile.isChanged {
                presentSaveTypeChoice()
            } else {
                CustomAnimations.shakeButton(profileEditButton)
            }
        } else {
            changeUserInteraction(enabled: true)
        }
    }

    // MARK: - Notification Methods

    @objc func keyboardWillChange(_ notification: Notification) {
        notificationMethods.keyboardWillChange(notification)
    }

    // MARK: - Gesture Methods

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Target Methods
    @objc func textFieldDidChange(_ textField: UITextField) {
        profile.isChanged = true
    }

    // MARK: - Private Methods

    private func showImagePickerActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let chooseImageFromLibraryAction = UIAlertAction(title: "From photo library", style: .default, handler: { _ in
            self.profile.isChanged = true
            self.showImagePickerController(sourceType: .photoLibrary)
        })
        let takeImageWithCameraAction = UIAlertAction(title: "Take a photo", style: .default, handler: { _ in
            self.profile.isChanged = true
            self.showImagePickerController(sourceType: .camera)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(chooseImageFromLibraryAction)
        actionSheet.addAction(takeImageWithCameraAction)
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }

    private func readProfile() {
        dataManager = OperationDataManager() // gcd is also available
        dataManager.read { profile in
            if let profile = profile {
                self.profile = profile
                self.userNameTextField.text = profile.name
                self.aboutMeTextView.text = profile.aboutMe
                let data = self.profile.avatarImageData as Data?
                if let data = data, let image = UIImage(data: data) {
                    self.userImageView.image = image
                } else {
                    self.userImageView.image = UIImage(named: "Placeholder")
                }
            } else {
                self.profile = ProfileModel()
            }
        }
    }

    private func saveProfile() {
        activityIndicatorView.startAnimating()
        profileEditButton.isEnabled = false

        dataManager.save(profile) { result in
            switch result {
            case true:
                let successAlert = UIAlertController(title: nil, message: "Данные сохранены", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.changeUserInteraction(enabled: false)
                    successAlert.dismiss(animated: true, completion: nil)
                    self.activityIndicatorView.stopAnimating()
                    self.profileEditButton.isEnabled = true
                    self.profile.isChanged = false
                })
                successAlert.addAction(okAction)
                self.present(successAlert, animated: true, completion: nil)

            case false:
                let failureAlert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.changeUserInteraction(enabled: false)
                    failureAlert.dismiss(animated: true, completion: nil)
                    self.activityIndicatorView.stopAnimating()
                    self.profileEditButton.isEnabled = true
                })
                let retryAction = UIAlertAction(title: "Повторить", style: .default, handler: { _ in
                    failureAlert.dismiss(animated: true, completion: nil)
                    self.saveProfile()
                })
                failureAlert.addAction(okAction)
                failureAlert.addAction(retryAction)
                self.present(failureAlert, animated: true, completion: nil)
            }
        }
    }

    private func changeUserInteraction(enabled: Bool) {
        editModeIsActive = enabled
        userNameTextField.isUserInteractionEnabled = enabled
        aboutMeTextView.isEditable = enabled
        userImageChoiceButton.isUserInteractionEnabled = enabled
        userImageChoiceButton.isHidden = !enabled

        profileEditButton.setTitle(editModeIsActive ? "Сохранить" : "Редактировать", for: .normal)
    }

    private func presentSaveTypeChoice() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let viaGCD = UIAlertAction(title: "via GCD", style: .default, handler: { _ in
            self.collectProfileData()
            self.dataManager = GCDDataManager()
            self.saveProfile()
        })
        let viaOperation = UIAlertAction(title: "via Operation", style: .default, handler: { _ in
            self.collectProfileData()
            self.dataManager = OperationDataManager()
            self.saveProfile()
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(viaGCD)
        actionSheet.addAction(viaOperation)
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }

    private func collectProfileData() {
        profile = ProfileModel()
        profile.name = userNameTextField.text
        profile.aboutMe = aboutMeTextView.text
        if let image = userImageView.image {
            profile.avatarImageData = image.pngData() as NSData?
        }
    }

}

// MARK: - ProfileViewController UI Setups

private extension ProfileViewController {
    func setUI() {
        let radius = userImageChoiceButton.frame.size.height / 2

        setProfileImageView(with: radius)
        setImageChoiceButton(with: radius)
        setEditButton()
    }

    func setProfileImageView(with radius: CGFloat) {
        userImageView.layer.cornerRadius = radius
    }

    func setImageChoiceButton(with radius: CGFloat) {
        userImageChoiceButton.layer.masksToBounds = true
        userImageChoiceButton.layer.cornerRadius = radius
        userImageChoiceButton.backgroundColor = UIColor(rgb: 0x3F78F0)
    }

    func setEditButton() {
        profileEditButton.layer.cornerRadius = 10.0
        profileEditButton.layer.borderWidth = 1.0
        profileEditButton.layer.borderColor = UIColor.black.cgColor
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextViewDelegate

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        profile.isChanged = true
    }
}

// MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

// MARK: - UIColor extension

extension UIColor {
    convenience init(rgb: Int) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: 1.0
        )
    }
}
