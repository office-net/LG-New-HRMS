//
//  DNotesVC.swift
//  IndiaSteel
//
//  Created by Netcommlabs on 20/04/23.
//

import UIKit
import SemiModalViewController

class DNotesVC: UIViewController{
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btn_Loging(_ sender: Any)
        {
            let defaults = UserDefaults.standard
            defaults.set("English", forKey: "Language")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        }
    
    

    
    @IBAction func btn_Gignup(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "regViewController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    
}
