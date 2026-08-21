//
//  WebViewController.swift
//  HRMS Trivitron
//
//  Created by Ankit Rana on 10/11/23.
//

import UIKit
import WebKit
class WebViewController: UIViewController,WKNavigationDelegate {
 
     
    @IBOutlet weak var webView: WKWebView!
    
     var urlString = ""
     
     override func loadView() {
         super.loadView()
         
         // Create WKWebView
     
         webView.navigationDelegate = self
      
     }
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         // Load the URL when the view controller is loaded
         loadURL()
     }
  
     func loadURL() {
         if let url = URL(string: urlString) {
             let request = URLRequest(url: url)
             webView.load(request)
         }
     }
     
     // MARK: - WKNavigationDelegate
     
     // You can implement WKNavigationDelegate methods if needed
     
 }
