//
//  LoginViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 30/6/22.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logIn(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let pass = passwordTextField.text ?? ""
        LoginViewModel.shared.login(email: email, password: pass) { result in
            switch result {
            case .success(let user):
                print("User", user)
                self.saveLoginState(user: user)
                SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: true)
            case .failure(let error):
                ErrorAlert.shared.showAlert(title: "The email or the password is incorrect", target: self)
                print("Error", error)
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let vc = SignUpViewController()
        show(vc, sender: nil)
    }
    
    func saveLoginState(user: User) {
        let context = CoreDataManager.shared.getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "AuthData", in: context) else {return}
        guard let entry = NSManagedObject(entity: entity, insertInto: context) as? AuthData else {return}
        
        entry.isLoggedIn = true
        entry.idUser = user.id
        entry.name = user.name
        entry.email = user.email
        entry.photo = user.photo
        entry.password = user.password
        entry.followers = Int64(user.followers.count)
        entry.following = Int64(user.following.count)
        entry.friends = Int64(user.friends.count)
        
        try? context.save()
    }
}
