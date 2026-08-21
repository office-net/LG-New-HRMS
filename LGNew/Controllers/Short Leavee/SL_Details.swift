//
//  SL_Details.swift
//  Prince_Pipes_Newls
//
//  Created by Netcommlabs on 25/08/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class SL_Details: UIViewController {
    var dodo:JSON = []
    var json:JSON = []
    
    var IsFirstApprovalDetailsVisable = 0
    var IsApprovalbuttonVisable = 0
    
    var isFromCancelVC = false
    var isFromPendingVC = false
    var cancelbtn = 0
    var approvebtn = 0
    var disapprovebtn = 0
    
   
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lbl_department: UILabel!
   
   
    @IBOutlet weak var stkviewHight: NSLayoutConstraint!
    @IBOutlet weak var lbl_Empcode: UILabel!
    @IBOutlet weak var lblDesigination: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRequestNO: UILabel!
    @IBOutlet weak var lblSubbmitDate: UILabel!
    @IBOutlet weak var lblMOBO: UILabel!
    @IBOutlet weak var lbl_LeaveType: UILabel!
    @IBOutlet weak var lbl_FromDate: UILabel!
    @IBOutlet weak var lbl_ToDate: UILabel!

    @IBOutlet weak var lbl_SubbmitedBY: UILabel!
    @IBOutlet weak var lbl_Purpose: UILabel!
    @IBOutlet weak var midview: UIView!
    
    

    @IBOutlet weak var txt_Remark: UITextField!
    @IBOutlet weak var btn_Approve: UIButton!
    @IBOutlet weak var btn_DisApprove: UIButton!
    @IBOutlet weak var btn_Cancel: UIButton!
    
    @IBOutlet weak var RMStatus: UILabel!
    
    @IBOutlet weak var RMRemarks: UILabel!
    
   
    @IBOutlet weak var rmkHight: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var empcode: UILabel!
    @IBOutlet weak var department: UILabel!
    @IBOutlet weak var desigination: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var requestDetails: UILabel!
    @IBOutlet weak var requestnumber: UILabel!
    @IBOutlet weak var submitdate: UILabel!
    @IBOutlet weak var leavetype: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var fromdate: UILabel!
    @IBOutlet weak var todate: UILabel!

    @IBOutlet weak var submitBy: UILabel!
    @IBOutlet weak var puspose: UILabel!
    @IBOutlet weak var reporintmanager: UILabel!
    @IBOutlet weak var remarks: UILabel!
    @IBOutlet weak var lbl_Emp_DOJ: UILabel!
    @IBOutlet weak var lbl_RM_Name: UILabel!

    
    
    
    @IBOutlet weak var HodStatus: UILabel!
    @IBOutlet weak var HodRemark: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.midview.layer.borderWidth = 1
        self.midview.layer.borderColor =  #colorLiteral(red: 0, green: 0.3719885647, blue: 0.697519362, alpha: 1)
        txt_Remark.isHidden = true
        detailsVCAPI()
        self.lbl_LeaveType.text = "Permission"
        self.btn_Approve.isHidden = true
        self.btn_Cancel.isHidden = true
        self.btn_DisApprove.isHidden = true
        self.txt_Remark.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnApprove(_ sender: Any) {
        ApproveAPI()
    }
    
    
    @IBAction func btnDisapprove(_ sender: Any) {
        if txt_Remark.text == ""
        {
            showAlert(message: " Please Enter Remark First")
        }
        else
        {
            self.DisApproveAPI()
        }
    }
    
    @IBAction func btnCancle(_ sender: Any) {
        self.CancelApi()
    }
    
    
    func detailsVCAPI()
    {   CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqID":self.dodo["ReqID"].stringValue ,"Type":self.dodo["Type"].stringValue]
        AF.request( base.url+"SL_ViewRequestDetails", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable (of:JSON.self) { response in
                
                switch response.result
                {
                
                case .success(let Value):
                    self.json = JSON(Value)
                    print(self.json)
                    print(response.request!)
                    print(parameters)
                    let status =  self.json["Status"].intValue
                    if status == 1
                    {
                    self.lblName.text = self.json["EmpName"].stringValue
                    self.lbl_Empcode.text = self.json["EmpCode"].stringValue
                    self.lbl_department.text = self.json["EmpDepartment"].stringValue
                    self.lblDesigination.text = self.json["EmpDesignation"].stringValue
                    self.lblAddress.text = self.json["EmpLocation"].stringValue
                    self.lblRequestNO.text = self.json["ReqNo"].stringValue
                    self.lblSubbmitDate.text = self.json["ReqDate"].stringValue
                    self.lbl_FromDate.text = self.json["FromTime"].stringValue
                    self.lbl_ToDate.text = self.json["ToTime"].stringValue
                    self.lblMOBO.text = self.json["ContactNo"].stringValue
                    self.lbl_LeaveType.text = self.json["LeaveDate"].stringValue
                    self.lbl_RM_Name.text = self.json["RMName"].stringValue
                    self.lbl_Emp_DOJ.text = self.json["EmpDOJ"].stringValue
                 
                    self.RMStatus.text = self.json["RMStatus"].stringValue
                        let color1 = self.json["RMStatus"].stringValue
                        if color1.contains("Rejected") || color1.contains("NA") ||  color1.contains("Pending")
                        {
                            self.RMStatus.textColor = UIColor.red
                        }
                        else{
                            self.RMStatus.textColor = UIColor.green
                        }
                    self.RMRemarks.text = self.json["Approver1_Remarks"].stringValue
                   
                    self.cancelbtn = self.json["IsCancelButtonVisable"].intValue
                    self.approvebtn = self.json["IsApprovalbuttonVisable"].intValue
                        
                        print("===========================================\(self.approvebtn)")
                        
                    self.lbl_SubbmitedBY.text = self.json["SubmitBy"].stringValue
                    self.disapprovebtn = self.json["IsCancelButtonVisable"].intValue
                    self.lbl_Purpose.text = self.json["Purpose"].stringValue
                    self.RMRemarks.text = self.json["Approver1_Remarks"].stringValue
                        
                        
                        //self.HodStatus.text = self.json["HODStatus"].stringValue
                        //self.HodRemark.text = self.json["Approver2_Remarks"].stringValue
                        
                        
                        
                        
                        
                    //  ----------------------CANCEL BTN ----------------------
                    if self.cancelbtn == 1
                    {self.btn_Cancel.isHidden = false
                        self.txt_Remark.isHidden = false
                       
                      
                        
                    }
                    else
                    {
                        self.btn_Cancel.isHidden = true
                        self.rmkHight.constant = 0
                        
                       // self.stkviewHight.constant = 0
                        
                    }
                    //-------------------APPROVE BTN-----------------------------------
                    if self.approvebtn == 1
                    
                    {   self.btn_DisApprove.isHidden = false
                        self.btn_Approve.isHidden = false
                        self.txt_Remark.isHidden = false
                        self.rmkHight.constant = 40
                    }
                    else
                    {
                        self.btn_Approve.isHidden = true
                        self.btn_DisApprove.isHidden = true
                        self.rmkHight.constant = 0
                       // self.stkviewHight.constant = 0
                        
                    }
                
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                    }
                    
                    else
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let msg =  self.json["Message"].stringValue
                        self.showAlert(message: msg)
                        
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
                
            }
    }
    func ApproveAPI()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let Req_No = self.json["ReqID"].stringValue
        let type =  self.dodo["Type"].stringValue
       
        
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqID":Req_No,"UserID":UserID,"Type":type,"Remarks":self.txt_Remark.text!]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqNo":Req_No]
        }
        AF.request( base.url+"SL_ApproveRequest", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable (of:JSON.self) { response in
                switch response.result
                {
                case .success(let rana):
                    let json:JSON = JSON(rana)
                    print(json)
                    print(response.request!)
                    print(parameters!)
                    let status = json["Status"].intValue
                    if status == 1
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let Message = json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    }
                    else {
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
    }
    
    func DisApproveAPI()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let Req_No = self.json["ReqID"].stringValue
        let type =  self.dodo["Type"].stringValue
       
        
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqID":Req_No,"UserID":UserID,"Type":type,"Remarks":self.txt_Remark.text!]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqNo":Req_No]
        }
        AF.request( base.url+"SL_DisapproveRequest", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable (of:JSON.self) { response in
                switch response.result
                {
                case .success(let rana):
                    let json:JSON = JSON(rana)
                    print(json)
                    print(response.request!)
                    print(parameters!)
                    let status = json["Status"].intValue
                    if status == 1
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let Message = json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    }
                    else {
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
    }
    func CancelApi()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let Req_No = self.json["ReqID"].stringValue
        let type =  self.dodo["Type"].stringValue
       
        
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqID":Req_No,"UserID":UserID,"Type":type,"Remarks":self.txt_Remark.text!]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqNo":Req_No]
        }
        AF.request( base.url+"SL_CancelledRequest", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable (of:JSON.self) { response in
                switch response.result
                {
                case .success(let rana):
                    let json:JSON = JSON(rana)
                    print(json)
                    print(response.request!)
                    print(parameters!)
                    let status = json["Status"].intValue
                    if status == 1
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let Message = json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    }
                    else {
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
    }

}


extension SL_Details
{
    func languagechange()
    {
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {   self.title = "Details"
                name.text = "Name"
                empcode.text = "Emp Code"
                department.text = "Department"
                desigination.text = "Designation"
                location.text =  "Location"
                requestDetails.text = "Request Details"
                requestnumber.text = "Request No"
                submitdate.text = "Submit Date"
                leavetype.text = "Leave Type"
                contact.text = "Contact"
                fromdate.text = "From Date"
                todate.text = "To Date"
           
                submitBy.text = "Submitted By"
                puspose.text = "Purpose"
                reporintmanager.text = "Reporting Manager"
                remarks.text = "Remarks"
                txt_Remark.placeholder = "Enter Remarks"
                btn_Cancel.setTitle("Cancel", for: .normal)
                btn_Approve.setTitle("Approve", for: .normal)
                btn_DisApprove.setTitle("REJECT", for: .normal)
          
            }
            else
            {
                   self.title = "विवरण"
                   name.text = "नाम"
                   empcode.text = "कर्मचारी कोड"
                   department.text = "विभाग"
                   desigination.text = "पद"
                   location.text =  "स्थान"
                   requestDetails.text = "अनुरोध विवरण "
                   requestnumber.text = "अनुरोध संख्या"
                   submitdate.text = "जमा करने की तारीख"
                   leavetype.text = "छुट्टी का प्रकार"
                   contact.text = "संपर्क नंबर"
                   fromdate.text = "आरंभ करने की तिदिनांकथि"
                   todate.text = "अंतिम दिनांक"
                 
                   submitBy.text = "द्वारा प्रस्तुत"
                   puspose.text = "उद्देश्य"
                   reporintmanager.text = "रिपोर्टिंग प्रबंधक"
                   remarks.text = "टिप्पणियां"
                   txt_Remark.placeholder = "टिप्पणी दर्ज करें"
                btn_Cancel.setTitle("रद्द करें", for: .normal)
                btn_Approve.setTitle("मंज़ूर करें", for: .normal)
                btn_DisApprove.setTitle("अस्वीकार करें", for: .normal)
              
            }
        }
    }
}
