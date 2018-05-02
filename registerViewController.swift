//
//  registerViewController.swift
//  getitdone
//
//  Created by Akhil Yaragangu on 11/20/16.
//  Copyright © 2016 Akhil Yaragangu. All rights reserved.
//

import UIKit
 var deptlist     : [[String: AnyObject]] = []

class registerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var create: UIButton!
    var selectedStudent: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
    
    var editInProgress:UITextField?
    
    @IBOutlet weak var userid: UITextField!
    @IBOutlet weak var upassword: UITextField!
    
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var userreenterpassword: UITextField!
    
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var department: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

       department.keyboardType = .Default
        _ = getdept()
        //let dept = deptlist
        //var delegate = deptlist
        
        let dept_picker = UIPickerView()
        //[self.viewDidLoad()]
        department.inputView = dept_picker
        dept_picker.delegate = self
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func create_user(sender: AnyObject) {
        let student_id = userid.text;
        let student_password = upassword.text;
        let student_reenterpass = userreenterpassword.text;
        
        
        if(student_id!.isEmpty || student_password!.isEmpty || student_reenterpass!.isEmpty)
        {
            dispalyalertmessage("all fields required");
            return;
        }
        if (student_password?.characters.count <= 6) {
            dispalyalertmessage("Enter password atleast with 6 characters");
            return;
        }
        // check the same password for both fields
        if (student_password != student_reenterpass) {
            dispalyalertmessage("password doesn't match");
            return;
        }
        
        register(student_id!, pass : upassword.text!, f_name : firstname.text!, l_name : last_name.text!, dept: department.text!)
        
    }
    var dept_picker = UIPickerView()
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func dispalyalertmessage (userMessage: String) {
        
        let myalert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        let okAction = UIAlertAction(title:"ok", style:UIAlertActionStyle.Default, handler:nil);
        myalert.addAction(okAction);
        self.presentViewController(myalert, animated:true, completion:nil);
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return deptlist.count
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return deptlist[row]["department_name"] as? String
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
     department.text = deptlist[row]["department_name"] as? String
    
    create.enabled = true
    
    }
    
    
    func dismissKeyboard()  {
        editInProgress?.resignFirstResponder()
    }

    
    func register(student_id : String, pass : String, f_name : String, l_name : String, dept : String) {
        let myUrl =  "http://localhost:8888/register.php";
        let url = NSURL(string:myUrl)
        let request = NSMutableURLRequest (URL: url!)
        print("======register==========")
        request.HTTPMethod = "POST"
        let postString = "student_id=" + student_id + "&pass=" + pass + "&f_name=" + f_name + "&l_name=" + l_name + "&dept=" + dept;
        print("=========");
        print("")
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest (request){
            data, response, error in
            
            print("inside task")
            if error != nil
            {
                print("error=\(error)")
                return
            }
            print("response = \(response)")
            print("\n")
            response
            
            let responseString =  NSString (data: data!, encoding: NSUTF8StringEncoding)
            print ("response String: \(responseString)");
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers
                    ) as? NSDictionary
                
                if  let parseJSON = json {
                    let resultvalue = parseJSON["Message"] as? String
                    print ("resultvalue:\(resultvalue)")
                    
                    //var isUserlogin:Bool = false;
                    if(resultvalue == "register successfull") {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            if (resultvalue == "user already in use"){
                                
                                let myAlert = UIAlertController(title: "Alert", message:"user alreday_exists", preferredStyle: UIAlertControllerStyle.Alert);
                                let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.Default){
                                    action in self.dismissViewControllerAnimated(true, completion: nil);
                                }
                                
                                myAlert.addAction(okAction);
                                
                                self.presentViewController(myAlert, animated: true, completion: nil)
                                
                                
                            } else {
                                
                                let myAlert = UIAlertController(title: "Alert", message:"some problem in database", preferredStyle: UIAlertControllerStyle.Alert);
                                let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.Default){
                                    action in self.dismissViewControllerAnimated(true, completion: nil);
                                }
                                
                                myAlert.addAction(okAction);
                                
                                self.presentViewController(myAlert, animated: true, completion: nil)
                            }
                        })
                        
                    }
                }
                
            } catch {
                print(error)
            }
            
            
        }
        task.resume()
        
        
    }
    
    func getdept() {
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
                            deptlist = department
                             }
                    }
                } else {
                    
                   dispatch_async(dispatch_get_main_queue(), {
                
                [self.viewDidLoad()]
                    } )
                }
                
            } catch {
                print(error)
            }
        }
        
        task.resume()

        
    }
    
    
}

