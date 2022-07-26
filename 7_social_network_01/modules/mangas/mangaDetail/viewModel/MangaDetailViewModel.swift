//
//  MangaDetailViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 25/7/22.
//

import Foundation

class MangaDetailViewModel {
    var mangaId: String?
    var setData: (()->Void)?
    var mangaAuthor: String?
    
    var mangaData: Manga? {
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
                self.firebaseManager.getOneDocument(type: User.self, forCollection: .users, id: manga.idOwner) {result in
                    switch result {
                    case .success(let owner):
                        self.mangaAuthor = owner.name
                        self.mangaData = manga
                    case .failure:
                        print("Can't fetch the owner")
                    }
                }
            case .failure:
                print("Can't fetch the manga data")
            }
        }
    }
}
