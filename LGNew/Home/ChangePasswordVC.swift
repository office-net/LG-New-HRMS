//
//  ChangePasswordVC.swift
//  NewOffNet
//
//  Created by Netcommlabs on 30/12/22.
//

import UIKit
import SwiftyJSON

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var btnChangePass: Gradientbutton!
    @IBOutlet weak var btnConfirmPass: UIButton!
    @IBOutlet weak var btnNewPass: UIButton!
    @IBOutlet weak var btnOldPass: UIButton!
    @IBOutlet weak var txtConfirmNewPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtOldPass: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Change Password"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func oldPass(_ sender: Any) {
        self.HideShowPass(TextField: txtOldPass, button: btnOldPass)
    }
    
    @IBAction func newPass(_ sender: Any) {
        self.HideShowPass(TextField: txtNewPass, button: btnNewPass)
    }
    
    @IBAction func confrmPass(_ sender: Any) {
        self.HideShowPass(TextField: txtConfirmNewPass, button: btnConfirmPass)
    }
    
    @IBAction func btnChangePass(_ sender: Any) {
        Validation()
    }
    
}

extension ChangePasswordVC
{
    func HideShowPass(TextField:UITextField,button:UIButton)
    {
        if TextField.isSecureTextEntry == true
          {
              TextField.isSecureTextEntry = false
            button.setImage(UIImage(named: "showPassword"), for: .normal)
          }
          else
          {
              TextField.isSecureTextEntry = true
              button.setImage(UIImage(named: "hidePassword"), for: .normal)
          }
    }
    
    func Validation()
    {
        if txtOldPass.text == ""
        {
            self.showAlert(message: "Please Enter Old Password First")
        }
        else if txtNewPass.text == ""
        {
            self.showAlert(message: "Please Enter New Password")
        }
        else if txtConfirmNewPass.text == ""
        {
            self.showAlert(message: "Please Enter Confirm Password")
        }
        else if txtConfirmNewPass.text != txtNewPass.text
        {
            self.showAlert(message: "Please Enter Same Password in Confirm Password Field")
        }
        else if txtNewPass.text!.count < 8
        {
            self.showAlert(message: "Password must be 8-10 in length")
        }
        else if txtNewPass.text!.count > 10
        {
            self.showAlert(message: "Password must be 8-10 in length")
        }
        else
        {
            ApiCalling()
        }
        
    }
    func ApiCalling()
    {
        let parameters:[String:Any]
            let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        parameters = ["UID": UserID!, "TokenNo": "abcHkl7900@8Uyhkj","OLDPassword":txtOldPass.text!,"NewPassword":txtNewPass.text!]
        
        Networkmanager.postRequest(vv: self.view, remainingUrl:"ChangeEmpPassword", parameters: parameters) { (response,data) in
            
            print(response)
            let status = response["Status"].intValue
            let msg = response["Message"].stringValue
            if status == 1
            {
                let alertController = UIAlertController(title: base.Title, message: msg, preferredStyle: .alert)
           
                let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                    self.pushToLoginVc()
                }
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else
            {
                self.showAlert(message: msg)
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
