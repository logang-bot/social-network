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
    let firebaseManager = FirebaseManager.shared
    var isEdditingPhoto = false
    
    @IBOutlet weak var userPhotoImageVIew: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFields()
        userPhotoImageVIew.layer.cornerRadius = userPhotoImageVIew.frame.width / 2
        resetButton.isHidden = true
    }
    
    @IBAction func updatePhoto(_ sender: Any) {
        showAddImageOptionAlert()
    }
    
    @IBAction func updateInfo(_ sender: Any) {
//        firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: (user?.idUser)!) { result in
//            switch result {
//            case .success(let data):
//                print(data)
//            case .failure(let error):
//                print("error, \(error.localizedDescription)")
//            }
//        }
        guard passwordTextField.text == confirmPasswordTextField.text else {
            ErrorAlert.shared.showAlert(title: "Security Alert", message: "Please, confirm your password, (with the new one if you're changing it)", target: self)
            return
        }
        
        let newData = [
            "name": nameTextField.text!,
            "email": emailTextField.text!,
            "password": passwordTextField.text!,
            "photo": "defaultUserPhoto"
        ]
        
        if isEdditingPhoto {
            updateFullData(values: newData)
        }
        else { updateInfo(values: newData) }
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        guard let idUser = user?.idUser else {return}
        firebaseManager.removeDocument(documentID: idUser, collection: .users) {result in
            ProfileViewController().logout()
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
    
    func updateInfo(values: [String: String]) {
        firebaseManager.updateFieldsInDocument(documentId: (user?.idUser)!, values: values, collection: .users) { result in
            print("updating")
        }
    }
    
    func updateFullData(values: [String: String]) {
        
        var finalValues = values
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "photos/\(randomID).jpg")

        guard let imageData = userPhotoImageVIew.image?.jpegData(compressionQuality: 0.75) else {return}

        let uploadMetadata = StorageMetadata.init()

        uploadMetadata.contentType = "image/jpeg"

        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadedMetada, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            print("Completed")
            
            uploadRef.downloadURL(completion: {(url, error) in
                if let error = error {
                    print("Error generating url \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    print("URL: \(url.absoluteString)")
                    finalValues["photo"] = url.absoluteString
                    self.updateInfo(values: finalValues)
                }
            })
        }
    }
    
    override func setImage(data: Data) {
        userPhotoImageVIew.image = UIImage(data: data)
        isEdditingPhoto = true
        resetButton.isHidden = false
    }
}
