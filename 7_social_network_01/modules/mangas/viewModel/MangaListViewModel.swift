//
//  MangaListViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 25/7/22.
//

import Foundation

class MangaListViewModel {
    var reloadData: (() -> Void)?
    var mangas = [Manga]() {
        didSet{
            reloadData?()
        }
    }
    
    var firebaseManager = FirebaseManager.shared
    
    func getMangas() {
//        let currentUser = CoreDataManager.shared.getData().first as! AuthData
        firebaseManager.getDocuments(type: Manga.self, forCollection: .mangas) { result in
            switch result {
            case .success(let mangas):
                self.mangas = mangas
            case .failure:
                print("Something went wrong, can't get all mangas")
            }
        }
    }
    
    func getCellData(at indexPath: IndexPath) -> Manga {
        return mangas[indexPath.row]
    }
}
