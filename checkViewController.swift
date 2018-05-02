//
//  checkViewController.swift
//  getitdone
//
//  Created by Akhil Yaragangu on 11/20/16.
//  Copyright © 2016 Akhil Yaragangu. All rights reserved.
//

import UIKit

class checkViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       

    }
    
    
    override func viewDidAppear(animated: Bool)
        
    {
        let logindetails = NSUserDefaults.standardUserDefaults()
        let student_id = logindetails.stringForKey("studnet_id")
        if ((student_id) == " ") {
            self.performSegueWithIdentifier("checking", sender: self);
        } else {
        self.performSegueWithIdentifier("logincheck", sender: self);
    
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
