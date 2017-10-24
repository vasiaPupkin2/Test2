//
//  CustomImageView.swift
//  TestTask2
//
//  Created by leanid niadzelin on 19.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit

var imageCash = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastUrlUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        
        self.lastUrlUsedToLoadImage = urlString
        
        self.image = nil
        
        if let cashedImage = imageCash[urlString] {
            self.image = cashedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to request image:", err)
                return
            }
            
            if url.absoluteString != self.lastUrlUsedToLoadImage {
                return
            }
            
            guard let data = data else { return }
            let image = UIImage(data: data)
            imageCash[url.absoluteString] = image
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()
    }
}
