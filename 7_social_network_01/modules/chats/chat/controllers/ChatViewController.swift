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
    var userReceiverName: String?
    
    let viewmodel = ChatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = userReceiverName
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        let uiNib = UINib(nibName: MessageTableViewCell.nibName, bundle: nil)
        messagesTableView.register(uiNib, forCellReuseIdentifier: MessageTableViewCell.identifier)
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
//        viewmodel.getMessages()
        viewmodel.setChatListener()
        viewmodel.reloadData = { [weak self] in
            self?.messagesTableView.reloadData()
            DispatchQueue.main.async {
                if self!.viewmodel.messages.count != 0 {
                    let indexPath = IndexPath(row: (self?.viewmodel.messages.count)!-1, section: 0)
                    self?.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = messagesTableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell else {
            return MessageTableViewCell()
        }
        
        let cellData = viewmodel.getCellData(at: indexPath)
        cell.messageContentLabel.text = cellData.content
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        cell.dateMessageLabel.text = dateFormatter.string(from: cellData.createdAt)
        cell.setupMessageStyle(idSender: cellData.idSender)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
}
