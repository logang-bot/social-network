//
//  SignUpViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 30/6/22.
//

import UIKit

class SignUpViewController: UIViewController {

    let firebaseManager = FirebaseManager.shared

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addUser(_ sender: Any) {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let pass = passwordTextField.text ?? ""
        let confPass = confirmPasswordTextField.text ?? ""
        
        guard pass == confPass else {
            ErrorAlert.shared.showAlert(title: "Passwords do not match", target: self)
            return
        }
        
        SignUpViewModel.shared.addUser(name: name, email: email, password: pass) { result in
            switch result {
            case .success(let user):
                print("Success", user)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print("Error", error)
                ErrorAlert.shared.showAlert(title: "Something went wrong", target: self)
            }
        }
    }

}
