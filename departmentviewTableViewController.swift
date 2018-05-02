//
//  departmentviewTableViewController.swift
//  getitdone
//
//  Created by Akhil Yaragangu on 12/7/16.
//  Copyright © 2016 Akhil Yaragangu. All rights reserved.
//

import UIKit
import CoreData
class departmentviewTableViewController: UITableViewController,UISearchResultsUpdating, UISearchControllerDelegate {

    var deptlist                    : [[String: AnyObject]] = []
    
    let identifier                  = "dept_list"
    
    var results                     : NSMutableArray?
    var searchController            : UISearchController?
    var searchResultsController     : UITableViewController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Departments"

        self.addSearchBarController()
        
        self.getDepartmentList()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.hideSearchBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSearchBarController() {
        //search bar
        let resultsTableView = UITableView(frame: self.tableView.frame)
        self.searchResultsController = UITableViewController()
        self.searchResultsController?.tableView = resultsTableView
        self.searchResultsController?.tableView.dataSource = self
        self.searchResultsController?.tableView.delegate = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
        self.searchResultsController?.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
        self.searchController = UISearchController(searchResultsController: self.searchResultsController!)
        self.searchController?.searchResultsUpdater = self
        self.searchController?.delegate = self
        self.searchController?.searchBar.sizeToFit() // bar size
        self.tableView.tableHeaderView = self.searchController?.searchBar
        self.definesPresentationContext = true
    }
    
    func getDepartmentList() {
        
        let logindetails = NSUserDefaults.standardUserDefaults()
        let student_id = logindetails.stringForKey("studnet_id")
        print("studnetg id for the data")
        print(student_id)
        
        let department = logindetails.stringForKey("department")
        print(department)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/departmentlist.php")!)
        request.HTTPMethod = "POST"
        
        let postString = "student_id=" + student_id!
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest (request){ data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString =  NSString (data: data!, encoding: NSUTF8StringEncoding)
            print ("response String: \(responseString)");
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                if  let parseJSON = json {
                    let resultvalue = parseJSON["message"] as? String
                    if(resultvalue == "successful") {
                        if let department = parseJSON["dept"] as? [[String: AnyObject]] {
                            self.deptlist = department
                        }
                    }
                }
                self.tableView.reloadData()
                
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchResultsController?.tableView {
            if let results = self.results {
                return results.count
            } else {
                return 0
            }
        } else {
            return deptlist.count
        }
    
    }
    
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.identifier, forIndexPath: indexPath)
        
        var text: String?
        if tableView == self.searchResultsController?.tableView {
            if let results = self.results {
                text = results.objectAtIndex(indexPath.row)["department_name"] as? String
            }
        } else {
          text = deptlist[indexPath.row]["department_name"] as? String
        }
        
        cell.textLabel?.text = text
        return cell
     }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var selectectDetails: [String: AnyObject] = [:]
        
        if tableView == self.searchResultsController?.tableView {
            //self.searchController?.active = false
            //self.hideSearchBar()
            selectectDetails = self.results![indexPath.row] as! [String : AnyObject]
        } else {
            selectectDetails = deptlist[indexPath.row]
        }
        
        self.navigateToDetailsVC(selectectDetails)
    }
 
    func navigateToDetailsVC(withDetails: [String: AnyObject]) {
        let detailsVC = self.storyboard?.instantiateViewControllerWithIdentifier("readTableViewController") as! readTableViewController
        detailsVC.selected_dept = withDetails
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    // MARK:- UISearchResultsUpdating methods
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if self.searchController?.searchBar.text!.lengthOfBytesUsingEncoding(NSUTF32StringEncoding) > 0 {
            
            if let results = self.results {
                results.removeAllObjects()
            } else {
                results = NSMutableArray(capacity: deptlist.count)
            }
            
            let searchBarText = self.searchController!.searchBar.text
        
            let predicate = NSPredicate(block: { (dept_list: AnyObject, b: [String : AnyObject]?) -> Bool in
                var range: NSRange = 0 as NSRange
                let value = dept_list["department_name"] as! NSString
                range = value.rangeOfString(searchBarText!, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })

            // Get results from predicate and add them to the appropriate array.
            let filteredArray = (deptlist as NSArray).filteredArrayUsingPredicate(predicate)
            self.results?.addObjectsFromArray(filteredArray)
            
            // Reload a table with results.
            self.searchResultsController?.tableView.reloadData()
        }
    }
    
    // MARK:- UISearchControllerDelegate methods
    func didDismissSearchController(searchController: UISearchController) {
        UIView.animateKeyframesWithDuration(0.5, delay: 0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.hideSearchBar()
            }, completion: nil)
    }
    
    func hideSearchBar() {
        let yOffset = self.navigationController!.navigationBar.bounds.height + UIApplication.sharedApplication().statusBarFrame.height
        self.tableView.contentOffset = CGPointMake(0, self.searchController!.searchBar.bounds.height - yOffset)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "selection_dept") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selecteddata = deptlist[indexPath.row]
                print(selecteddata)
                let dvc = segue.destinationViewController as! readTableViewController
                dvc.selected_dept = selecteddata
                
            }
        }
    }
}

//var student_id = "s1103478"
//        let myLoadedString = NSUserDefaults.standardUserDefaults().stringForKey("studnet_id")
//        print(myLoadedString)

// Uncomment the following line to preserve selection between presentations
// self.clearsSelectionOnViewWillAppear = false

// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
// self.navigationItem.rightBarButtonItem = self.editButtonItem()


/*
 Override to support conditional editing of the table view.
 override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
 if editingStyle == .Delete {
 // Delete the row from the data source
 tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
 } else if editingStyle == .Insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*x
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


