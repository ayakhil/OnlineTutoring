//
//  firebaseloginViewController.swift
//  getitdone
//
//  Created by Akhil Yaragangu on 12/14/16.
//  Copyright © 2016 Akhil Yaragangu. All rights reserved.
//

import UIKit
import Firebase

class firebaseloginViewController: UIViewController,UITextFieldDelegate, UITableViewDelegate {
    
    var selected_question: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
    
   

    @IBOutlet weak var sendtext: UITextField!
    
    @IBAction func send(sender: AnyObject) {
        handleSend()
    }
      override func viewDidLoad() {
        super.viewDidLoad()
        sendtext.placeholder = "Enter message..."
        print("inside firbe chat")
        
        let user = selected_question["question_id"] as? String
        print(selected_question)
                    navigationItem.title = user
        observemessage()
//        let ref = FIRDatabase.database().referenceFromURL("https://getitdone-34c1b.firebaseio.com/")
//        // Do any additional setup after loading the view.
//        ref.updateChildValues(["someviale": 123123])
    }
    var messages = [firebasevariables]()
    func observemessage() {
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observeEventType(.ChildAdded, withBlock: { (chat) in
            //print(chat)
            if let dictionary = chat.value as? [String: AnyObject] {
                let message = firebasevariables()
                message.setValuesForKeysWithDictionary(dictionary)
                self.messages.append(message)
                //print("akhil")
                print(message.text)
                
    dispatch_async(dispatch_get_main_queue(), {
                    //[self.viewDidLoad()]
                })
            }
            }, withCancelBlock: nil)
    }
   // override func tableview(tableview: UITableView, numberOfRownINsection)
    @IBOutlet weak var tableviewcell: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
//        
//        cell.textLabel?.text = self.items[indexPath.row]
//        
//        return cell
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func handleSend() {
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        //is it there best thing to include the name inside of the message node
        let  name = selected_question["answered by"]
        let values = ["text": sendtext.text!, "name": name!]
        childRef.updateChildValues(values)
        
        func textFieldShouldReturn(textField: UITextField) -> Bool {
            handleSend()
            return true
        }
    }
}
