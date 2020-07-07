//
//  ProfileCell.swift
//  Twitter
//
//  Created by Ashley Bedford on 7/4/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    //profileImageView
    @IBOutlet weak var profileImageView: UIImageView!
    //mediaImageView
    @IBOutlet weak var mediaImageView: UIImageView!
    //userNameLabel
    @IBOutlet weak var userNameLabel: UILabel!
    //tweetContent
    @IBOutlet weak var tweetContent: UILabel!
    //atHandle
    @IBOutlet weak var atHandle: UILabel!
    //dateCreated
    @IBOutlet weak var dateCreated: UILabel!
    //retweetNumber
    @IBOutlet weak var retweetNumber: UILabel!
    //likeNumber
    @IBOutlet weak var likeNumber: UILabel!
    //retweetButton
    @IBOutlet weak var retweetButton: UIButton!
    //favButton
    @IBOutlet weak var favButton: UIButton!
    //imageHeight
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    //verifiedImage
    @IBOutlet weak var verifiedImage: UIImageView!
    //verifiedLeading
    @IBOutlet weak var verifiedLeading: NSLayoutConstraint!
    //verifiedWidth
    @IBOutlet weak var verifiedWidth: NSLayoutConstraint!
    
    var favorited:Bool = false
    var tweetId:Int = -1
    var mediaUrl: URL?
    
    //ibaction favoriteTweet
    @IBAction func favoriteTweet(_ sender: Any) {
        let tobeFavorited = !favorited
        if (tobeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(true)
            }, failure: { (error) in
                print("Favorite did not succeed: \(error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(false)
            }, failure: { (error) in
                print("Unfavorite did not succeed: \(error)")
            })
        }
        
    }
    
    //ibaction retweet
    @IBAction func retweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setRetweeted(true)
        }, failure: { (error) in
            print("Error is retweeting: \(error)")
        })
        
    }
    
    
    func setRetweeted(_ isRetweeted:Bool) {
        if (isRetweeted) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for:
                UIControl.State.normal)
            retweetButton.isEnabled = false
        }
        else {
            retweetButton.setImage(UIImage(named:"retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
    func setFavorited(_ isFavorited:Bool){
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            favButton.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 22.5
        mediaImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
