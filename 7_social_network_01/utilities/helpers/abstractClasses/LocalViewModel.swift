//
//  LocalViewModel.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 31/7/22.
//

import Foundation

class LocalViewModel {
    let firebaseManager = FirebaseManager.shared
    let currentUser = CoreDataManager.shared.getData().first as! AuthData
//    var setData: ( () -> Void )?
    var reloadData: ( () -> Void )?
    var showError: ((_ error: Error) -> Void )?
}
