//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Ashley Bedford on 7/4/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var atHandle: UILabel!
    @IBOutlet weak var tagLine: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    var verifiedStatus: Bool!
    var user = NSDictionary()
    var userSet = false 
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
       // Set profile data
        /*profileImageView.setImageWith((user?.iconURL)!) //user?.iconURL)!)
        coverImageView.setImageWith((user?.coverURL)!) //(user?.coverURL)!)
        userNameLabel.text = user?.name
        let username = user?.screenName!
        atHandle.text = "@\(username!)"
        locationLabel.text = user?.location
        
        // Add commas to large follower numbers
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedFollowers = numberFormatter.string(from: NSNumber(value: (user?.followers)!))!
        let formattedFollowing = numberFormatter.string(from: NSNumber(value: (user?.following)!))!
        followingCount.text = String(formattedFollowing)
        followerCount.text = String(formattedFollowers)
        // Proper number grammar
        ////if user?.followers! == 1 {
            ////followersLabel.text = "Follower"
        ////}
        
        // Verified icon
        if (user?.verified)! {
            verifiedImageView.isHidden = false
        }*/
        
        //my tweets view
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
        
        let myUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json"
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
        
        let myUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json"
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
    
    @IBAction func backToHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
           
           //let dateFormattedString = convertDateStringToDate(longDate: "\(tweetArray[indexPath.row]["created_at"])") as? String
           
           let user = tweetArray[indexPath.row]["user"] as! NSDictionary
           let entities = tweetArray[indexPath.row]["entities"] as! NSDictionary
    
           let username = user["screen_name"] as! String
           /*
           if userSet == false {
               atHandle.text = "@" + username
               userNameLabel.text = user["name"] as? String
            
               let verifiedStatus = user["verified"] as! Bool
            
               if (verifiedStatus == false)
               {
                   verifiedImageView.isHidden = true
               } else {
                   verifiedImageView.isHidden = false
               }
            
               let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
               let data = try? Data(contentsOf: imageUrl!)
            
               if let imageData = data {
                   profileImageView.image = UIImage(data: imageData)
               }
            
               let userSet = true
           }
        */
           
                
        
        
//HERE EDIT
        
        if userSet == false {
        let myUrl = "https://api.twitter.com/1.1/users/show.json"
        let myParams = ["screen_name": username] as [String : Any]
        
        TwitterAPICaller.client?.getDictionaryRequest(url: myUrl, parameters: myParams, success: { (users: NSDictionary) in
            
            let user = users
            
            print("User added!")
            
            self.atHandle.text = "@" + username
            
            self.userNameLabel.text = user["name"] as? String
            
            let verifiedStatus = user["verified"] as! Bool
            
               
            if (verifiedStatus == false)
               {
                self.verifiedImageView.isHidden = true
               } else {
                self.verifiedImageView.isHidden = false
               }
            
            let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
            let data = try? Data(contentsOf: imageUrl!)
            
            if let imageData = data
               {
                self.profileImageView.image = UIImage(data: imageData)
               }
            
            // Add commas to large follower numbers
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            let formattedFollowers = numberFormatter.string(from: NSNumber(value: (user["followers_count"] as? Int)!))!
            let formattedFollowing = numberFormatter.string(from: NSNumber(value: (user["friends_count"] as? Int)!))!
            
            self.locationLabel.text = user["location"] as? String
            if self.locationLabel.text == "" {
                self.locationLabel.text = "Unknown, USA"
            }
            
            self.followingCount.text =  formattedFollowing
            self.followerCount.text = formattedFollowers
            self.tagLine.text = user["description"] as? String

            }, failure: { (Error) in
                    print("Could not retrieve user! oh no!")
            })
            userSet = true
        }

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
           
           // Add commas to large follower numbers
           let numberFormatter = NumberFormatter()
           numberFormatter.numberStyle = NumberFormatter.Style.decimal
           let formattedRetweets = numberFormatter.string(from: NSNumber(value: (tweetArray[indexPath.row]["retweet_count"] as? Int)!))!
           let formattedLikes = numberFormatter.string(from: NSNumber(value: (tweetArray[indexPath.row]["favorite_count"] as? Int)!))!

        
           cell.retweetNumber.text = formattedRetweets
           cell.likeNumber.text = formattedLikes

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

        
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
