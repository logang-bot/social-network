//
//  EditProfileViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 6/7/22.
//

import UIKit
import FirebaseFirestore
import Firebase

class EditProfileViewController: ImagePickerViewController {
    
    var user: AuthData?
    var isEdditingPhoto = false
    var viewmodel = EditProfileViewModel()
    
    @IBOutlet weak var userPhotoImageVIew: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFields()
        initViewModel()
        setUpSettings()
        userPhotoImageVIew.layer.cornerRadius = userPhotoImageVIew.frame.width / 2
        resetButton.isHidden = true
    }
    
    func setUpSettings() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showPhotoOptions))
        userPhotoImageVIew.gestureRecognizers = [tapGesture]
        userPhotoImageVIew.isUserInteractionEnabled = true
    }
    
    @objc func showPhotoOptions() {
        
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "View Photo", style: .default) {_ in
           
        })
        
        alert.addAction(UIAlertAction(title: "Remove Photo", style: .default){_ in
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        navigationController?.present(alert, animated: true)
    }
    
    func initViewModel() {
        viewmodel.user = user
        viewmodel.finishEditing = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
        
    @IBAction func updatePhoto(_ sender: Any) {
        showAddImageOptionAlert()
    }
    
    @IBAction func updateInfo(_ sender: Any) {
        guard passwordTextField.text == confirmPasswordTextField.text else {
            ErrorAlert.shared.showAlert(title: "Security Alert", message: "Please, confirm your password, (with the new one if you're changing it)", target: self)
            return
        }
        
        ConfirmAlert(title: "Confirm changes", message: "Are you sure you wanna save this changes?", preferredStyle: .alert).showAlert(target: self) { () in
            
            let newData = [
                "name": self.nameTextField.text!,
                "email": self.emailTextField.text!,
                "password": self.passwordTextField.text!,
                "photo": "defaultUserPhoto"
            ]
            
            if self.isEdditingPhoto {
                self.viewmodel.updateFullData(values: newData, photo: self.userPhotoImageVIew.image!)
            }
            else { self.viewmodel.updateInfo(values: newData) }
        }
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        ConfirmAlert(title: "Delete account confirmation", message: "Are you sure you wanna delete your accoutn permanently?", preferredStyle: .alert).showAlert(target: self) { () in
            self.viewmodel.deleteUser()
        }
    }
    
    @IBAction func resetPhoto(_ sender: Any) {
        userPhotoImageVIew.image = UIImage(named: "defaultUserPhoto")
        resetButton.isHidden = true
        isEdditingPhoto = false
    }
    
    func setFields() {
        nameTextField.text = user?.name
        emailTextField.text = user?.email
        passwordTextField.text = user?.password
        
        if user?.photo == "defaultUserPhoto" {
            userPhotoImageVIew.image = UIImage(named: "defaultUserPhoto")
        }
        
        else {
            ImageManager.shared.loadImage(from: URL(string: (user?.photo)!)!) { result in
                switch result {
                case .success(let image):
                    self.userPhotoImageVIew.image = image
                case .failure(let error):
                    print("Can't display the image \(error)")
                }
            }
        }
    }
    
    override func setImage(data: Data) {
        userPhotoImageVIew.image = UIImage(data: data)
        isEdditingPhoto = true
        resetButton.isHidden = false
    }
}