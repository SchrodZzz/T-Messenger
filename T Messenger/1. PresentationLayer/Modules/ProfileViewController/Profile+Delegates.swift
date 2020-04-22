//
//  ProfileExtensions.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

// MARK: - ProfileViewController UI Setup

extension ProfileViewController {
    func setUI() {
        let radius = userImageChoiceButton.frame.size.height / 2

        setProfileImageView(with: radius)
        setImageChoiceButton(with: radius)
        setEditButton()
    }

    private func setProfileImageView(with radius: CGFloat) {
        userImageView.layer.cornerRadius = radius
    }

    private func setImageChoiceButton(with radius: CGFloat) {
        userImageChoiceButton.layer.masksToBounds = true
        userImageChoiceButton.layer.cornerRadius = radius
        userImageChoiceButton.backgroundColor = UIColor(rgb: 0x3F78F0)
    }

    private func setEditButton() {
        profileEditButton.layer.cornerRadius = 10.0
        profileEditButton.layer.borderWidth = 1.0
        profileEditButton.layer.borderColor = UIColor.black.cgColor
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        if sourceType == .camera && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let alert = UIAlertController(title: "Камера не обнаружена", message: "На вашем устройстве не обнаружена камера", preferredStyle: .alert)
            let result = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(result)
            present(alert, animated: true, completion: nil)
        } else {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            imagePickerController.allowsEditing = true
            present(imagePickerController, animated: true, completion: nil)
        }
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImageView.image = image
        }
        dismiss(animated: true, completion: nil)
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

// MARK: - IAvatarsControllerDelegate

extension ProfileViewController: IAvatarsControllerDelegate {
    func didFinishAvatarSelection(with imageData: Data?) {
        if let imageData = imageData, let image = UIImage(data: imageData) {
            DispatchQueue.main.async {
                self.userImageView.image = image
                self.profileIsChanged = true
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UITextViewDelegate

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.profileIsChanged = true
    }
}

// MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
