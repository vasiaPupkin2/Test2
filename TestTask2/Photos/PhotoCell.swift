//
//  PhotosCell.swift
//  TestTask2
//
//  Created by leanid niadzelin on 19.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var timeLabel: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.backgroundColor = UIColor.mainLightGray()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 3
        imageView.clipsToBounds = true
    }
    
    
    
    
    
}
