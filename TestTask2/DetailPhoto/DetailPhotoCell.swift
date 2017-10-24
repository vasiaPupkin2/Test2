//
//  DetailPhotoCell.swift
//  TestTask2
//
//  Created by leanid niadzelin on 19.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit

class DetailPhotoCell: UITableViewCell {

    @IBOutlet weak var textCommentLabel: UILabel!
    @IBOutlet weak var detailCommentLabel: UILabel!
    @IBOutlet weak var commentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            commentView.backgroundColor = UIColor.mainGray()
        } else {
            commentView.backgroundColor = UIColor.rgb(red: 240, green: 247, blue: 250)
        }
    }
    
    override func prepareForReuse() {
        textCommentLabel.text = nil
        detailCommentLabel.text = nil
    }

}
