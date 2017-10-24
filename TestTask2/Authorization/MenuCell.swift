//
//  MenuCell.swift
//  TestTask2
//
//  Created by leanid niadzelin on 19.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit

class MenuCell: BaseCollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.mainFadeWhite()
        return label
    }()
    
    override var isSelected: Bool {
        didSet{
            titleLabel.textColor = isSelected ? .white : UIColor.mainFadeWhite()
        }
    }
    
    override func setupViews() {
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}

