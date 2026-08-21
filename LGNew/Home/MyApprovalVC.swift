//  MyApprovalVC.swift
//  NewOffNet
//  Created by Ankit Rana on 17/08/22.

import UIKit
import Alamofire
import SwiftyJSON

class MyApprovalVC: UIViewController {

   
    @IBOutlet weak var btn_Od: Gradientbutton!
    @IBOutlet weak var btn_Leave: Gradientbutton!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                self.title = "  My Approvals"
                self.btn_Leave.setTitle("  Leave", for: .normal)
                self.btn_Od.setTitle("  Regularization", for: .normal)
               // self.btnCO.setTitle("  Comp Off", for: .normal)
            }
            else
            {
                self.title = "  मेरी स्वीकृति"
                self.btn_Leave.setTitle("  छुट्टी", for: .normal)
                self.btn_Od.setTitle("  नियमितीकरण", for: .normal)
                
            }
        }
    }
    
    @IBAction func btn_Leave(_ sender: Any) {
     
        let storyboard = UIStoryboard(name: "Leave", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "PendingDetailVC")as! PendingDetailVC
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    @IBAction func btn_Ar(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AR", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ODPendingRequestVC")as! ODPendingRequestVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    
//    @IBAction func btn_ComOff(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "OD", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "COPendingVC")as! COPendingVC
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    @IBAction func btn_ShortLeave(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "SL", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "SL_Pending")as! SL_Pending
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
}
