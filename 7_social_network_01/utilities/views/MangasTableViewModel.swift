//
//  MangasTableViewViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 31/7/22.
//

import Foundation

class MangasTableViewModel: LocalViewModel {
    var authorId: String?
    var mangas = [Manga]() {
        didSet{
            reloadData?()
        }
    }
    
    init(for authorId: String = ""){
        self.authorId = authorId
    }
    
    func getMangas() {
        firebaseManager.getDocuments(type: Manga.self, forCollection: .mangas) { result in
            switch result {
            case .success(var mangas):
                if self.authorId != "" {
                    mangas = mangas.filter{ manga in
                        manga.idOwner == self.authorId
                    }
                }
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
