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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        let uiNib = UINib(nibName: "FriendTableViewCell", bundle: nil)
        friendsTableView.register(uiNib, forCellReuseIdentifier: "FriendCell")
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
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendTableViewCell ?? FriendTableViewCell()
        
        let cellData = viewmodel.getCellData(at: indexPath)
        cell.setUpData(idFriend: cellData.id)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = viewmodel.getCellData(at: indexPath)
//        detailsScreen.userId = author.id
        
        viewmodel.createNewChat(with: friend.id) { id in
            let newChat = ChatViewController()
            newChat.chatId = id
            self.show(newChat, sender: nil)
        }
    }
}
