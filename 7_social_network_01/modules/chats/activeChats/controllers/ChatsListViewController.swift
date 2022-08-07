//
//  ChatsListViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 16/7/22.
//

import UIKit

class ChatsListViewController: UIViewController {
    
    @IBOutlet weak var chatListTableView: UITableView!
    @IBOutlet weak var chatSearchBar: UISearchBar!
    
    var viewmodel: ChatListViewModel?
    var usersCache = [User]()
    var chatsCache = [Chat]()
    var noFoundLabel: NoFoundLabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewmodel = ChatListViewModel()
        initViewModel()
    }

    @IBAction func createNewChat(_ sender: Any) {
        let vc = CreateChatViewController()
        show(vc, sender: nil)
    }
    
    func setupSettings() {
        noFoundLabel = NoFoundLabel(parent: self)
        chatSearchBar.delegate = self
        chatSearchBar.showsCancelButton = true
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        let uiNib = UINib(nibName: ChatTableViewCell.nibName, bundle: nil)
        chatListTableView.register(uiNib, forCellReuseIdentifier: ChatTableViewCell.identifier)
    }
    
    func initViewModel() {
        viewmodel?.getChats()
        viewmodel?.reloadData = { [weak self] in
            self?.chatListTableView.reloadData()
        }
    }
}

extension ChatsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (viewmodel?.usersList.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as? ChatTableViewCell ?? ChatTableViewCell()
        
        let cellData = (viewmodel?.getUserData(at: indexPath))!
        cell.setUpData(userItem: cellData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = viewmodel?.getCellData(at: indexPath)
        let userReceiver = viewmodel?.getUserData(at: indexPath)
        let vcChat = ChatViewController()
        vcChat.chatId = cellData?.id
        vcChat.userReceiverName = userReceiver?.name
        self.show(vcChat, sender: nil)
    }
}

extension ChatsListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        chatSearchBar.text = ""
        view.endEditing(true)
        if (viewmodel?.usersList.count)! < usersCache.count {
            viewmodel?.usersList = usersCache
        }
        noFoundLabel?.isHidden = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (viewmodel?.usersList.count)! < usersCache.count {
            viewmodel?.usersList = usersCache
            viewmodel?.chatsList = chatsCache
        }
        usersCache = viewmodel!.usersList
        chatsCache = viewmodel!.chatsList
        guard let text = searchBar.text, !text.isEmpty else {
            noFoundLabel?.isHidden = true
            return
        }
        
        viewmodel?.usersList = (viewmodel?.usersList.filter{user in
            let index = viewmodel?.usersList.firstIndex(where: {$0 == user})
            if user.name.lowercased().contains(text.lowercased()) {
                viewmodel?.chatsList.remove(at: index!)
                return true
            }
            return false
        })!
        
        if viewmodel?.chatsList.count == 0 {
            noFoundLabel?.isHidden = false
        } else {
            noFoundLabel?.isHidden = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
