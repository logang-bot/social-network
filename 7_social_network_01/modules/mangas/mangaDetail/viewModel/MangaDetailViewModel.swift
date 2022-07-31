//
//  MangaDetailViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 25/7/22.
//

import Foundation
import FirebaseFirestore

class MangaDetailViewModel {
    var mangaId: String?
    var setData: (()->Void)?
    var reloadComments: (()->Void)?
    var mangaAuthor: String?
    var comments = [Comment]() {
        didSet {
            reloadComments?()
        }
    }
    var isEditable = false
    
    var mangaData: Manga?
    var myCurrentRank: String? {
        didSet {
            setData?()
        }
    }
    
    let currentUser = CoreDataManager.shared.getData().first as! AuthData
    var firebaseManager = FirebaseManager.shared
    
    init(mangaId: String) {
        self.mangaId = mangaId
    }
    
    func getManga() {
        firebaseManager.getOneDocument(type: Manga.self, forCollection: .mangas, id: mangaId!) {result in
            switch result {
            case .success(let manga):
                if manga.idOwner == self.currentUser.idUser {
                    self.isEditable = true
                } else {
                    self.isEditable = false
                }
                self.firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: manga.idOwner) {result in
                    switch result {
                    case .success(let owner):
                        self.mangaAuthor = owner.name
                        self.mangaData = manga
                        self.getCurrentRank()
                    case .failure:
                        print("Can't fetch the owner")
                    }
                }
            case .failure:
                print("Can't fetch the manga data")
            }
        }
    }
    
    func getCurrentRank() {
        firebaseManager.getDocuments(type: Rating.self, forCollection: .ratings) { [self] result in
            switch result {
            case .success(let ratings):
                let mangaCurrentRating = ratings.filter { rating in
                    rating.idUser == self.currentUser.idUser && rating.idManga == self.mangaData!.id
                }
                if mangaCurrentRating.count != 0 {
                    self.myCurrentRank = String(mangaCurrentRating.first!.rating)
                }
                else {
                    self.myCurrentRank = "No rank yet"
                }
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
    
    func getComments() {
        firebaseManager.getDocuments(type: Comment.self, forCollection: .comments) {result in
            switch result {
            case .success(let comments):
                self.comments = comments.filter{comment in
                    comment.idManga == self.mangaId
                }
            case.failure:
                print("Can't fetch all the comments for this manga")
            }
        }
    }
    
    func rateManga(rating: Int) {
        firebaseManager.getDocuments(type: Rating.self, forCollection: .ratings) { [self] result in
            switch result {
            case .success(let ratings):
                let mangaCurrentRating = ratings.filter { rating in
                    rating.idUser == self.currentUser.idUser && rating.idManga == self.mangaData!.id
                }
                if mangaCurrentRating.count != 0 {
                    let ratingNewAvg = [
                        "rating": rating
                    ]
                    
                    firebaseManager.updateFieldsInDocument(documentId: mangaCurrentRating.first!.id, values: ratingNewAvg, collection: .ratings) {_ in
                        self.updateRatingAvg(rating: rating)
                    }
                }
                else {
                    let ratingID = self.firebaseManager.getDocID(forCollection: .ratings)
                    let newRating = Rating(id: ratingID, idUser: currentUser.idUser!, idManga: self.mangaData!.id, rating: rating, createdAt: Date(), updatedAt: Date())
                    self.firebaseManager.addDocument(document: newRating, collection: .ratings) { [self] result in
                        self.updateRatingAvg(rating: newRating.rating)
                    }
                }
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
    
    func updateRatingAvg(rating: Int, isNew: Bool = false) {
        let newRatingAvg = (self.mangaData!.ratingAvg * Double(mangaData!.numRatings) + Double(rating)) / Double(mangaData!.numRatings + 1)
        
        let mangaNewRating = [
            "numRatings": self.mangaData!.numRatings + 1,
            "ratingAvg": newRatingAvg
            
        ] as [String : Any]
        
        firebaseManager.updateFieldsInDocument(documentId: self.mangaData!.id, values: mangaNewRating, collection: .mangas) { _ in
//                self.finishEditing?()
        }
    }
    
    func createComment(content: String) {
        let commentID = firebaseManager.getDocID(forCollection: .comments)
        let newComment = Comment(id: commentID, idCreator: currentUser.idUser!, idManga: mangaData!.id, content: content, createdAt: Date(), updatedAt: Date())
        
        self.firebaseManager.addDocument(document: newComment, collection: .comments) { [self] result in
            
            let mangaNewComment = [
                "comments": FieldValue.arrayUnion([newComment.id])
            ] as [String : Any]
            
            firebaseManager.updateFieldsInDocument(documentId: mangaData!.id, values: mangaNewComment, collection: .mangas) { _ in
//                self.finishEditing?()
            }
        }
    }
    func getCellData(at indexPath: IndexPath) -> Comment {
        return comments[indexPath.row]
    }
    func getUserName(for tarComment: Comment, completion: @escaping (_ user: User) -> Void) {
        firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: tarComment.idCreator) { result in
            switch result {
            case .success(let user):
                completion(user)
            case .failure:
                print("Can't get author of the commment")
            }
        }
    }
}
