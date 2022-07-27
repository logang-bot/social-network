//
//  CreateMangaViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 21/7/22.
//

import Foundation
import FirebaseFirestore
import UIKit

class CreateMangaViewModel {
    var reloadData: (() -> Void)?
    var finishEditing: (() -> Void)?
    var categories = [Category]() {
        didSet {
            reloadData?()
        }
    }
    var manga: Manga?
    
    var firebaseManager = FirebaseManager.shared
    let currentUser = CoreDataManager.shared.getData().first as! AuthData
    
    func getCategories() {
        firebaseManager.getDocuments(type: Category.self, forCollection: .categories) { result in
            switch result {
            case .success(let categories):
                self.categories = categories
            case .failure:
                print("Something went wrong, can't get all categories")
            }
        }
    }
    
    func createManga(name: String, description: String, categories: [String], frontPage: UIImage) {
        let mangaID = firebaseManager.getDocID(forCollection: .mangas)
        var newManga = Manga(id: mangaID, idOwner: currentUser.idUser!, name: name, description: description, categories: categories, frontPage: "", ratingAvg: 0, numRatings: 0, comments: [], createdAt: Date(), updatedAt: Date())
        
        FirebaseStorageManager.shared.uploadPhoto(file: frontPage, route: "covers") { url in
            newManga.frontPage = url.absoluteString
            self.firebaseManager.addDocument(document: newManga, collection: .mangas) { [self] result in
                let userNewManga = [
                    "mangas": FieldValue.arrayUnion([newManga.id])
                ]
                
                firebaseManager.updateFieldsInDocument(documentId: currentUser.idUser!, values: userNewManga, collection: .users) { _ in
                    self.finishEditing?()
                }
            }
        }
    }
    
    func updateManga(values: [String: Any]) {
        firebaseManager.updateFieldsInDocument(documentId: manga!.id, values: values, collection: .mangas) { result in
            self.finishEditing?()
        }
    }
    
    func updateFullManga(values: [String: Any], photo: UIImage) {
        var finalValues = values
        FirebaseStorageManager.shared.uploadPhoto(file: photo, route: "covers") { url in
            finalValues["frontPage"] = url.absoluteString
            self.updateManga(values: finalValues)
        }
    }
    
    func deleteManga() {
        firebaseManager.removeDocument(documentID: manga!.id, collection: .mangas) {_ in
            self.finishEditing?()
        }
    }
    
    func getCellData(at indexPath: IndexPath) -> Category {
        return categories[indexPath.row]
    }
}
