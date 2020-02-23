//
//  ViewController.swift
//  T Messenger
//
//  Created by Suspect on 14.02.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var ProfileImageChoiceButton: UIButton!
    @IBOutlet weak var EditButton: UIButton!
    
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var DescriptionTextView: UITextView!
    

    //MARK: - Lifecycle
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
//        print(EditButton.frame)
//        -> Attempt to print frame before full editButton initialization
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(EditButton.frame)
//       -> frame value from .storyboard file
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(EditButton.frame)
//       -> frame might have different value because it's already was changed by autolayout (another device)
    }

    //MARK: Button Actions
    @IBAction func ProfileImageChoiceButtonPressed(_ sender: Any) {
        print("Choose profile image. (Выберите изображение профиля).")
        showImagePickerActionSheet()
    }
    
    //MARK: Private Methods
    private func showImagePickerActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let chooseImageFromLibraryAction = UIAlertAction(title: "From photo library", style: .default, handler: {action in
            self.showImagePickerController(sourceType: .photoLibrary)
        })
        let takeImageWithCameraAction = UIAlertAction(title: "Take a photo", style: .default, handler: { action in
            self.showImagePickerController(sourceType: .camera)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(chooseImageFromLibraryAction)
        actionSheet.addAction(takeImageWithCameraAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }

}

//MARK: - ProfileViewController UI Setups
private extension ProfileViewController {
    func setUI() {
        let radius = ProfileImageChoiceButton.frame.size.height / 2
        
        setProfileImageView(with: radius)
        setImageChoiceButton(with: radius)
        setEditButton()
    }

    func setProfileImageView(with radius: CGFloat) {
        ProfileImageView.layer.cornerRadius = radius
    }

    func setImageChoiceButton(with radius: CGFloat) {
        ProfileImageChoiceButton.layer.masksToBounds = true
        ProfileImageChoiceButton.layer.cornerRadius = radius
        ProfileImageChoiceButton.backgroundColor = UIColor(rgb: 0x3F78F0)
    }

    func setEditButton() {
        EditButton.layer.cornerRadius = 10.0
        EditButton.layer.borderWidth = 1.0
        EditButton.layer.borderColor = UIColor.black.cgColor
    }
}

//MARK: UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            ProfileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UIColor extension
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
