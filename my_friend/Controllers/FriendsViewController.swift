//
//  FriendsViewControllers.swift
//  my_friend
//
//  Created by soma on 2017. 11. 1..
//  Copyright © 2017년 SeokHo. All rights reserved.
//

import Foundation
import UIKit

class FriendViewController: UIViewController{
    
    @IBOutlet var tableview : UITableView!
    var refreshControl: UIRefreshControl!
    
    let server_url = URL(string : "https://randomuser.me/api/?results=20&inc=name,picture,nat,cell,email,id")
    var myfriend_list = [JSONFriendWithUUID]()
    
    func download_data()
    {
         var download_task = URLSession.shared.dataTask(with:self.server_url!){
            (data, response, error) in guard error == nil else
            {
                print(error!)
                return
            }
            guard let response_data = data else {
                print( "[ERROR] Empty Data")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            let result = try! jsonDecoder.decode(JSONResult.self, from: response_data)
            self.myfriend_list.removeAll()
            
            for frd in result.results
            {
                var data = JSONFriendWithUUID(uuid: UUID().uuidString, friend: frd)
                self.myfriend_list.append(data)
                
                self.update_table()
            }
            

            DispatchQueue.main.async {
                if(self.refreshControl.isRefreshing)
                {
                    self.refreshControl.endRefreshing()
                }
            }
 
        }
        download_task.resume()
    }
    func update_table()
    {
        DispatchQueue.main.async {

            self.tableview.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = 100
        download_data()
        self.title = "My Friends"
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh!")
        refreshControl.addTarget(self, action:#selector(self.refresh), for:UIControlEvents.valueChanged)
        tableview.addSubview(refreshControl)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refresh(_ sender:AnyObject)
    {
        download_data()
    }
    
    override func prepare(for segue: UIStoryboardSegue,  sender: Any?) {
        if segue.identifier == "DetailFromFriends"
        {
            if let detailview = segue.destination as? DetailViewController
            {
                if let data = sender as? JSONFriendWithUUID{
                    detailview.current_data = data
                    DispatchQueue.main.async {
                            detailview.setup()
                    }
                }
            }
        }
    }
}


extension FriendViewController:UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myfriend_list.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for:indexPath) as! FriendCell
        var friend_title = myfriend_list[indexPath.row].friend.name.title.capitalizingFirstLetter()
        var friend_first = myfriend_list[indexPath.row].friend.name.first.capitalizingFirstLetter()
        var friend_last = myfriend_list[indexPath.row].friend.name.last.capitalizingFirstLetter()
        var friend_pic = myfriend_list[indexPath.row].friend.picture.thumbnail;
        cell.friend_name.text = friend_title + ". " + friend_first + " " + friend_last
        
        let url = URL(string: friend_pic)
        let data = try? Data(contentsOf: url!)
        
        if let imageData = data {
            let image = UIImage(data: data!)
            cell.friend_image.image = image
        }
        var friend_email = myfriend_list[indexPath.row].friend.email
        
        cell.friend_email.text =  friend_email!;
        return cell
    }    
}

extension FriendViewController:UITableViewDelegate{
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let send = myfriend_list[ (indexPath.row) ]
        performSegue(withIdentifier :"DetailFromFriends", sender: send)
    
        
    }
    
}


