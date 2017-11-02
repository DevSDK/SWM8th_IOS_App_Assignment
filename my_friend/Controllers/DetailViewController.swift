//
//  DatailViewControl.swift
//  my_friend
//
//  Created by soma on 2017. 11. 1..
//  Copyright © 2017년 SeokHo. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var current_data:JSONFriendWithUUID?
    
    @IBOutlet weak var detail_image: UIImageView!
    @IBOutlet weak var detail_name: UILabel!
    @IBOutlet weak var detail_email: UILabel!
    @IBOutlet weak var detail_cell: UILabel!
    
    @IBOutlet weak var detail_loc: UILabel!
    @IBAction func onClick(sender: AnyObject)
    {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        update_button()
    }
    
    func update_button()
    {
        var  loaddata = UserDefaults.standard.object(forKey: "friend")
        
        
        if(loaddata != nil)
        {
            var friend_json_string =  loaddata as! Data
            var json_decoder = JSONDecoder()
            var jsonlist = try! json_decoder.decode(JSONFriendWithUUIDArray.self, from: friend_json_string )
            
            for data in jsonlist.friends
            {
                if data.uuid == current_data?.uuid
                {
                    let rm = UIBarButtonItem.init(barButtonSystemItem: .trash, target: self, action: #selector(rightBarDeleteButtonClick(sender:)))
                    self.navigationItem.rightBarButtonItem = rm
                    return
                }
            }
        }
        
        let add = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(rightBarAddButtonClick(sender:)))
        self.navigationItem.rightBarButtonItem = add
    }
    
    
    func setup()
    {
        let url = URL(string: current_data!.friend.picture.large)
        let data = try? Data(contentsOf: url!)
        
        if let imageData = data {
            let image = UIImage(data: data!)
            detail_image?.image = image
        }
        
        var friend_title = current_data!.friend.name.title.capitalizingFirstLetter()
        var friend_first = current_data!.friend.name.first.capitalizingFirstLetter()
        var friend_last = current_data!.friend.name.last.capitalizingFirstLetter()
        var friend_loc = current_data!.friend.nat.uppercased()
        detail_name?.text = friend_title + ". " + friend_first + " " + friend_last
        
        
        detail_email?.text = current_data?.friend.email
        detail_cell?.text = current_data?.friend.cell
        detail_loc?.text = friend_loc
        
        self.title = friend_title + ". " + friend_last

        update_button()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func rightBarAddButtonClick(sender:UIBarButtonItem)
    {
        var  loaddata = UserDefaults.standard.object(forKey: "friend")
        
        if(loaddata != nil)
        {
            var friend_json_string =  loaddata as! Data
            var json_decoder = JSONDecoder()
            var jsonlist = try! json_decoder.decode(JSONFriendWithUUIDArray.self, from: friend_json_string )
            jsonlist.friends.append(current_data!)
            var save_json = try! JSONEncoder().encode(jsonlist)
            UserDefaults.standard.set(save_json, forKey: "friend")
        }
        else
        {
            var jsonlist = JSONFriendWithUUIDArray(friends: [ current_data! ])
            var save_json = try! JSONEncoder().encode(jsonlist)
            UserDefaults.standard.set(save_json, forKey: "friend")
        }
        let button = UIBarButtonItem.init(barButtonSystemItem: .trash, target: self, action: #selector(rightBarDeleteButtonClick(sender:)))
        self.navigationItem.rightBarButtonItem = button
        
        
    }
    
    @objc func rightBarDeleteButtonClick(sender:UIBarButtonItem)
    {
        var friend_json_string = UserDefaults.standard.object(forKey: "friend") as! Data
        var json_decoder = JSONDecoder()
        var jsonlist = try! json_decoder.decode(JSONFriendWithUUIDArray.self, from: friend_json_string )
        
        var index = 0
        for data in jsonlist.friends
        {
            if data.uuid == current_data?.uuid
            {
                jsonlist.friends.remove(at: index)
            }
            index+=1
        }

        var save_json = try! JSONEncoder().encode(jsonlist)
        UserDefaults.standard.set(save_json, forKey: "friend")
    
        let button = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(rightBarAddButtonClick(sender:)))
        self.navigationItem.rightBarButtonItem = button
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue,  sender: Any?) {
        if segue.identifier == "WebViewSegue"
        {
            if let webcont = segue.destination as? WebViewController
            {
                webcont.url = "https://www.google.com/search?q=" + current_data!.friend.nat
            }
        }
    }
    
}

extension DetailViewController:UIWebViewDelegate
{
    
}


