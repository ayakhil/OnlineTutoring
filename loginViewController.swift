//
//  loginViewController.swift
//  getitdone
//
//  Created by Akhil Yaragangu on 11/20/16.
//  Copyright © 2016 Akhil Yaragangu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth



class loginViewController: UIViewController {
    
    var response_access : String = String()
    @IBOutlet weak var text_password: UITextField!
    
    @IBOutlet weak var student: UITextField!
    //let managedObjectContext =
      //  (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    @IBAction func create_login(sender: AnyObject) {
        self.performSegueWithIdentifier("register", sender: self)
    }
    @IBOutlet weak var button_go: UIButton!
    override func viewDidLoad() {
        //var login_student:String?

        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "Logo.gif")
//        let entityDescription = NSEntityDescription.entityForName("Profile_details", inManagedObjectContext: managedObjectContext)
//        let request = NSFetchRequest()
//        request.entity = entityDescription
//        student.text = ""
//        text_password.text = ""
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
   
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    @IBAction func login_access(sender: AnyObject) {
        print("inside Go button")
        
        
//        let entityDescription = NSEntityDescription.entityForName("Profile_details", inManagedObjectContext: managedObjectContext)
//        let student_profile = Profile_details(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        

        let myUrl =  "http://localhost:8888/access.php";
        let url = NSURL(string:myUrl)
        let request = NSMutableURLRequest (URL: url!)
        print("======access==========")
        request.HTTPMethod = "POST"
        let postString = "student_id=" + student.text! + "&pass=" + text_password.text!;
        print(postString)
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
                    let resultvalue = parseJSON["Message"] as? String
                    print ("result: \(resultvalue)")
                    if(resultvalue == "login successfull") {
                        let data:Dictionary<String, AnyObject> = (parseJSON["data"] as? Dictionary)!
                        print(data)
                        let department = data["department_name"] as? String
                        let f_name = data["first_name"] as? String
                        
                        let logindetails = NSUserDefaults.standardUserDefaults()
                        logindetails.setValue(self.student.text, forKey: "studnet_id")
                        //logindetails.setValue(self.text_password.text, forKey: "password")
                        logindetails.setValue(department!, forKey:  "department")
                        //logindetails.setvalue(f_name!, forKey: "firstname")
                        FIRAuth.auth()?.createUserWithEmail(self.student.text!, password: self.text_password.text!, completion: { (user, error) in
                           // FIRAuth.auth()?.createUserWithEmail(self.student.text!, password: self.text_password.text!, completion: { (user, error)  in
                                
                            if error != nil {
                                print(error)
                                return
                            }
                            guard let uid = user?.uid else {
                                return
                            }
                                    let ref = FIRDatabase.database().referenceFromURL("https://getitdone-34c1b.firebaseio.com/")
                            let usersReference = ref.child("users").child(uid)
                            
                            let values = ["name": f_name as! AnyObject, "email": self.student.text as! AnyObject]
                            
                            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                
                                if err != nil {
                                    print(err)
                                    return
                                }
                                
                                print("Saved user successfully into Firebase db")
                                
                                })
                                
                        })
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            self.performSegueWithIdentifier("loginaccess", sender: self);
                        }
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let myAlert = UIAlertController(title: "Alert", message:"wrong userid or password", preferredStyle: UIAlertControllerStyle.Alert);
                            let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.Default){
                                action in self.dismissViewControllerAnimated(true, completion: nil);
                            }
                            myAlert.addAction(okAction);
                            self.presentViewController(myAlert, animated: true, completion: nil)
                        })
                        
                    }
                }
                
            } catch {
                print(error)
            }
            
            
        }
        task.resume()
        
        
        
    }
    
    func get_login() {
        
        
        print("searchLocation");
        
        let urlPath = "http://localhost:8888/getlogindetails.php";
        //"https://iOS.d2msolutions.com/wrapper.php?action=getphotos"
        
        guard let endpoint = NSURL(string: urlPath) else { print("Error creating endpoint");return }
        print(endpoint)
        let request = NSMutableURLRequest(URL:endpoint)
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            do {
                print("data=");
                print(data);
                print("\n");
                guard let dat = data else { throw JSONError.NoData }
                print(dat); print("\n");
                
                guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options: []) as? NSDictionary else { throw JSONError.ConversionFailed }
                // print(json)
                let logindata = json["response"] as! NSArray
                
                print(logindata);
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch {
                print(error)
            }
            }
            .resume()
        
    }
    
    
    
    
    
    
    func dispalyalertmessage (userMessage: String) {
        
        let myalert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        let okAction = UIAlertAction(title:"ok", style:UIAlertActionStyle.Default, handler:nil);
        myalert.addAction(okAction);
        self.presentViewController(myalert, animated:true, completion:nil);
        
        
    }
    
    
    
    
    
    
    
}
