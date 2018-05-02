//
//  emailViewController.swift
//  getitdone
//
//  Created by Akhil Yaragangu on 12/10/16.
//  Copyright © 2016 Akhil Yaragangu. All rights reserved.
//
import Foundation
import UIKit
import MessageUI

class emailViewController: UIViewController,MFMailComposeViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate {
    var selected_question: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
    
    
    @IBOutlet weak var bodytext: UITextView!
   // @IBOutlet weak var subjectText: UITextView!
    @IBOutlet weak var subjectText: UITextField!
    @IBAction func sendEmail(sender: AnyObject)  {
        let mailCompose = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(subjectText.text!)
        mailCompose.setMessageBody(bodytext.text, isHTML: true)
        
        presentViewController(mailCompose, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "free.png")!)
        print(selected_question)
        subjectText.delegate = self
        bodytext.delegate = self
        self.title = selected_question["answered by"] as? String
        print(selected_question["answered by"] as? String)
        print("in email view contro")
        print(selected_question)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // UITextFieldDelegate
    
    // 2
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // UITextViewDelegate
    
    // 3
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        bodytext.text = textView.text
        
        if text == "\n" {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }
}