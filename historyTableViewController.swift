//
//  historyTableViewController.swift
//  getitdone
//
//  Created by Akhil Yaragangu on 12/4/16.
//  Copyright © 2016 Akhil Yaragangu. All rights reserved.
//

import UIKit
import CoreData

var historydata: [[String: AnyObject]] = []

class historyTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let logindetails = NSUserDefaults.standardUserDefaults()
        let student_id = logindetails.stringForKey("studnet_id")
        print(student_id)
        let department = logindetails.stringForKey("department")
        print(department)
        // let data = getdata();
        
            self.title = "history"
            print ("=========================")
        
        //let student_id = "s1103478"
        // let information = "0"
        //self.title = "display"
       
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/history.php")!)
        request.HTTPMethod = "POST"
        
        
        let postString = "student_id=" + student_id!
        print("postString in history view")
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
                            historydata = data
                            print("==========")
                            print(historydata)
                            print("historydataa")
                            
                        }
                        self.tableView.reloadData()
                        dispatch_async(dispatch_get_main_queue()){
                            
                        }
                    }
                    //  let answers = roster_cardSet["answers"]as? String
                    
                }  else {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let myAlert = UIAlertController(title: "Alert", message:"wrong userid or password", preferredStyle: UIAlertControllerStyle.Alert);
                        let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.Default){
                            action in self.dismissViewControllerAnimated(true, completion: nil);
                        }
                        myAlert.addAction(okAction);
                        self.presentViewController(myAlert, animated: true, completion: nil)
                    })
                    
                }
                
            } catch {
                print(error)
            }
        }
        //executing the task
        task.resume()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
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
        print(historydata.count)
        return historydata.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historycell", forIndexPath: indexPath)
        //self.tableView.reloadData()

        //let cell = tableView.dequeueReusableCellWithIdentifier("dataCell", forIndexPath: indexPath)
        print("data")
        print( historydata[indexPath.row]["question"] as? String)
        
        // Configure  cell...
        cell.textLabel?.text = historydata[indexPath.row]["question"] as? String
        cell.detailTextLabel?.text = historydata[indexPath.row]["answers"] as? String
       
        
        //print(first_name)
        //let last_name =  historydata[indexPath.row]["answers"] as! String
        
       // cell.textLabel?.text = first_name
        

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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "history_detail") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selecteddata = historydata[indexPath.row]
                print(selecteddata)
                let dvc = segue.destinationViewController as! detailviewcontroller
                dvc.selectedquesiton = selecteddata
                
            }
        }
        
    }

}
