//
//  LoginVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 08/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var imgLoader: UIImageView!
    
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var txt_empcode: UITextField!
    @IBOutlet weak var txt_pass: UITextField!
    @IBOutlet weak var btn_signin: UIButton!
    @IBOutlet weak var mid_view: UIView!
    @IBOutlet weak var btnPasswordHideShow: UIButton!
    
    
    //=================Titles ===================
    
    @IBOutlet weak var TLogin: UILabel!
    @IBOutlet weak var CaraftedBY: UILabel!
    @IBOutlet weak var NetcomLabs: UILabel!
    @IBOutlet weak var Version: UILabel!
    var PleaseEnterEmpCode = ""
    var Please_Enter_Password = ""
    
    
    var isPasswordHide = true
    var deviceid = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        let id  = UIDevice.current.identifierForVendor!.uuidString
        self.deviceid = id
        txt_pass.layer.cornerRadius = 5
        txt_empcode.layer.cornerRadius = 5
        txt_pass.layer.borderWidth = 1
        txt_empcode.layer.borderWidth = 1
        
        
        if let Language = UserDefaults.standard.string(forKey: "Language") {
        if Language == "English"
            {
               
              self.Translate(index: 0)
            
            }
            else
            {
                
               self.Translate(index: 1)
                
            }
        }
        
    }
    
    
    
    
    
    
    
    
    @IBAction func btn(_ sender: UIButton) {
        
        if txt_empcode.text == ""{
            self.showAlert(message: PleaseEnterEmpCode)
        }
        else if txt_pass.text == ""{
            self.showAlert(message: Please_Enter_Password)
        }
        else {
         
            SignApi()
            
            }
        
        
    }
    
    @IBAction func btn_hidepass(_ sender: Any) {
        if isPasswordHide{
            self.txt_pass.isSecureTextEntry = false
            isPasswordHide = false
            btnPasswordHideShow.setImage(UIImage(named: "hidePassword"), for: .normal)
        }
        else {
            self.txt_pass.isSecureTextEntry = true
            isPasswordHide = true
            
            btnPasswordHideShow.setImage(UIImage(named: "showPassword"), for: .normal)
        }
        
    }
    
    
    @IBAction func btn_ForgotPass(_ sender: Any) {
        if txt_empcode.text == ""{
            self.showAlert(message: "Please enter emp code")
        }
        else {
            forgotPass()
        }
        
    }
    func forgotPass()
    {
        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserName":txt_empcode.text ?? "" ]
        
        
        
        AF.request(base.url+"ForgetPassword", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable (of:JSON.self) { response in
                switch response.result
                {
                    
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    
                    DispatchQueue.main.async {
                        let  Message = json["Message"]
                        
                        self.showAlert(message:Message.stringValue )
                        
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }}
    
    
    func SendToHome()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    func SignApi()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        
        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","LoginID":txt_empcode.text ?? "","Password":self.txt_pass.text ?? "","IMEINo":"0","DeviceName":"","DeviceID":self.deviceid]
        
        AF.request(base.url+"UsersAuth", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable (of:JSON.self) { response in
                print(response.request!)
                print(parameters)
                switch response.result
                {
                    
                case .success(let value):
                        let json = JSON(value)
                        print(json)
                    let  ChangePWDDATE = json["ChangePwdDate"].stringValue
                                       
                     UserDefaults.standard.set(ChangePWDDATE, forKey: "ChangePWDDate")
                        let  UserID = json["UserID"].intValue
                        if UserID != 0 {
                        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
                        let Attendanceinput = json["AttendanceInput"].stringValue
                        UserDefaults.standard.set(Attendanceinput, forKey: "AttendanceInput")
                        
                        let  Designation = json["Designation"].stringValue
                        UserDefaults.standard.set(Designation, forKey: "Designation")
                        
                        let  BloodGroup = json["BloodGroup"].stringValue
                        UserDefaults.standard.set(BloodGroup, forKey: "BloodGroup")
                        
                        let  UserName = json["UserName"].stringValue
                        UserDefaults.standard.set(UserName, forKey: "UserName")
                        
                        let  EmployeeStatus = json["EmployeeStatus"].stringValue
                        UserDefaults.standard.set(EmployeeStatus, forKey: "EmployeeStatus")
                        
                        let  Location = json["Location"].stringValue
                        UserDefaults.standard.set(Location, forKey: "Location")
                        
                        
                        let  EmpCode = json["EmpCode"].stringValue
                        
                        UserDefaults.standard.set(EmpCode, forKey: "EmpCode")
                        
                        
                        let  Gender = json["Gender"].stringValue
                        
                        UserDefaults.standard.set(Gender, forKey: "Gender")
                        
                        let  Title = json["Title"].stringValue
                        
                        
                        UserDefaults.standard.set(Title, forKey: "Title")
                        
                        let  PlantID = json["PlantID"].stringValue
                        
                        
                        UserDefaults.standard.set(PlantID, forKey: "PlantID")
                        
                        let  ReportingManager = json["ReportingManager"].stringValue
                        
                        
                        UserDefaults.standard.set(ReportingManager, forKey: "ReportingManager")
                        
                        let  MobileNo = json["MobileNo"].stringValue
                        
                        
                        UserDefaults.standard.set(MobileNo, forKey: "MobileNo")
                        
                        
                        let  Message = json["Message"].stringValue
                        
                        
                        
                        UserDefaults.standard.set(Message, forKey: "Message")
                        
                        let  Grade = json["Grade"].stringValue
                        
                        
                        UserDefaults.standard.set(Grade, forKey: "Grade")
                        
                        
                        UserDefaults.standard.set(UserID, forKey: "UserID")
                        
                        let  DateOfJoining = json["DateOfJoining"].stringValue
                        
                        
                        UserDefaults.standard.set(DateOfJoining, forKey: "DateOfJoining")
                        
                        let  PlantName = json["PlantName"].stringValue
                        
                        
                        UserDefaults.standard.set(PlantName, forKey: "PlantName")
                        
                        let  AttendanceInput = json["AttendanceInput"].stringValue
                        
                        
                        UserDefaults.standard.set(AttendanceInput, forKey: "AttendanceInput")
                        
                        let  EmailID = json["EmailID"].stringValue
                        
                        
                        UserDefaults.standard.set(EmailID, forKey: "EmailID")
                        
                        let  LocationCode = json["LocationCode"].stringValue
                        
                        
                        UserDefaults.standard.set(LocationCode, forKey: "LocationCode")
                        
                        let  Status = json["Status"].stringValue
                        
                        
                        UserDefaults.standard.set(Status, forKey: "Status")
                        
                        let  Department = json["Department"].stringValue
                        
                        
                        UserDefaults.standard.set(Department, forKey: "Department")
                        
                        let  ImageURL = json["ImageURL"].stringValue
                        
                        UserDefaults.standard.set(ImageURL, forKey: "ImageURL")
                        
                        
                        let  HeadOfDepartment = json["HeadOfDepartment"].stringValue
                        
                        
                        UserDefaults.standard.set(HeadOfDepartment, forKey: "HeadOfDepartment")
                        
                        let  DateOfBirth = json["DateOfBirth"].stringValue
                        
                        UserDefaults.standard.set(DateOfBirth, forKey: "DateOfBirth")
                        
                        
                        UserDefaults.standard.set("True", forKey: "IsLogin")
                        
                        
                            if json["ChangePwdDate"].stringValue == "" {
                                print("calkndalsbfdffnjdnfjjfnffnjnf")
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                       let mainTabBarController = storyboard.instantiateViewController(identifier: "ChangePasswordVC")
                                       (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                            }
                            else {
                                print("No Need to change Password")
                                DispatchQueue.main.async {
                                    self.SendToHome()
                                }
                            }
                    }
                    else{
                        
                        DispatchQueue.main.async {
                            let  Message = json["Message"]
                            CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                            self.showAlert(message:Message.stringValue )
                            
                        }
                        
                    }
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
            }
        
        
        
        
    }
    
    
    
    
    
    
}



extension LoginVC
{
    func Translate(index:Int)
    {
       if index == 0
        {
            TLogin.text = "Login Into Your Account"
            CaraftedBY.text = "Crafted By"
            NetcomLabs.text = "Netcomm Labs Pvt Ltd"
            Version.text = "Version \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")"
            PleaseEnterEmpCode = "Please Enter User Name" 
            Please_Enter_Password = "Please Enter Password"
        }
        else
        {
            TLogin.text = "लॉगिन करें"
            CaraftedBY.text = "नेटकॉम लैब्स प्राइवेट लिमिटेड"
            NetcomLabs.text = "द्वारा तैयार किया गया"
            Version.text = "संस्करण \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")"
            txt_empcode.placeholder = "उपयोगकर्ता कोड"
            txt_pass.placeholder = "पासवर्ड"
            btn_signin.setTitle("लॉग इन करें", for: .normal)
             PleaseEnterEmpCode = "कृपया उपयोगकर्ता कोड दर्ज करें"
             Please_Enter_Password = "कृपया पासवर्ड दर्ज करें"
            
        }
    }
}



