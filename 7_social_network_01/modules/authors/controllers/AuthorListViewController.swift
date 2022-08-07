//
//  AuthorListViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 7/7/22.
//

import UIKit
import SVProgressHUD

class AuthorListViewController: UIViewController {
    
    @IBOutlet weak var authorsSearchBar: UISearchBar!
    @IBOutlet weak var authorsCollectionView: UICollectionView!
    
    let viewmodel = AuthorsViewModel()
    var authorsCache = [User]()
    var noFoundLabel: NoFoundLabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Authors"
        authorsSearchBar.delegate = self
        authorsSearchBar.showsCancelButton = true
        authorsCollectionView.delegate = self
        authorsCollectionView.dataSource = self
        initViewModel()
        
        let uiNib = UINib(nibName: AuthorCollectionViewCell.nibName, bundle: nil)
        authorsCollectionView.register(uiNib, forCellWithReuseIdentifier: AuthorCollectionViewCell.identifier)
    }
    
    func setupSettings() {
        authorsSearchBar.delegate = self
        authorsSearchBar.showsCancelButton = true
        authorsCollectionView.delegate = self
        authorsCollectionView.dataSource = self
        initViewModel()
        
        let uiNib = UINib(nibName: AuthorCollectionViewCell.nibName, bundle: nil)
        authorsCollectionView.register(uiNib, forCellWithReuseIdentifier: AuthorCollectionViewCell.identifier)
        noFoundLabel = NoFoundLabel(parent: self)
    }
    
    func initViewModel() {
        viewmodel.getAuthors()
        SVProgressHUD.show()
        viewmodel.reloadData = { [weak self] in
            self?.authorsCollectionView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
}

extension AuthorListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewmodel.authors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = authorsCollectionView.dequeueReusableCell(withReuseIdentifier: AuthorCollectionViewCell.identifier, for: indexPath as IndexPath) as? AuthorCollectionViewCell ?? AuthorCollectionViewCell()
        
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

extension AuthorListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        authorsSearchBar.text = ""
        view.endEditing(true)
        if viewmodel.authors.count < authorsCache.count {
            viewmodel.authors = authorsCache
        }
        noFoundLabel?.isHidden = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if viewmodel.authors.count < authorsCache.count {
            viewmodel.authors = authorsCache
        }
        authorsCache = viewmodel.authors
        guard let text = searchBar.text, !text.isEmpty else {
            noFoundLabel?.isHidden = true
            return
        }
        viewmodel.authors = viewmodel.authors.filter{author in
            return author.name.lowercased().contains(text.lowercased())
        }
        
        if viewmodel.authors.count == 0 {
            noFoundLabel?.isHidden = false
        } else {
            noFoundLabel?.isHidden = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
