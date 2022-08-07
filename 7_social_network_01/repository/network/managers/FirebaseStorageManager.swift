//
//  FirebaseStorageManager.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 13/7/22.
//

import Foundation
import FirebaseFirestore
import Firebase
import UIKit

enum FirebaseStorageFolders: String {
    case photos
    case covers
}

class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    func uploadPhoto(file: UIImage, route: FirebaseStorageFolders, completion: @escaping (_ url: URL) -> Void) {
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "\(route)/\(randomID).jpg")

        guard let imageData = file.jpegData(compressionQuality: 0.75) else {return}

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
                    completion(url)
                }
            })
        }
    }
    
    func deleteFile(fileName: String) {
        let desertRef = Storage.storage().reference(withPath: "photos/").child(fileName)
        desertRef.delete { error in
          if let error = error {
            
          } else {
            
          }
        }
    }
}

