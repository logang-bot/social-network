//
//  AuthorListViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 7/7/22.
//

import UIKit

class AuthorListViewController: UIViewController {
    
    
    @IBOutlet weak var authorsSearchBar: UISearchBar!
    
    @IBOutlet weak var authorsCollectionView: UICollectionView!
    
    let viewmodel = AuthorsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Authors"
        authorsCollectionView.delegate = self
        authorsCollectionView.dataSource = self
        initViewModel()
        
        let uiNib = UINib(nibName: "AuthorCollectionViewCell", bundle: nil)
        authorsCollectionView.register(uiNib, forCellWithReuseIdentifier: "AuthorCell")
    }
    
    func initViewModel() {
        viewmodel.getAuthors()
        viewmodel.reloadData = { [weak self] in
            self?.authorsCollectionView.reloadData()
        }
    }
}

extension AuthorListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewmodel.authors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = authorsCollectionView.dequeueReusableCell(withReuseIdentifier: "AuthorCell", for: indexPath as IndexPath) as? AuthorCollectionViewCell ?? AuthorCollectionViewCell()
        
        let cellData = viewmodel.getCellData(at: indexPath)
        cell.setUpData(author: cellData)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(collectionView.frame.width / 4)
        let height = 170
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsScreen = AuthorDetailViewController()
        let author = viewmodel.getCellData(at: indexPath)
        detailsScreen.userId = author.id
        
        show(detailsScreen, sender: nil)
    }
    
}
