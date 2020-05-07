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
    
    var profileIsChanged = false

    private lazy var notificationMethods: NotificationMethods = NotificationMethods(for: self)

    private let model: IProfileModel
    private let presentationAssembly: IPresentationAssembly
    private var profile: User?
    private var editModeIsActive = false

    // MARK: - Initialization

    init(model: IProfileModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: "Profile", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        setUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        readProfile()

        userNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        aboutMeTextView.delegate = self

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
            if profileIsChanged {
                saveProfile()
            } else {
                CustomAnimations.shake(profileEditButton)
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
        profileIsChanged = true
    }

    // MARK: - Private Methods

    private func showImagePickerActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let chooseImageFromLibraryAction = UIAlertAction(title: "From photo library", style: .default, handler: { _ in
            self.profileIsChanged = true
            self.showImagePickerController(sourceType: .photoLibrary)
        })
        let takeImageWithCameraAction = UIAlertAction(title: "Take a photo", style: .default, handler: { _ in
            self.profileIsChanged = true
            self.showImagePickerController(sourceType: .camera)
        })
        let chooseImageFromInternetAction = UIAlertAction(title: "From the internet", style: .default, handler: { _ in
            let avatarsVC = self.presentationAssembly.avatarsViewController()
            avatarsVC.delegate = self
            self.present(avatarsVC, animated: true, completion: nil)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(chooseImageFromLibraryAction)
        actionSheet.addAction(takeImageWithCameraAction)
        actionSheet.addAction(chooseImageFromInternetAction)
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }

    private func readProfile() {
        model.loadProfile { profile in
            if let profile = profile {
                self.profile = profile
                self.userNameTextField.text = profile.name
                self.aboutMeTextView.text = profile.aboutMe
                let data = self.profile?.avatar as Data?
                if let data = data, let image = UIImage(data: data) {
                    self.userImageView.image = image
                } else {
                    self.userImageView.image = UIImage(named: "Placeholder")
                }
            }
        }
    }

    private func saveProfile() {
        activityIndicatorView.startAnimating()
        profileEditButton.isEnabled = false

        collectProfileData()

        model.save { [weak self] error in
            if error == nil {
                let successAlert = UIAlertController(title: nil, message: "Данные сохранены", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self?.changeUserInteraction(enabled: false)
                    successAlert.dismiss(animated: true, completion: nil)
                    self?.activityIndicatorView.stopAnimating()
                    self?.profileEditButton.isEnabled = true
                    self?.profileIsChanged = false
                })
                successAlert.addAction(okAction)
                self?.present(successAlert, animated: true, completion: nil)

            } else {
                let failureAlert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self?.changeUserInteraction(enabled: false)
                    failureAlert.dismiss(animated: true, completion: nil)
                    self?.activityIndicatorView.stopAnimating()
                    self?.profileEditButton.isEnabled = true
                })
                let retryAction = UIAlertAction(title: "Повторить", style: .default, handler: { _ in
                    failureAlert.dismiss(animated: true, completion: nil)
                    self?.saveProfile()
                })
                failureAlert.addAction(okAction)
                failureAlert.addAction(retryAction)
                self?.present(failureAlert, animated: true, completion: nil)
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

    private func collectProfileData() {
        profile?.name = userNameTextField.text
        profile?.aboutMe = aboutMeTextView.text
        if let image = userImageView.image {
            profile?.avatar = image.pngData() as Data?
        }
    }

}
