//
//  profileViewController.swift
//  getitdone
//
//  Created by Akhil Yaragangu on 12/9/16.
//  Copyright © 2016 Akhil Yaragangu. All rights reserved.
//

import UIKit
 var info                    : [[String: AnyObject]] = []
 var f_name : String = String()
var l_name : String = String()
class profileViewController: UIViewController {

   // @IBOutlet weak var name: UITextView!
    @IBOutlet weak var name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        details()
        // Do any additional setup after loading the view.
        //[self.viewDidLoad()]
        //name.text = "AKHIL"
        let logindetails = NSUserDefaults.standardUserDefaults()
        let student_id = logindetails.stringForKey("studnet_id")
       name.text = student_id

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logout(sender: AnyObject) {
        let logindetails = NSUserDefaults.standardUserDefaults()
        logindetails.setValue("", forKey: "studnet_id")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func details() {
        let myUrl = "http://localhost:8888/proflie.php"
        let url = NSURL(string:myUrl)
        let request = NSMutableURLRequest (URL: url!)
        print("======access==========")
        request.HTTPMethod = "POST"
        let logindetails = NSUserDefaults.standardUserDefaults()
        let student_id = logindetails.stringForKey("studnet_id")
        print(student_id)

        let postString = "student_id=" + student_id!
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest (request){
            data, response, error in
            if error != nil
            {
                print("error=\(error)")
                return
            }
            response
            
            let responseString =  NSString (data: data!, encoding: NSUTF8StringEncoding)
            print ("response String: \(responseString)");
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers
                    ) as? NSDictionary
                
                if  let parseJSON = json {
                    let resultvalue = parseJSON["message"] as? String
                    print ("result: \(resultvalue)")
                    if(resultvalue == "successful") {
                        let data:Dictionary<String, AnyObject> = (parseJSON["data"] as? Dictionary)!
                        print(data)
                        print("inside proflie")
                        let f_name = data["first_name"] as? String
                        let l_name = data["last_name"] as? String
                        dispatch_async(dispatch_get_main_queue(), {
                            
                        })
                        //return name
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            //[self.viewDidLoad()]
                        })
                        
                    }
                    
                }
                //tableView.reloadData()
                
            } catch {
                print(error)
            }
        }
        
        task.resume()
        //        let first_name = info[0]["first_name"] as! String
        //        let last_name = info[0]["last_name"] as! String
        //
        name.text = f_name + l_name
        
    }
    

}
