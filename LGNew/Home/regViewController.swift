//
//  regViewController.swift
//  NewOffNet
//
//  Created by Ankit Rana on 22/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON


class regViewController: UIViewController {
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_mobile: UITextField!
    @IBOutlet weak var txt_empcode: UITextField!
    @IBOutlet weak var txt_pass: UITextField!
    @IBOutlet weak var txt_DOB: UITextField!
    @IBOutlet weak var txt_joining: UITextField!
    @IBOutlet weak var txt_location: UITextField!
    
    @IBOutlet weak var btn_subbmit: UIButton!
    @IBOutlet weak var btnPasswordHideShow: UIButton!
    let datePicker =  UIDatePicker()
    
    var isPasswordHide = true
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_subbmit.layer.borderWidth = 4
        btn_subbmit.layer.borderColor = UIColor.white.cgColor
        btn_subbmit.layer.cornerRadius = 5
        showDatePicker()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_Back(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "DNotesVC")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    
    
    
    
    
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txt_DOB.inputAccessoryView = toolbar
        txt_DOB.inputView = datePicker
        txt_joining.inputAccessoryView = toolbar
        txt_joining.inputView = datePicker
        
    }
    @objc func donedatePicker(){
        if txt_joining.isFirstResponder
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            txt_joining.text = formatter.string(from: datePicker.date)
            
        }
        else if txt_DOB.isFirstResponder
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            txt_DOB.text = formatter.string(from: datePicker.date)
            
        }
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    @IBOutlet weak var back_btn: UINavigationItem!
    @IBAction func back_btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_hide_show(_ sender: Any) {
        if isPasswordHide{
            self.txt_pass.isSecureTextEntry = false
            isPasswordHide = false
            btnPasswordHideShow.setImage(UIImage(named: "showPassword"), for: .normal)
        }
        else {
            self.txt_pass.isSecureTextEntry = true
            isPasswordHide = true
            btnPasswordHideShow.setImage(UIImage(named: "hidePassword"), for: .normal)
        }
        
    }
    @IBAction func btn_submit(_ sender: UIButton) {
        if txt_name.text == ""
        {
            alert(msg: "Enter Name ")
        }

        else if txt_empcode.text == ""
        {
            alert(msg: "Enter Emp code ")
        }
        else if txt_pass.text == ""
        {
            alert(msg: "Enter Passward")
        }
     
           else
        {
        
            self.submitApi()
        }
    }
    
    
    
    
        func alert(msg:String)
        {     let massage =  msg
            let alert = UIAlertController(title: "Alert", message: massage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        func isValidEmail(email: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email)
        }
        
 
    
    
    func submitApi()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        
        let parameters  = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"","Password":self.txt_pass.text!,"EmailId":"Ankit@gamil.com","UserName":txt_name.text!,"EmpCode":self.txt_empcode.text!,"DateOFBirth":"01/07/1991","DateOfJoining":"01/07/1991","LocationId":"0","MobileNo":"9876543212"]
        AF.request(base.url+"UpdateUserDetails", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result
                {
                    
                case .success(let value):
                    let json:JSON = JSON(value)
                    print(json)
                    print(response.request!)
                    print(parameters)
                    let status = json["Status"].intValue
                    if status == 1
                    { CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let Message = json["Message"].stringValue
                        
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            
                                let defaults = UserDefaults.standard
                                defaults.set("English", forKey: "Language")
                                
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let mainTabBarController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
                                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true)
                        }
                    }
                    else
                    {  CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let msg = json["Message"].stringValue
                        self.showAlert(message: msg)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        
        
    }

}




