//
//  SideMenuViewController.swift
//  TestTask2
//
//  Created by leanid niadzelin on 18.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    let menuContent: [Menu] = {
        let photos = Menu(titleName: .photos, imageName: "icon", cellId: "photosId")
        let map = Menu(titleName: .map, imageName: "map2", cellId: "mapId")
        return [photos, map]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let username = UserDefaults.standard.value(forKey: "login") as? String
        usernameLabel.text = username?.capitalized
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuContent[indexPath.row].cellId)
        cell?.imageView?.image = UIImage(named: menuContent[indexPath.row].imageName)
        cell?.textLabel?.text = menuContent[indexPath.row].titleName.rawValue
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }

}
