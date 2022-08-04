//
//  ViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 29/6/22.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    
    @IBOutlet weak var dataLabel: UILabel!
    var userID: String!
    let db = Firestore.firestore()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadDocuments()
        userID = db.collection("users").document().documentID
        
        listenChanges()
    }
    
    func loadDocuments() {
        db.collection("users").getDocuments { querySnapshot, error in
            guard error == nil else {
                print(error!)
                return
            }
            
            
            self.users.removeAll()
            
            let json = JSONDecoder()
            for document in querySnapshot!.documents {
                if let data = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let user = try? json.decode(User.self, from: data)
                {
                    self.users.append(user)
                }
            }
            
            self.printUsers()
        }

    }
    
    func listenChanges() {
        db.collection("users").addSnapshotListener{ querySnapshot, error in
            guard error == nil else {
                print(error!)
                return
            }
            
            self.users.removeAll()
            
            let json = JSONDecoder()
            for document in querySnapshot!.documents {
                if let data = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let user = try? json.decode(User.self, from: data)
                {
                    self.users.append(user)
                }
            }
            
            self.printUsers()
        }
    }
    
    func printUsers() {
        var str = ""
        for user in users {
            str += "\(user.id), \(user.name), \(user.email)\n"
        }
        print(str)
        self.dataLabel.text = str
    }
    
//    @IBAction func addUser(_ sender: Any) {
//        let user = User(id: userID, name: "UserOne", email: "test@email.com", password: "something")
//
//        db.collection("users").document(userID).setData(user.dict!) { error in
//            if let error = error {
//                print("Error writing document: \(error)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
//
//    }

    
    
//    @IBAction func editUser(_ sender: Any) {
//        //let user: [String: Any] = ["id": userID, "name": "UserOneEdited", "age": 28]
//        let user = User(id: userID, name: "UserOneEdited", email: "testedit@email.com", password: "somethingedit")
//
//        db.collection("users").document(userID).setData(user.dict) { error in
//            if let error = error {
//                print("Error updating document: \(error)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
//    }
    
    
    @IBAction func removeUser(_ sender: Any) {
        db.collection("users").document(userID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
}


extension Encodable {
    var dict : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
}
