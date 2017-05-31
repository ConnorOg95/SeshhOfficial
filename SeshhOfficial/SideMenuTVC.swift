//
//  SideMenuTVC.swift
//  SeshhOfficial
//
//  Created by User on 05/05/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

class SideMenuTVC: UITableViewController {
    
    var menuNameArray: Array = [String]()
    var menuIconArray: Array = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuNameArray = ["SeshhFeed", "Discover", "Account", "Contact Us", "Settings"]
        menuIconArray = [UIImage(named: "Placeholder-image")!, UIImage(named: "Placeholder-image")!, UIImage(named: "Placeholder-image")!, UIImage(named: "Placeholder-image")!, UIImage(named: "Placeholder-image")!]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuNameArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as! SideMenuTableViewCell
        cell.sideMenuLbl.text! = menuNameArray[indexPath.row]
        cell.sideMenuImg.image = menuIconArray[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealViewController:SWRevealViewController = self.revealViewController()
        let cell: SideMenuTableViewCell = tableView.cellForRow(at: indexPath) as! SideMenuTableViewCell
        
        if cell.sideMenuLbl.text! == "Seshh Feed" {
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "SeshhFeed", bundle: nil)
            let destViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SeshhFeedVC") as! SeshhFeedVC
            let newFrontViewController = UINavigationController.init(rootViewController: destViewController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
        if cell.sideMenuLbl.text! == "Discover" {
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "SeshhFeed", bundle: nil)
            let destViewController = mainStoryBoard.instantiateViewController(withIdentifier: "DiscoverVC") as! DiscoverVC
            let newFrontViewController = UINavigationController.init(rootViewController: destViewController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
        if cell.sideMenuLbl.text! == "Account" {
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "SeshhFeed", bundle: nil)
            let destViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SeshhFeedVC") as! SeshhFeedVC
            let newFrontViewController = UINavigationController.init(rootViewController: destViewController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
        if cell.sideMenuLbl.text! == "Contact Us" {
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "SeshhFeed", bundle: nil)
            let destViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SeshhFeedVC") as! SeshhFeedVC
            let newFrontViewController = UINavigationController.init(rootViewController: destViewController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
        if cell.sideMenuLbl.text! == "Settings" {
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "SeshhFeed", bundle: nil)
            let destViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SeshhFeedVC") as! SeshhFeedVC
            let newFrontViewController = UINavigationController.init(rootViewController: destViewController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
