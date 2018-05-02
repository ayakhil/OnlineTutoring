//
//  readTableViewController.swift
//  getitdone
//
//  Created by Akhil Yaragangu on 11/30/16.
//  Copyright © 2016 Akhil Yaragangu. All rights reserved.
//

import UIKit
import CoreData
//var questiondata = [String: String]()
//var getdata = Dictionary<String,AnyObject>()
var getdata: [[String: AnyObject]] = []
var deptdata: [[String: AnyObject]] = []

class readTableViewController: UITableViewController  {
     var selected_dept: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
    //let dept = selected_dept["department_name"]
   
    @IBOutlet weak var readanddepart: UISegmentedControl!
    var segmet = 0
   // let data = getdata();

    override func viewDidLoad() {
        super.viewDidLoad()
         //self.tableView.reloadData()
        //let student_id = "s1103478"
       // let information = "0"
        self.title = "Q&A"
        let logindetails = NSUserDefaults.standardUserDefaults()
        let student_id = logindetails.stringForKey("studnet_id")
        print(student_id)
        
//        let department = logindetails.stringForKey("department")
//        print(department)
        
        readanddepart.setTitle(selected_dept["department_name"] as? String, forSegmentAtIndex: 0)
        print ("=========================")
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/read.php")!)
        request.HTTPMethod = "POST"
        let department = selected_dept["department_name"] as? String
        
        let postString = "student_id=" + student_id! + "&department=" + department!
       print("postString in read view")
        print(postString)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest (request){
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            let responseString =  NSString (data: data!, encoding: NSUTF8StringEncoding)
            //
            
           print ("response String: \(responseString)");
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                //let jsonData:NSArray = try (NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSArray)!
                
                if  let parseJSON = json {
                    
                    let resultvalue = parseJSON["message"] as? String
                    
                    if(resultvalue == "successful") {
                        if let data = parseJSON["details"] as? [[String: AnyObject]] {
                            getdata = data
                            print("==========")
                            print(getdata)
                            print("getdata")
                            
                        }
                        if let department = parseJSON["dept"] as? [[String: AnyObject]] {
                            deptdata = department
                        }
                        //  getdata = (data as? [String: AnyObject])!
                        print(deptdata)
                        self.tableView.reloadData()
                }
              //  let answers = roster_cardSet["answers"]as? String

                } 
                
            } catch {
                print(error)
            }
        }
        //executing the task
        task.resume()
        //self.tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func post(sender: AnyObject) {
         self.performSegueWithIdentifier("post", sender: self);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print("========")
       // print(getdata.count)
        if (readanddepart.selectedSegmentIndex == 0) {
            print("segment0")
            print(getdata.count)
            return getdata.count
            
        } else {
            print("In dpet cout")
            print(deptdata.count)
            return deptdata.count
        }
        
        // teamJSON.count
        //teamJSONcount
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("datacell", forIndexPath: indexPath)
        switch (readanddepart.selectedSegmentIndex) {
        
        case 0:
            segmet = 0
       cell.textLabel?.text = getdata[indexPath.row]["question"] as? String
        cell.detailTextLabel?.text = getdata[indexPath.row]["answers"] as? String
        case 1:
            cell.textLabel?.text = deptdata[indexPath.row]["question"] as? String
            cell.detailTextLabel?.text = deptdata[indexPath.row]["answers"] as? String
            segmet = 1
        default:
            segmet = 0
            cell.textLabel?.text = getdata[indexPath.row]["question"] as? String
            cell.detailTextLabel?.text = getdata[indexPath.row]["answers"] as? String
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 */
    
    @IBAction func readanddepat(sender: AnyObject) {
        tableView.reloadData()
        self.tableView.reloadData()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       // if (readanddepart.selectedSegmentIndex == 0) {
        
        if (segue.identifier == "detailview") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //getdata[indexPath.row]["type"] = "read"
                if (readanddepart.selectedSegmentIndex == 0) {
                let selecteddata = getdata[indexPath.row]
                    print(selecteddata)
                    
                    //url_read
                    let dvc = segue.destinationViewController as! detailviewcontroller
                    dvc.selectedquesiton = selecteddata
                    
                } else {
                let selecteddata = deptdata[indexPath.row]
                
                print(selecteddata)
                let dvc = segue.destinationViewController as! detailviewcontroller
                dvc.selectedquesiton = selecteddata
            }
           }
//            } else {
//                print("==============inside else============")
//            
//                if (segue.identifier == "deptquestionview") {
//                    print(deptdata)
//                    if let indexPath = self.tableView.indexPathForSelectedRow {
//                        let departmentdata = deptdata[indexPath.row]
//                        print(departmentdata)
//                        let dvc = segue.destinationViewController as! departmentviewTableViewController
//                        //dvc.departmentselected = departmentdata
////                        let storyboard = UIStoryboard(name: "AStoryboardName", bundle: nil)
////                        let secondVC = storyboard.instantiateViewControllerWithIdentifier(anIdentifier) as! targetViewController
////                        secondVC.delegate = self
////                        presentViewController(secondVC, animated: true, completion: nil)
//                    }
//            }
            
                //dvc.delegate = self
            }
            }
}