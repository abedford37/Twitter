//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Ashley Bedford on 3/2/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var atHandle: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var commentNumber: UILabel!
    @IBOutlet weak var retweetNumber: UILabel!
    @IBOutlet weak var likeNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
