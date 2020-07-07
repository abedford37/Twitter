//
//  User.swift
//  Twitter
//
//  Created by Ashley Bedford on 7/5/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import Foundation

class User {
    var name: String?
    var screenName: String?
    var iconURL: URL?
    var location: String?
    var following: Int?
    var followers: Int?
    var verified: Bool?
    var coverURL: URL?
    var isFollowing: Bool?
    
    // For user persistence
    //https://api.twitter.com/1.1/users/show.json
    
    var dictionary: [String: Any]?
    private static var _current: User?
    static var current: User? {
        get {
            if self._current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    self._current = User(dictionary: dictionary)
                }
            }
            return self._current
        }
        set (user) {
            self._current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        var iconString = dictionary["profile_image_url_https"] as? String
        if String((iconString?.suffix(4))!) == "jpeg" {
            iconString = String((iconString?.dropLast(12))!) + ".jpeg"
        } else {
            iconString = String((iconString?.dropLast(11))!) + ".jpg"
        }
        
        /*if String((iconString?.characters.suffix(4))!) == "jpeg" {
            iconString = String((iconString?.characters.dropLast(12))!) + ".jpeg"
        } else {
            iconString = String((iconString?.characters.dropLast(11))!) + ".jpg"
        }*/
        
        iconURL = URL(string: iconString!)
        location = dictionary["location"] as? String
        following = dictionary["friends_count"] as? Int
        followers = dictionary["followers_count"] as? Int
        verified = dictionary["verified"] as? Bool
        let coverString = dictionary["profile_banner_url"] as? String
        coverURL = URL(string: coverString!)
        isFollowing = dictionary["following"] as? Bool
        
        // User persistence
        self.dictionary = dictionary
    }
}
