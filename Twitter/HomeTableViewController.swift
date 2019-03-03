//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Ashley Bedford on 3/2/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
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
            print("Could not retrieve tweets! oh no!")
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
            print("Could not retrieve tweets! oh no!")
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
        
 
        cell.atHandle.text = user["screen_name"] as? String
        
        //myString = String(stringInterpolationSegment:"@ \(user["screen_name"])" as String
  
        
        cell.userNameLabel.text = user["name"] as? String
        //cell.atHandle.text = "@ \(user["screen_name"])" as String
        
        //cell.atHandle.text = myString as? String
        
    
        cell.dateCreated.text = tweetArray[indexPath.row]["created_at"] as? String
        cell.commentNumber.text = String(describing: tweetArray[indexPath.row]["reply_count"]) as String
        cell.retweetNumber.text = String(describing:tweetArray[indexPath.row]["retweet_count"]) as String
        cell.likeNumber.text = String(describing:tweetArray[indexPath.row]["favourites_count"]) as String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
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

    func convertDateStringToDate(longDate: String) -> String{
        let longDateFormatter = DateFormatter()
        longDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = longDateFormatter.date(from: longDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy MMM dd"
            return dateFormatter.string(from: date)
        } else {
            return longDate
        }
    }
    
}