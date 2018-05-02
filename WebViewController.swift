//
//  WebViewController.swift
//  getitdone
//
//  Created by Akhil Yaragangu on 12/16/16.
//  Copyright © 2016 Akhil Yaragangu. All rights reserved.
//

import UIKit


class WebViewController: UIViewController {
 
    var selected_question: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()

    
    @IBOutlet weak var activity_indicator: UIActivityIndicatorView!
    @IBOutlet weak var weblink: UIWebView!
       override func viewDidLoad() {
        super.viewDidLoad()
        let originalString = selected_question["url"] as? String
        let customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
        let url_text = originalString!.stringByRemovingPercentEncoding!
        print("escapedString: \(url_text)")
        print(selected_question)
        
        let link = selected_question["url"] as? String
        print("link")
        let url = NSURL(string: link!)
        let requestObj = NSURLRequest(URL: url!);
        weblink.loadRequest(requestObj);
        weblink.scrollView.contentInset = UIEdgeInsets(top: -250, left: 0, bottom: -960, right: 0)
        weblink.scrollView.bounces = false
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
        
    }
    func webViewDidStartLoad(webView: UIWebView) {
        print("started")
        
        
        
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        print("Ended")
        
        
        webView.hidden = false
        activity_indicator.stopAnimating()
        activity_indicator.hidesWhenStopped = true
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
