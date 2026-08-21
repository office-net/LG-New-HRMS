//
//  LauncherVC.swift
//  Myomax officenet
//
//  Created by Mohit Shrama on 29/06/20.
//  Copyright © 2020 Mohit Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class LauncherVC: UIViewController {


    var isnote = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
      //  apicalling()
        UiSetup()
        
        
    }
    
    
    
     
    
    
    

}


extension LauncherVC
{
    func apicalling()
    
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let parameters = ["TokenNo": "abcHkl7900@8Uyhkj"]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"RegistrationBtnStatus", parameters: parameters) { (response,data) in
            print("beforeeeeeee\(self.isnote)")
           self.isnote = response["ButtonStatus"].boolValue
           // self.isnote = true
            print("Afterrrrrrrr\(self.isnote)")
            self.UiSetup()
        }
 
    }
    
}


extension LauncherVC
{
    func UiSetup()
    {      if let Language = UserDefaults.standard.string(forKey: "Language") {
        
    
     if Language == "English"
        {
         base.Title = "LG HRMS"
         base.ok = "OK"
         base.cancel = "Cancel"
         base.yes = "Yes"
     }
        else
        {
            base.Title = "सूचना !"
            base.ok = "ठीक है"
            base.cancel = "रद्द करें"
            base.yes = "अनुमति दे"
        }
   
       
    }
    else
    {
        UserDefaults.standard.set("English", forKey: "Language")
        base.Title = "LG HRMS"
        base.ok = "OK"
        base.cancel = "Cancel"
        base.yes = "Yes"
       
    }
        
             let seconds = 4.0
             DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                 
                 if self.isnote == true
                 {
                     
                     if  let isLogin = UserDefaults.standard.object(forKey: "IsLogin") as? String{
                         print("==========================isLogin  \(isLogin)")
                         
                         if isLogin == "True"
                         {
                             let storyboard = UIStoryboard(name: "Main", bundle: nil)
                             let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                         }
                         else {
                             let defaults = UserDefaults.standard
                             defaults.set("English", forKey: "Language")
                             print("==========================  \(isLogin)")
                             let storyboard = UIStoryboard(name: "Main", bundle: nil)
                             let mainTabBarController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
                             (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                         }
                     }
                     
                     
                     else {
                         
                         let defaults = UserDefaults.standard
                         defaults.set("English", forKey: "Language")
                         let storyboard = UIStoryboard(name: "Main", bundle: nil)
                         let mainTabBarController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
                         (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                     }
                 }
                 else
                 {
                     print("==========================isLogin False")
                     
                     let isLogin = UserDefaults.standard.object(forKey: "IsLogin") as? String
                     if isLogin == "True"
                     {
                         let storyboard = UIStoryboard(name: "Main", bundle: nil)
                         let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                         (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                     }
                     else
                     {
                         
                         let storyboard = UIStoryboard(name: "Main", bundle: nil)
                         let mainTabBarController = storyboard.instantiateViewController(identifier: "DNotesVC")
                         (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                     }
                 }
                 
                 
             }
    }
}
