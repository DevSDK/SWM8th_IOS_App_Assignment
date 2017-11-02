//
//  FavoritesViewControllers.swift
//  my_friend
//
//  Created by soma on 2017. 11. 1..
//  Copyright © 2017년 SeokHo. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet var tableview : UITableView!
    
    var favorite_list = [JSONFriendWithUUID]()
    
    func update_list()
    {
        var loaddata = UserDefaults.standard.object(forKey: "friend")
        
        if(loaddata != nil)
        {
            var friend_json_string =  loaddata as! Data
            var json_decoder = JSONDecoder()
            var jsonlist = try! json_decoder.decode(JSONFriendWithUUIDArray.self, from: friend_json_string )
            
            favorite_list.removeAll()
            for data in jsonlist.friends
            {
                favorite_list.append(data)
            }

        }
        else
        {

        }
        
        
        DispatchQueue.main.async {
            
            self.tableview.reloadData()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.rowHeight = 100
        self.title = "Best Friends"
        
        navigationItem.rightBarButtonItem = editButtonItem

        editButtonItem.action = #selector(editClick)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func editClick(sender: UIBarButtonItem)
    {
        if tableview.isEditing
        {
            sender.title = "Edit"
            tableview.setEditing(false, animated: true)
        }
        else{
            sender.title = "Done"
            tableview.setEditing(true, animated: true)
        }
       }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
   
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue,  sender: Any?) {
        if segue.identifier == "DetailFromFavorites"
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        update_list()
    }
    

    
}




extension FavoriteViewController:UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorite_list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoirteCell", for:indexPath) as! FriendCell
        var friend_title = favorite_list[indexPath.row].friend.name.title.capitalizingFirstLetter()
        var friend_first = favorite_list[indexPath.row].friend.name.first.capitalizingFirstLetter()
        var friend_last = favorite_list[indexPath.row].friend.name.last.capitalizingFirstLetter()
        var friend_pic = favorite_list[indexPath.row].friend.picture.thumbnail;
        cell.friend_name.text = friend_title + ". " + friend_first + " " + friend_last
        
        let url = URL(string: friend_pic)
        let data = try? Data(contentsOf: url!)
        
        if let imageData = data {
            let image = UIImage(data: data!)
            cell.friend_image.image = image
        }
        var friend_email = favorite_list[indexPath.row].friend.email
        
        cell.friend_email.text =  friend_email!;
        return cell
    }
    
  
}

extension FavoriteViewController:UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let send = favorite_list[ (indexPath.row) ]
        performSegue(withIdentifier :"DetailFromFavorites", sender: send)
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            
 
            var friend_json_string = UserDefaults.standard.object(forKey: "friend") as! Data
            var json_decoder = JSONDecoder()
            var jsonlist = try! json_decoder.decode(JSONFriendWithUUIDArray.self, from: friend_json_string )
            
            var index = 0
            for data in jsonlist.friends
            {
                if data.uuid == favorite_list[indexPath.row].uuid
                {
                    jsonlist.friends.remove(at: index)
                }
                index+=1
            }
            
            var save_json = try! JSONEncoder().encode(jsonlist)
            UserDefaults.standard.set(save_json, forKey: "friend")
            
            favorite_list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
        }
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}



