//
//  detailviewcontroller.swift
//  getitdone
//
//  Created by Akhil Yaragangu on 12/6/16.
//  Copyright © 2016 Akhil Yaragangu. All rights reserved.
//

import UIKit
import CoreData

class detailviewcontroller: UIViewController {
    var selectedquesiton: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
    
    @IBOutlet weak var urltext: UITextView!
    let check_button = "0"
    @IBOutlet weak var answer: UIButton!
   
    @IBOutlet weak var displaydata: UITextView!
    //@IBOutlet weak var displaydata: UILabel!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = (selectedquesiton["question"] as? String)
        let department = selectedquesiton["department_name"] as! String
        let answerby = selectedquesiton["answered by"] as? String
        let question_by = selectedquesiton["question posted by"] as! String
        let sub_data = "department:\(department)" + " " + "question_by:\(question_by)" + " " + "answerby:\(answerby)"
        let urltesting = selectedquesiton["url"] as? String
        if(urltesting != nil) {
        let originalString = selectedquesiton["url"] as? String
        _ =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
        let url_text = originalString!.stringByRemovingPercentEncoding!
        print("escapedString: \(url_text)")
        }
        //subtitle.text =
        // cell.textLabel?.text = "\(last_name)" + " " + "\(first_name)"
        
        text.text = sub_data
        displaydata.text = selectedquesiton["answers"] as? String
        urltext.text = selectedquesiton["url"] as? String
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/tracking.php")!)
        request.HTTPMethod = "POST"
        let logindetails = NSUserDefaults.standardUserDefaults()
        let student_id = logindetails.stringForKey("studnet_id")
        print(student_id)
        //let department = logindetails.stringForKey("department")
        //print(department)
        let question_id = selectedquesiton["question_id"] as? String
        let postString = "student_id=" + student_id! + "&question_id="+question_id!
        print(postString)
        print("postString")
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
                        print("============")
                        print("akhil")
                    }
                    
                    print(deptdata)
                    // self.tableView.reloadData()
                } 
                //  let answers = roster_cardSet["answers"]as? String
                
                
                
            } catch {
                print(error)
            }
        }
        //executing the task
        task.resume()
    }
    
    @IBOutlet weak var link: UIButton!
    
    @IBAction func link(sender: AnyObject) {
        print("=========================inside link=============")
        print(selectedquesiton["url"] != nil)
    }
//    //override func didReceiveMemoryWarning() {
//        prepareForSegue()
//        // Dispose of any resources that can be recreated.
//    }
//    
  

//    @IBAction func ans_selected(sender: AnyObject) {
//        performSegueWithIdentifier("ans_selected", sender: selectedquesiton )
//    }
//    @IBAction func edit(sender: AnyObject) {
//        //self.performSegueWithIdentifier("ans_selected", sender: self);
//        prepareForSegue(<#T##segue: UIStoryboardSegue##UIStoryboardSegue#>, sender: <#T##AnyObject?#>)
//    
    @IBAction func chatsegue(sender: AnyObject) {
    //  performSegueWithIdentifier("chat", sender: selectedquesiton)
        //let check_button = "1"
        
    }
    
    @IBOutlet weak var mail: UIButton!
    @IBAction func mail(sender: AnyObject) {
        _ = "2"
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "ans_selected") {
            //if let indexPath = self.indexPathForSelectedRow {
            let selecteddata = selectedquesiton;
            print(selecteddata)
            //if (check_button == 0") {
            if let dvc = segue.destinationViewController as? questionpViewController {
                dvc.selected_question = selecteddata
           }
        }
         else if (segue.identifier == "chat") {
                let selecteddata = selectedquesiton;
                print("akhi you are chekcing in chat segue")
                  print(selecteddata)
                if let dvc = segue.destinationViewController as? firebaseloginViewController {
                    dvc.selected_question = selecteddata
                }
        }else if(segue.identifier == "link") {
            if (selectedquesiton["url"] != nil) {
            let selecteddata = selectedquesiton;
            print("akhi you are chekcing in chat segue")
            print(selecteddata)
            if let dvc = segue.destinationViewController as? WebViewController {
                dvc.selected_question = selecteddata
            }
            }

        }else {
                    if (segue.identifier == "mail") {
                    let selecteddata = selectedquesiton;
                    print("akhi you are chekcing in mail segue")
                    print(selecteddata)
                    if let dvc = segue.destinationViewController as? emailViewController {
                        dvc.selected_question = selecteddata
                    }
                    }
            }
            
            }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
