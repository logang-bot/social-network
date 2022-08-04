//
//  FriendRequestsListViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 16/7/22.
//

import UIKit

class FriendRequestsListViewController: UIViewController {
    
    @IBOutlet weak var requestsTableView: UITableView!
    let viewmodel = FriendRequestsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
//        initViewModel()
        let uiNib = UINib(nibName: FriendTableViewCell.nibName, bundle: nil)
        requestsTableView.register(uiNib, forCellReuseIdentifier: FriendTableViewCell.identifier)
        requestsTableView.delegate = self
        requestsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initViewModel()
    }
    
    func initViewModel() {
        viewmodel.getFRList()
        viewmodel.reloadData = { [weak self] in
            self?.requestsTableView.reloadData()
        }
    }
}

extension FriendRequestsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.friendRequestsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = requestsTableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier, for: indexPath) as? FriendTableViewCell ?? FriendTableViewCell()
        
        let cellData = viewmodel.getCellData(at: indexPath)
        cell.setUpData(idFriend: cellData.idSender)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let frItem = viewmodel.friendRequestsList[indexPath.row]
        
        let actions = [
            UIContextualAction(style: .normal, title: "Accept", handler: { _, _, _ in
                self.viewmodel.acceptRequest(forFR: frItem) {
                    self.deleteElement(frItem: frItem)
                }
            })
        ]
        
        actions[0].backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let frItem = viewmodel.friendRequestsList[indexPath.row]
        
        let actions = [
            UIContextualAction(style: .destructive, title: "Reject", handler: { _, _, _ in
                self.viewmodel.rejectRequest(forFR: frItem) {
                    self.deleteElement(frItem: frItem)
                }
            })
        ]
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    func deleteElement(frItem: FriendRequest) {
        DispatchQueue.main.async {
            if let index = self.viewmodel.friendRequestsList.firstIndex(where: {frItem.id == $0.id}) {
                self.viewmodel.friendRequestsList.remove(at: index)
//                self.requestsTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            }
        }
    }
}
