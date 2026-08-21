//  MyRequestVC.swift
//  NewOffNet
//  Created by Ankit Rana on 17/08/22.


import UIKit
import Alamofire
import SwiftyJSON

class MyRequestVC: UIViewController {
  
   
    @IBOutlet weak var btn_Od: Gradientbutton!
    @IBOutlet weak var btn_Leave: Gradientbutton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                self.title = "  My Request"
                self.btn_Leave.setTitle("  Leave", for: .normal)
                self.btn_Od.setTitle("  Regularization", for: .normal)
             //   self.btnCO.setTitle("  Comp Off", for: .normal)
                //self.btn_SL.setTitle("  Short Leave", for: .normal)
                
            }
            else
            {
                self.title = "  मेरा अनुरोध"
                self.btn_Leave.setTitle("  छुट्टी", for: .normal)
                self.btn_Od.setTitle("  नियमितीकरण", for: .normal)
               
                //self.btn_SL.setTitle("  कम व़क्त की छुट्टी", for: .normal)
            }
        }

    }
    
    @IBAction func btn_Leave(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Leave", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "RequestDetailsVC")as! RequestDetailsVC
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    @IBAction func btn_Ar(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AR", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ODRequestDetailsVC")as! ODRequestDetailsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
//    @IBAction func btn_ComOff(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CORequestVC")as! CORequestVC
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    @IBAction func btn_ShortLeave(_ sender: Any) {
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SL_MyRequest")as! SL_MyRequest
//        self.navigationController?.pushViewController(vc, animated: true)

  //  }
}
