//
//  ImageManager.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 10/7/22.
//

import Foundation
import UIKit

class ImageManager {
    static let shared = ImageManager()
    
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>)-> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.sync {
                        completion(.success(image))
                    }
                }
            }
        }
    }
}
