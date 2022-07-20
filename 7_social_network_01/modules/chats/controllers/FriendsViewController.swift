//
//  FriendsViewController.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 16/7/22.
//

import UIKit

class FriendsViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    private lazy var friendsReqListVC : FriendRequestsListViewController = {

        let vc = FriendRequestsListViewController()
        
        addViewController(asChildViewController: vc)
        return vc
    }()
    
    private lazy var chatsListVC : ChatsListViewController = {
 
        let vc = ChatsListViewController()
        
        addViewController(asChildViewController: vc)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        segmentedOptionChanged()
    }
    
    func setupSegmentedControl() {
        segmentedControl.removeAllSegments()
        
        segmentedControl.insertSegment(withTitle: "Friend Requests", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Chats", at: 0, animated: true)
        
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(segmentedOptionChanged), for: .valueChanged)
    }
    
    private func addViewController(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        
        // Add child view as subview
        containerView.addSubview(viewController.view)
        
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        
        viewController.view.removeFromSuperview()
        
        viewController.removeFromParent()
    }
    
    @objc func segmentedOptionChanged() {
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            remove(asChildViewController: friendsReqListVC)
            addViewController(asChildViewController: chatsListVC)
            
        case 1:
            remove(asChildViewController: chatsListVC)
            addViewController(asChildViewController: friendsReqListVC)
            
        default:
            remove(asChildViewController: friendsReqListVC)
            addViewController(asChildViewController: chatsListVC)
        }
    }

}
