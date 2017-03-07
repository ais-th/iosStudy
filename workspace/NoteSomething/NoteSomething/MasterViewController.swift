//
//  MasterViewController.swift
//  NoteSomething
//
//  Created by snowman on 2017/03/03.
//  Copyright © 2017年 snowman. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertGroupObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "showDetail" {
            
            let cell = sender as! GroupDataTableViewCell

            //let object = objects[indexPath.row] as! NSDate
            
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.detailItem = RealmManager.sharedInstance.findGroupDataFromGroupId(id: cell.groupId)!
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
            
            
        } else if segue.identifier == "showWordList" {
            
            let controller = segue.destination as!  WordTableViewController
//            if let indexPath = self.tableView.indexPathForSelectedRow
//            {
//                controller.paramData = self.findGroupData(row: indexPath.row)
//            } else {
                let groupId:String = String((sender as! UIButton).tag)
                controller.paramData = RealmManager.sharedInstance.findGroupDataFromGroupId(id:groupId)!
//            }
                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
        }
        
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RealmManager.sharedInstance.findAllGroupsCount() //objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GroupDataTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GroupDataTableViewCell", for: indexPath) as! GroupDataTableViewCell

//        let object = objects[indexPath.row] as! NSDate
//        cell.textLabel!.text = object.description
        
        let maxCount:Int = RealmManager.sharedInstance.findAllGroupsCount()-1
        cell.dispCell(grpData: self.findGroupData(row: maxCount - indexPath.row))
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            objects.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "showDetail", sender: nil)
        //self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
    }
    
    

    // MARK: - Custom method
    
    func findGroupData(row:Int) -> GroupDbData {
        
       return RealmManager.sharedInstance.findGroupDataFromIndex(index: row)!
    }
    
    func showWordListVc(groupId:String)  {
        
        let groupData :GroupDbData = RealmManager.sharedInstance.findGroupDataFromGroupId(id: groupId)!
        
        self.performSegue(withIdentifier: "showWordList", sender: groupData)
    }
    
    func insertGroupObject(_ sender: Any) {
        
        RealmManager.sharedInstance.makeAndInsertDummyGroupData()
        //objects.insert(NSDate(), at: 0)
        //let index:Int = RealmManager.sharedInstance.findAllGroupsCount()-1
        let indexPath = IndexPath(row: 0 , section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

}

