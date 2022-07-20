//
//  ChatsListViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 16/7/22.
//

import UIKit

class ChatsListViewController: UIViewController {
    
    @IBOutlet weak var chatListTableView: UITableView!
    var viewmodel: ChatListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        let uiNib = UINib(nibName: "ChatTableViewCell", bundle: nil)
        chatListTableView.register(uiNib, forCellReuseIdentifier: "ChatCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewmodel = ChatListViewModel()
        initViewModel()
    }

    @IBAction func createNewChat(_ sender: Any) {
        let vc = CreateChatViewController()
        show(vc, sender: nil)
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
        (viewmodel?.chatsList.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatTableViewCell ?? ChatTableViewCell()
        
        let cellData = (viewmodel?.getCellData(at: indexPath))!
        cell.setUpData(chatItem: cellData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = viewmodel?.getCellData(at: indexPath)
        let vcChat = ChatViewController()
        vcChat.chatId = cellData?.id
        self.show(vcChat, sender: nil)
    }

}
