//
//  MangaListViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 7/7/22.
//

import UIKit

class MangaListViewController: UIViewController {
    
    @IBOutlet weak var mangasSearchBar: UISearchBar!
    @IBOutlet weak var mangasTableView: UITableView!
    
    var viewmodel = MangaListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        mangasTableView.delegate = self
        mangasTableView.dataSource = self
        let uiNib = UINib(nibName: "MangaTableViewCell", bundle: nil)
        mangasTableView.register(uiNib, forCellReuseIdentifier: "MangaCell")
    }

    @IBAction func createManga(_ sender: Any) {
        let vc = CreateMangaViewController()
        show(vc, sender: nil)
    }
    
    func initViewModel() {
        viewmodel.getMangas()
        viewmodel.reloadData = { [weak self] in
            self?.mangasTableView.reloadData()
        }
    }
}

extension MangaListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.mangas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mangasTableView.dequeueReusableCell(withIdentifier: "MangaCell") as? MangaTableViewCell ?? MangaTableViewCell()
        
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
