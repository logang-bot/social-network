//
//  CreateChatViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 17/7/22.
//

import UIKit

class CreateChatViewController: UIViewController {
    
    @IBOutlet weak var friendsSearchBar: UISearchBar!
    @IBOutlet weak var friendsTableView: UITableView!
    
    var viewmodel = CreateChatViewModel()
    var friendsCache = [User]()
    var noFoundLabel: NoFoundLabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettings()
    }
    
    func setupSettings() {
        noFoundLabel = NoFoundLabel(parent: self)
        initViewModel()
        friendsSearchBar.delegate = self
        friendsSearchBar.showsCancelButton = true
        let uiNib = UINib(nibName: FriendTableViewCell.nibName, bundle: nil)
        friendsTableView.register(uiNib, forCellReuseIdentifier: FriendTableViewCell.identifier)
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
    }
    
    func initViewModel() {
        viewmodel.getFriendsList()
        viewmodel.reloadData = { [weak self] in
            self?.friendsTableView.reloadData()
        }
    }
}

extension CreateChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier, for: indexPath) as? FriendTableViewCell ?? FriendTableViewCell()
        
        let cellData = viewmodel.getCellData(at: indexPath)
        cell.setUpData(idFriend: cellData.id)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = viewmodel.getCellData(at: indexPath)
        
        viewmodel.createNewChat(with: friend.id) { id in
            let newChat = ChatViewController()
            newChat.chatId = id
            self.show(newChat, sender: nil)
        }
    }
}

extension CreateChatViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        friendsSearchBar.text = ""
        view.endEditing(true)
        if viewmodel.friendsList.count < friendsCache.count {
            viewmodel.friendsList = friendsCache
        }
        noFoundLabel?.isHidden = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if viewmodel.friendsList.count < friendsCache.count {
            viewmodel.friendsList = friendsCache
        }
        friendsCache = viewmodel.friendsList
        guard let text = searchBar.text, !text.isEmpty else {
            noFoundLabel?.isHidden = true
            return
        }
        
        viewmodel.friendsList = viewmodel.friendsList.filter{friend in
            return friend.name.lowercased().contains(text.lowercased())
        }
        
        if viewmodel.friendsList.count == 0 {
            noFoundLabel?.isHidden = false
        } else {
            noFoundLabel?.isHidden = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
