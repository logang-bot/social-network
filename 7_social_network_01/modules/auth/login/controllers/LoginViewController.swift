//
//  LoginViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 30/6/22.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logIn(_ sender: Any) {
        SVProgressHUD.show()
        let email = emailTextField.text ?? ""
        let pass = passwordTextField.text ?? ""
        LoginViewModel.shared.login(email: email, password: pass) { result in
            switch result {
            case .success(let user):
                print("User", user)
                CoreDataManager.shared.saveLocalUser(idUser: user.id, photo: user.photo)
                SVProgressHUD.dismiss()
                SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: true)
            case .failure(let error):
                SVProgressHUD.dismiss()
                ErrorAlert.shared.showAlert(title: "The email or the password is incorrect", target: self)
                print("Error", error)
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let vc = SignUpViewController()
        show(vc, sender: nil)
    }
}
