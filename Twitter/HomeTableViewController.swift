//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Ashley Bedford on 3/2/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import Foundation

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    var verifiedStatus: Bool!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }

    @objc func loadTweets(){
        
        numberOfTweets = 20
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets! oh no!1")
        })
    }
    
    
    
    
    func loadMoreTweets(){
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = numberOfTweets + 20
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("Could not retrieve tweets! oh no!2")
        })
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        //let dateFormattedString = convertDateStringToDate(longDate: "\(tweetArray[indexPath.row]["created_at"])") as? String
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        let entities = tweetArray[indexPath.row]["entities"] as! NSDictionary
 
        let username = user["screen_name"] as! String
        cell.atHandle.text = "@" + username
        
        cell.userNameLabel.text = user["name"] as? String
        
        //Convert date format to month (3 letters),DD YY
        let createdAtOriginalString = (tweetArray[indexPath.row]["created_at"] as? String)!
        let formatter = DateFormatter()
        // Configure the input format to parse the date string
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Convert String to Date
        let date = formatter.date(from: createdAtOriginalString)
        // Configure output format
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        // Convert Date to String
        let createdAtString = formatter.string(from: date!)
        
        cell.dateCreated.text = " · \(createdAtString)" as String
        
        let numberFormatter = NumberFormatter()
           numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedRetweets = numberFormatter.string(from: NSNumber(value: (tweetArray[indexPath.row]["retweet_count"] as? Int)!))!
        let formattedLikes = numberFormatter.string(from: NSNumber(value: (tweetArray[indexPath.row]["favorite_count"] as? Int)!))!

        
        cell.retweetNumber.text = formattedRetweets
        cell.likeNumber.text = formattedLikes
        
        let verifiedStatus = user["verified"] as! Bool
        
        if (verifiedStatus == false)
        {
            cell.verifiedLeading.constant = 0
            cell.verifiedWidth.constant = 0
            cell.verifiedImage.isHidden = true
        } else {
            cell.verifiedImage.isHidden = false
            cell.verifiedLeading.constant = 3
            cell.verifiedWidth.constant = 14
        }
        //tweetArray[indexPath.row]["created_at"] as? String
        
        //cell.commentNumber.text = String(describing: tweetArray[indexPath.row]["reply_count"]) as String
        //cell.retweetNumber.text = String(describing:tweetArray[indexPath.row]["retweet_count"]) as String
        //cell.likeNumber.text = String(describing:tweetArray[indexPath.row]["favourites_count"]) as String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
       
        
         if let media = entities["media"] as? [[String: Any]] {
           let mediaObj = media[0]
           let mediaURL = mediaObj["media_url_https"]
            cell.mediaUrl = URL(string: (mediaURL as? String)!)
       }

        
        if cell.mediaUrl != nil {
            cell.mediaImageView.setImageWith(cell.mediaUrl!)
            cell.imageHeight.constant = 200
        } else {
            cell.imageHeight.constant = 0
        
        /*
        if let media = entities.value(forKey: "media") as? [[String:Any]], !media.isEmpty,
            
            let mediaUrl = URL(string: (media[0]["media_url_https"] as? String)!) {
            let data = try? Data(contentsOf: mediaUrl)
            let mediaType = (media[0]["type"] as? String)!

            if mediaType == "photo" {
                if let mediaData = data {
                    cell.mediaImageView.image = UIImage(data: mediaData)
                }
            }
            
            //HERE down
            //cell.mediaUrl = mediaUrl
            
            if cell.mediaUrl != nil {
                cell.mediaImageView.setImageWith(mediaUrl)
                cell.imageHeight.constant = 200
            } else {
                cell.imageHeight.constant = 0
            
            }*/
            
        }
        
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        cell.setFavorited(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        return cell
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
}
