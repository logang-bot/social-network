//
//  MangaListViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 7/7/22.
//

import UIKit
import SVProgressHUD

class MangaListViewController: UIViewController {
    
    @IBOutlet weak var mangasSearchBar: UISearchBar!
    @IBOutlet weak var mangasTableView: UITableView!
    
    var viewmodel = MangaListViewModel()
    var mangasCache = [Manga]()
    var noFoundLabel: NoFoundLabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mangas"
        setupSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initViewModel()
    }

    @IBAction func createManga(_ sender: Any) {
        let vc = CreateMangaViewController()
        show(vc, sender: nil)
    }
    
    func setupSettings() {
        mangasSearchBar.delegate = self
        mangasSearchBar.showsCancelButton = true
        mangasTableView.delegate = self
        mangasTableView.dataSource = self
        let uiNib = UINib(nibName: MangaTableViewCell.nibName, bundle: nil)
        mangasTableView.register(uiNib, forCellReuseIdentifier: MangaTableViewCell.identifier)
        noFoundLabel = NoFoundLabel(parent: self)
    }
    
    func initViewModel() {
        viewmodel.getMangas()
        SVProgressHUD.show()
        viewmodel.reloadData = { [weak self] in
            SVProgressHUD.dismiss()
            self?.mangasTableView.reloadData()
        }
    }
}

extension MangaListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.mangas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mangasTableView.dequeueReusableCell(withIdentifier: MangaTableViewCell.identifier) as? MangaTableViewCell ?? MangaTableViewCell()
        
        let cellData = viewmodel.getCellData(at: indexPath)
        cell.setUpData(manga: cellData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsScreen = MangaDetailViewController()
        let manga = viewmodel.getCellData(at: indexPath)
        detailsScreen.mangaId = manga.id
        show(detailsScreen, sender: nil)
    }
}

extension MangaListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mangasSearchBar.text = ""
        view.endEditing(true)
        if viewmodel.mangas.count < mangasCache.count {
            viewmodel.mangas = mangasCache
        }
        noFoundLabel?.isHidden = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if viewmodel.mangas.count < mangasCache.count {
            viewmodel.mangas = mangasCache
        }
        mangasCache = viewmodel.mangas
        guard let text = searchBar.text, !text.isEmpty else {
            viewmodel.getMangas()
            noFoundLabel?.isHidden = true
            return
        }
        
        viewmodel.mangas = viewmodel.mangas.filter{manga in
            return manga.name.lowercased().contains(text.lowercased())
        }
        
        if viewmodel.mangas.count == 0 {
            noFoundLabel?.isHidden = false
        } else {
            noFoundLabel?.isHidden = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
