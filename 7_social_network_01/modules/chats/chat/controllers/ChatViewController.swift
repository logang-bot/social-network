//
//  ChatViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 18/7/22.
//

import UIKit

class ChatViewController: UIViewController {
    @IBOutlet weak var messagesTableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    var chatId: String?
    
    let viewmodel = ChatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        let uiNib = UINib(nibName: "MessageTableViewCell", bundle: nil)
        messagesTableView.register(uiNib, forCellReuseIdentifier: "MessageCell")
        initViewModel()
        messagesTableView.rowHeight = UITableView.automaticDimension
        messagesTableView.estimatedRowHeight = 600
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        viewmodel.createMessage(content: messageTextField.text ?? "")
        messageTextField.text = ""
    }
    
    func initViewModel() {
        viewmodel.chatId = chatId
        viewmodel.getMessages()
        viewmodel.reloadData = { [weak self] in
            self?.messagesTableView.reloadData()
        }
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = messagesTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        
        let cellData = viewmodel.getCellData(at: indexPath)
        cell.messageContentLabel.text = cellData.content
//        print(Date.getFixedDate(date: cellData.createdAt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"

//        dateMessageLabel.text = dateFormatter.string(from: Date.getFixedDate(date: cellData.createdAt))
//        print(dateFormatter.string(from: Date.getFixedDate(date: cellData.createdAt)))
//        print(dateFormatter.string(from: cellData.createdAt))
        cell.dateMessageLabel.text = dateFormatter.string(from: cellData.createdAt)
        cell.setupMessageStyle(idSender: cellData.idSender)
//        cell.setUpData(idMessage: cellData)
//        cell.messageContentLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
}
