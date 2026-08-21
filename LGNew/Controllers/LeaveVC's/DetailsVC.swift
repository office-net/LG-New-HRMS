//
//  DetailsVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 05/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailsVC: UIViewController {
    var dodo:JSON = []
    var json:JSON = []
    var RM_HOD_Flag = ""
    var strComand = ""
    var IsFirstApprovalDetailsVisable = 0
    var IsApprovalbuttonVisable = 0
    var approvebtn = 0
    var disapprovebtn = 0
    @IBOutlet weak var lbl_CancelDetailsVisable: UILabel!
    @IBOutlet weak var Hieght_vvCancel: NSLayoutConstraint!
    @IBOutlet weak var lbl_CancelBy: UILabel!
    @IBOutlet weak var medicalCertificateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rmDate: UILabel!
    
    @IBOutlet weak var medicalCertificateView: UIView!
    @IBOutlet weak var lbl_CancelRemarks: UILabel!
    @IBOutlet weak var vv_Cancel: UIView!
    @IBOutlet weak var txt_remarks: UITextField!
    @IBOutlet weak var Requestdetailview: UIView!
    
    @IBOutlet weak var lbl_CancelDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lbl_department: UILabel!
    @IBOutlet weak var lbl_Empcode: UILabel!
    @IBOutlet weak var lblDesigination: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRequestNO: UILabel!
    @IBOutlet weak var lblSubbmitDate: UILabel!
    @IBOutlet weak var lblMOBO: UILabel!
    @IBOutlet weak var lbl_LeaveType: UILabel!
    @IBOutlet weak var lbl_FromDate: UILabel!
    @IBOutlet weak var lbl_ToDate: UILabel!
    @IBOutlet weak var lbl_NOofDays: UILabel!
    @IBOutlet weak var lbl_SubbmitedBY: UILabel!
    @IBOutlet weak var lbl_Purpose: UILabel!
   
    @IBOutlet weak var btn_Approve: UIButton!
    @IBOutlet weak var btn_DisApprove: UIButton!
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var RMStatus: UILabel!
    @IBOutlet weak var RMRemarks: UILabel!

    
    @IBOutlet weak var hieght_ApproveStack: NSLayoutConstraint!
    @IBOutlet weak var txt_Remark_Hight: NSLayoutConstraint!
    
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
    @IBOutlet weak var numberofdays: UILabel!
    @IBOutlet weak var submitBy: UILabel!
    @IBOutlet weak var puspose: UILabel!
    @IBOutlet weak var reporintmanager: UILabel!
    @IBOutlet weak var remarks: UILabel!
    @IBOutlet weak var canceldetails: UILabel!
    @IBOutlet weak var cancelby: UILabel!
    @IBOutlet weak var cancelremarks: UILabel!
    @IBOutlet weak var lbl_Emp_DOJ: UILabel!
    
    @IBOutlet weak var lbl_RM_Name: UILabel!
    @IBOutlet weak var canceldate: UILabel!
    
    

    var btnstatus = 0
    var cancelstatus = 0
    var imagePath = ""
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
     languagechange()
        self.Requestdetailview.layer.borderWidth = 1
        self.Requestdetailview.layer.borderColor = base.firstcolor.cgColor
        txt_remarks.isHidden = true
        self.btn_Cancel.isHidden = true
        btn_Approve.isHidden = true
        btn_DisApprove.isHidden = true
        vv_Cancel.isHidden = true
        Hieght_vvCancel.constant = 0
        detailsVCAPI()
        lbl_CancelDetailsVisable.layer.cornerRadius = 10
        lbl_CancelDetailsVisable.clipsToBounds = true
        btn_Cancel.isHidden = true
        // Do any additional setup after loading the view.
        let openSafariButton = UIButton(type: .system)

        view.addSubview(openSafariButton)
        openSafariButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            openSafariButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openSafariButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @IBAction func btn_MedicalCertificate(_ sender: Any) {
        if let imageUrl = URL(string: self.imagePath ) {
            UIApplication.shared.open(imageUrl, options: [:], completionHandler: nil)
        }
    }
    func detailsVCAPI()
    {   CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqNo":self.dodo["ReqNo"].stringValue ,"Mode":self.dodo["Mode"].stringValue]
        AF.request( base.url+"LeaveViewRequestDetails", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable (of:JSON.self)  { response in
                
                switch response.result
                {
                
                case .success(let Value):
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                    self.json = JSON(Value)
                    print(response.request!)
                    print(parameters)
                    print(self.json)
                    self.RM_HOD_Flag = self.json["RM_HOD_Flag"].stringValue
                   
                    self.lbl_Emp_DOJ.text = self.json["EmpDOJ"].stringValue
                    self.rmDate.text = self.json["RMDate"].stringValue
                    
                    self.lblName.text = self.json["EmpName"].stringValue
                    self.lbl_Empcode.text = self.json["EmpCode"].stringValue
                    self.lbl_department.text = self.json["EmpDepartment"].stringValue
                    self.lblDesigination.text = self.json["EmpDesignation"].stringValue
                    self.lblAddress.text = self.json["EmpLocation"].stringValue
                    self.lblRequestNO.text = self.json["Req_No"].stringValue
                    self.lblSubbmitDate.text = self.dodo["ReqDate"].stringValue
                    self.lbl_FromDate.text = self.json["From_Date"].stringValue
                    self.lbl_ToDate.text = self.json["To_Date"].stringValue
                    self.lbl_NOofDays.text = self.json["NoOfDays"].stringValue
                    self.RMStatus.text = self.json["RMStatus"].stringValue
                    self.RMRemarks.text = self.json["RMRemarks"].stringValue
                
                    self.imagePath = self.json["FilePath"].stringValue
                    
                   
                    self.lbl_SubbmitedBY.text = self.json["Submitted_By"].stringValue
                    self.lblMOBO.text = self.json["Contact"].stringValue
                     self.approvebtn = self.json["IsApprovalButtonVisable"].intValue
                    self.lbl_LeaveType.text = self.json["Leave_Type"].stringValue
                    self.disapprovebtn = self.json["IsCancelButtonVisable"].intValue
                    
                    
                    
                self.cancelstatus = self.json["IsCancelDetailsVisable"].intValue
                   if self.cancelstatus == 1
                    {
                        self.vv_Cancel.isHidden = false
                        self.Hieght_vvCancel.constant = 128
                        self.lbl_CancelDate.text = self.json["CancelDate"].stringValue
                        self.lbl_CancelBy.text = self.json["CancelBy"].stringValue
                        self.lbl_CancelRemarks.text = self.json["CancelRemarks"].stringValue
                        if self.lbl_CancelRemarks.text == ""
                        {
                            self.lbl_CancelRemarks.text = "Not Available"
                        }
                    }
                    
                    let color1 = self.json["RMStatus"].stringValue
                    if color1.contains("Rejected") || color1.contains("NA") ||
                      color1.contains("Disapproved") || color1.contains("Pending")
                    {
                        self.RMStatus.textColor = UIColor.red
                        self.rmDate.textColor = UIColor.red
                    }
                    else{
                        self.RMStatus.textColor = UIColor.green
                        self.rmDate.textColor = UIColor.green
                    }
                    
                    
                 
                    
                    self.lbl_Purpose.text = self.json["Reason"].stringValue
                    //----------------------CANCEL BTN ----------------------
                    if self.btnstatus == 1
                    {
                        self.btn_Cancel.isHidden = false
                        self.txt_Remark_Hight.constant = 45
                        self.txt_remarks.isHidden = false
                    }
                  
                    //-------------------APPROVE BTN-----------------------------------
                    let app =  self.json["IsApprovalSectionVisible"].intValue
                    
                    if app == 1
                    {
                        self.btn_Approve.isHidden = false
                        self.btn_DisApprove.isHidden = false
                        self.txt_remarks.isHidden = false
                        self.hieght_ApproveStack.constant = 45
                    }
                    else
                    {
                        self.btn_Approve.isHidden = true
                        self.btn_DisApprove.isHidden = true
                    }

                    if self.json["FilePath"].stringValue == ""{
                        self.medicalCertificateViewHeight.constant = 0
                        self.medicalCertificateView.isHidden = true
                    }
                    else
                    {
                        self.medicalCertificateViewHeight.constant = 40
                        self.medicalCertificateView.isHidden = false
                    }
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
                
            }
    }
    
    
    
    
    
    
    @IBAction func btn_Approve(_ sender: Any) {
        if txt_remarks.text == "" {
            
            
            let alertController = UIAlertController(title: base.Title, message: "Remark field should not be blank.", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
            }
            // Add the actions
            alertController.addAction(okAction)
            // Present the controller
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        else {
            
            // Create the alert controller
            let alertController = UIAlertController(title: base.Title, message: "Are you sure?", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.strComand = "APPROVE"
                self.LeaveApproveDisApproveAPI()
                
            }
            let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                UIAlertAction in
            }
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            // Present the controller
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        
    }
    
    @IBAction func btn_Disapprove(_ sender: Any) {
        
        if txt_remarks.text == "" {
            
            
            let alertController = UIAlertController(title: base.Title, message: "Remark field should not be blank.", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
            }
            // Add the actions
            alertController.addAction(okAction)
            // Present the controller
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        else {
            
            // Create the alert controller
            let alertController = UIAlertController(title: base.Title, message: "Are you sure?", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.strComand = "Disapprove"
                self.LeaveApproveDisApproveAPI()
                
            }
            let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                UIAlertAction in
            }
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            // Present the controller
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        
    }
    
    
    @IBAction func btn_Cancel(_ sender: Any) {
        if txt_remarks.text == ""
        {   self.showAlert(message: "Please Enter Remarks")}
        else
        {
            CancelLeaveAPI()
        }
            
     
    }
    
    
    func CancelLeaveAPI()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        //let Req_No = dodo["LeaveId"].stringValue
        let LeaveID = dodo["LeaveId"].stringValue
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","LeaveId":LeaveID,"UserID":UserID,"Remarks":txt_remarks.text ?? "","Type":""]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","LeaveID":LeaveID]
        }
        
        AF.request( base.url+"CancelLeave", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable (of:JSON.self)  { response in
                print(response.request!)
                print(parameters!)
                switch response.result
                {
                
                case .success(let anikit):
                    let json:JSON = JSON(anikit)
                    print(json)
                   
                    let status = json["Status"].intValue
                    if status == 1
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let Message = json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
//                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                            self.navigationController?.popViewController(animated: true)
                            
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    }else {
                        
                    }
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        
        
        
    }
    
    func LeaveApproveDisApproveAPI()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let Req_No = self.json["Req_No"].stringValue
        let EmpID = self.json["EmpID"].stringValue
        
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqNo":Req_No,"UserID":UserID,"Remarks":txt_remarks.text ?? "","EmpID":EmpID,"RM_HOD_Flag":self.RM_HOD_Flag ,"Command":strComand]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqNo":Req_No]
        }
        AF.request( base.url+"LeaveApproveDisApprove", method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
//                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                            self.navigationController?.popViewController(animated: true)
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

extension DetailsVC
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
                numberofdays.text = "No. of Days"
                submitBy.text = "Submitted By"
                puspose.text = "Reason"
                reporintmanager.text = "RM Status"
                remarks.text = "Remarks"
                txt_remarks.placeholder = "Enter Remarks"
                btn_Cancel.setTitle("Cancel", for: .normal)
                btn_Approve.setTitle("Approve", for: .normal)
                btn_DisApprove.setTitle("Disapprove", for: .normal)
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
                   numberofdays.text = "दिनों की संख्या"
                   submitBy.text = "द्वारा प्रस्तुत"
                   puspose.text = "उद्देश्य"
                   reporintmanager.text = "रिपोर्टिंग प्रबंधक"
                   remarks.text = "टिप्पणियां"
                   txt_remarks.placeholder = "टिप्पणी दर्ज करें"
                btn_Cancel.setTitle("रद्द करें", for: .normal)
                btn_Approve.setTitle("मंज़ूर करें", for: .normal)
                btn_DisApprove.setTitle("अस्वीकार करें", for: .normal)
            }
        }
    }
}
