//
//  questionViewController.swift
//  getitdone
//
//  Created by Akhil Yaragangu on 12/3/16.
//  Copyright © 2016 Akhil Yaragangu. All rights reserved.
//

import UIKit
import UIKit
import CoreData
import AVFoundation
import MediaPlayer

class questionpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate {
    var selected_question: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>() {
        didSet {
            print("questionpViewController - set value for selected_question")
            print(self.selected_question)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("'''''''''''''''''''''''''''''")
        self.title = (selected_question["question"] as? String)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        
        // self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController!.popViewControllerAnimated(true)
    }
    @IBOutlet weak var question_text: UITextView!
    
    @IBOutlet weak var url: UITextField!
    @IBAction func edit_save(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/edit.php")!)
        request.HTTPMethod = "POST"
        let logindetails = NSUserDefaults.standardUserDefaults()
        let studnet_id = logindetails.stringForKey("studnet_id")
        print(studnet_id)
        let myString : String = question_text.text
        print("in quesiton posting")
        
        
        let dept = logindetails.stringForKey("department")
        print(dept)
        print("to get dpet")
        let postString = "student_id=" + studnet_id! + "&dept=" + dept! + "&context=" + myString
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
                        }
                    }
                    
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
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBOutlet weak var edit_save: UIButton!
    @IBAction func save(sender: AnyObject) {
        //let myString : String = question_text.text
        print("in quesiton posting")
        //if(question_text.text!.isEmpty){
        if(url.text!.isEmpty)
        {
            dispalyalertmessage("please provide text");
            return;
        
        }
        
        print(selected_question)
        var id_post = "1"
        if((selected_question["question_id"] as? String) != nil) {
            self.navigationController!.popViewControllerAnimated(true)
            id_post = "2"
        }
        post(id_post)
        navigationController!.popViewControllerAnimated(true)
        
        
    }
    
    @IBAction func save_button(sender: AnyObject) {
        var id_post = "1"
        if(question_text.text!.isEmpty) {
        if(url.text!.isEmpty)
        {
            dispalyalertmessage("please provide text");
            return;
        }
        }
        if((selected_question["question_id"] as? String) != nil) {
            self.navigationController!.popViewControllerAnimated(true)
            id_post = "3"
        }
        post(id_post)
        
        
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        myPickerController.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
        
    {
        let metadata = info[UIImagePickerControllerMediaMetadata] as? NSDictionary
        print(metadata)
        
        myImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var capturePhoto: UIButton!
    
    func dispalyalertmessage (userMessage: String) {
        
        let myalert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        let okAction = UIAlertAction(title:"ok", style:UIAlertActionStyle.Default, handler:nil);
        myalert.addAction(okAction);
        self.presentViewController(myalert, animated:true, completion:nil);
        
    }
    
    func post(id_post: String) {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/post.php")!)
        request.HTTPMethod = "POST"
        let myString = question_text.text
        let logindetails = NSUserDefaults.standardUserDefaults()
        let studnet_id = logindetails.stringForKey("studnet_id")
        print(studnet_id)
        var url_text = url.text!
        if (url_text == "") {
        url_text = "NULL"
            
        } else {
            let originalString = url.text
            let customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
            url_text = originalString!.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
            
            print("escapedString: \(url_text)")
//            url_text = originalString!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
//            print("escapedString: \(url_text)")
        }
        
        
        let dept = logindetails.stringForKey("department")
        print(dept)
        //let question_id = selected_question["question_id"] as? String
        
        if (id_post == "1") {
            let question_id = "1"
            let postString = "id=" + id_post + "&student_id=" + studnet_id! + "&dept=" + dept! + "&context=" + myString + "&question_id+" + question_id + "&url=" + url_text
            
            //+ "question_id=" + question_id?
            print(postString)
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        } else if (id_post == "2") {
            
            let question_id = selected_question["question_id"] as? String
            let postString = "id=" + id_post + "&student_id=" + studnet_id! + "&dept=" + dept! + "&context=" + myString + "&question_id=" + (question_id)! + "&url_text=" + url_text
            print(postString)
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        } else {
            let question_id = selected_question["question_id"] as? String
            let postString = "id=" + id_post + "&student_id=" + studnet_id! + "&dept=" + dept! + "&context=" + myString + "&question_id=" + question_id! + "&url_text=" + url_text
            print(postString)
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        
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
                    
                    let resultvalue = parseJSON["Message"] as? String
                    
                    if(resultvalue == "successful") {
                        if (parseJSON["data"] as? [[String: AnyObject]]) != nil {
                            // getdata = data
                        }
                    }
                    
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
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
}
