//
//  LogOutViewController.swift
//  NewOffNet
//
//  Created by Ankit Rana on 07/06/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class LogOutViewController: UIViewController {
var msg = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
        if Language == "English"
            {
            self.navigationItem.title = "Log Out"
            self.msg = "Are you sure you want to Exit?"
           
        }
            else
            {
                self.navigationItem.title = "लॉग आउट"
                self.msg = " क्या आप निसंदेह बाहर निकलना चाहते हैं?"
                
            }
        }
        
       
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let alertController = UIAlertController(title:base.Title, message: msg, preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: base.yes, style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.logoutApi()
            
        }
        let action1 = UIAlertAction(title: base.cancel, style: .default, handler: { (action) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            
        })
    
    
        // Add the actions
        alertController.addAction(okAction)
    alertController.addAction(action1)
        // Present the controller
        DispatchQueue.main.async {
            
            self.present(alertController, animated: true)
        }
        
        
        
    }
    

    func logoutApi()
    {
        var parameters:[String:Any]?
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        AF.request( base.url+"LogoutAuth", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable (of:JSON.self) { response in
                
                switch response.result
                {
                    
                case .success(let Value):
                    let json:JSON = JSON(Value)
                    print(json)
                    let status = json["Status"].intValue
                    let Message = json["Message"].stringValue
                    
                    if status == 1 {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        UserDefaults.standard.set("False", forKey: "IsLogin") 
                        UserDefaults.standard.set("a", forKey: "Lat")
                        UserDefaults.standard.set("a", forKey: "Long")//setObject
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.pushToLoginVc()
                            
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            
                            self.present(alertController, animated: true)
                        }
                    }
                    else{
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
            }
        
    }
    
    func pushToLoginVc()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }

}
