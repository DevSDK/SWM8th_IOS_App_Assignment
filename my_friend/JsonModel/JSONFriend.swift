//
//  JSONFriend.swift
//  my_friend
//
//  Created by soma on 2017. 11. 1..
//  Copyright © 2017년 SeokHo. All rights reserved.
//

import Foundation

struct JSONFriendName:Codable
{
    var title:String
    var first:String
    var last:String
}

struct JSONFriendId:Codable
{
    var name:String
    
    var value:String?=""
}

struct JSONFriendPicture: Codable
{
    var large:String
    var medium:String
    var thumbnail:String
}

struct JSONFriend:Codable
{
    var name:JSONFriendName
    var email:String?=""
    var cell :String?=""
    var id: JSONFriendId
    var picture:JSONFriendPicture
    var nat:String
}

struct JSONResult:Codable
{
    var results:[JSONFriend]
}

struct JSONFriendWithUUID : Codable
{
    var uuid:String
    var friend:JSONFriend
}

struct JSONFriendWithUUIDArray: Codable
{
    var friends:[JSONFriendWithUUID]
}
