//
//  ViewController.swift
//  T Messenger
//
//  Created by Suspect on 14.02.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageChoiceButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var dataManager: DataManagerProtocol!
    private var profile: ProfileModel!
    
    private let profileFileName = "Profile.plist"
    
    private var editModeIsActive = false

    // MARK: - Lifecycle

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.setUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        readProfile()
        
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

    @IBAction func editButtonTyped(_ sender: Any) {
        if editModeIsActive {
            if profile.isChanged {
                presentSaveTypeChoice()
            } else {
                CustomAnimations.shakeButton(editButton)
            }
        } else {
            changeUserInteraction(enabled: true)
        }
    }
    
    // MARK: - Gesture Methods
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Notification Methods
    
    @objc func keyboardWillChange(_ notification: Notification) {
        guard let keyboardGlobalFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardLocalFrame = self.view.convert(keyboardGlobalFrame, from: nil)
        let keyboardInset = max(0, self.view.bounds.height - keyboardLocalFrame.minY - self.view.safeAreaInsets.bottom)
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardInset, right: 0)

        let duration: TimeInterval = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let curve = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? 0
        let options = UIView.AnimationOptions(rawValue: curve << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Target Methods
    @objc func textFieldDidChange(_ textField: UITextField) {
        profile.nameChanged = true
    }

    // MARK: - Private Methods

    private func showImagePickerActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let chooseImageFromLibraryAction = UIAlertAction(title: "From photo library", style: .default, handler: { _ in
            self.profile.imageChanged = true
            self.showImagePickerController(sourceType: .photoLibrary)
        })
        let takeImageWithCameraAction = UIAlertAction(title: "Take a photo", style: .default, handler: { _ in
            self.profile.imageChanged = true
            self.showImagePickerController(sourceType: .camera)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(chooseImageFromLibraryAction)
        actionSheet.addAction(takeImageWithCameraAction)
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }
    
    private func readProfile() {
        dataManager = OperationDataManager(fileName: profileFileName) // gcd is also available
        dataManager.read { profile in
            if let profile = profile {
                self.profile = profile
                self.userNameTextField.text = profile.name
                self.aboutMeTextView.text = profile.aboutMe
                let data = self.profile.avatarImageData as Data?
                if let data = data, let image = UIImage(data: data) {
                    self.profileImageView.image = image
                } else {
                    self.profileImageView.image = UIImage(named: "Placeholder")
                }
            }
        }
    }
    
    private func saveProfile() {
        activityIndicatorView.startAnimating()
        editButton.isEnabled = false
        
        dataManager.save(profile) { result in
            switch result {
            case true:
                let successAlert = UIAlertController(title: nil, message: "Данные сохранены", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.changeUserInteraction(enabled: false)
                    successAlert.dismiss(animated: true, completion: nil)
                    self.activityIndicatorView.stopAnimating()
                    self.editButton.isEnabled = true
                    self.profile.resetTrackingBools()
                })
                successAlert.addAction(okAction)
                self.present(successAlert, animated: true, completion: nil)
                
            case false:
                let failureAlert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.changeUserInteraction(enabled: false)
                    failureAlert.dismiss(animated: true, completion: nil)
                    self.activityIndicatorView.stopAnimating()
                    self.editButton.isEnabled = true
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
        aboutMeTextView.isUserInteractionEnabled = enabled
        profileImageChoiceButton.isUserInteractionEnabled = enabled
        profileImageChoiceButton.isHidden = !enabled
        
        editButton.setTitle(editModeIsActive ? "Сохранить" : "Редактировать", for: .normal)
    }
    
    private func presentSaveTypeChoice() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let viaGCD = UIAlertAction(title: "via GCD", style: .default, handler: { _ in
            self.collectProfileData()
            self.dataManager = GCDDataManager(fileName: self.profileFileName)
            self.saveProfile()
        })
        let viaOperation = UIAlertAction(title: "via Operation", style: .default, handler: { _ in
            self.collectProfileData()
            self.dataManager = OperationDataManager(fileName: self.profileFileName)
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
        if let image = profileImageView.image {
            profile.avatarImageData = image.pngData() as NSData?
        }
    }

}

// MARK: - ProfileViewController UI Setups

private extension ProfileViewController {
    func setUI() {
        let radius = profileImageChoiceButton.frame.size.height / 2

        setProfileImageView(with: radius)
        setImageChoiceButton(with: radius)
        setEditButton()
    }

    func setProfileImageView(with radius: CGFloat) {
        profileImageView.layer.cornerRadius = radius
    }

    func setImageChoiceButton(with radius: CGFloat) {
        profileImageChoiceButton.layer.masksToBounds = true
        profileImageChoiceButton.layer.cornerRadius = radius
        profileImageChoiceButton.backgroundColor = UIColor(rgb: 0x3F78F0)
    }

    func setEditButton() {
        editButton.layer.cornerRadius = 10.0
        editButton.layer.borderWidth = 1.0
        editButton.layer.borderColor = UIColor.black.cgColor
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
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextViewDelegate

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        profile.aboutMeChanged = true
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
