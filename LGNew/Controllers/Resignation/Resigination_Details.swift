//
//  Resigination_Details.swift
//  ADLls
//
//  Created by Ankit Rana on 27/08/24.
//

import UIKit
import SwiftyJSON

class Resigination_Details: UIViewController {


    
  
    @IBOutlet weak var emp_code:UITextField!
    @IBOutlet weak var DOJ:UITextField!
    @IBOutlet weak var Department:UITextField!
    @IBOutlet weak var Designation:UITextField!
    @IBOutlet weak var Location:UITextField!
    @IBOutlet weak var name: UITextField!
    
    
    @IBOutlet weak var requestDate: UITextField!
    @IBOutlet weak var ResignationDate: UITextField!
    @IBOutlet weak var notice_Period_days: UITextField!
    @IBOutlet weak var Relieving_PoloicyDate: UITextField!
    @IBOutlet weak var early_relieving_date: UITextField!
    @IBOutlet weak var early_notice_period: UITextField!
    @IBOutlet weak var reason: UITextField!
    @IBOutlet weak var plant_name: UITextField!
    @IBOutlet weak var final_Reliving_date: UITextField!
    @IBOutlet weak var final_notice_period: UITextField!
    @IBOutlet weak var btn_doc: Gradientbutton!
    @IBOutlet weak var hieght_doc: NSLayoutConstraint!
    
    @IBOutlet weak var camcel_status: UILabel!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var forwarding: UITextField!
    
    @IBOutlet weak var rm_status: UILabel!
    @IBOutlet weak var rm_date: UILabel!
    @IBOutlet weak var rm_Remarlk: UILabel!
    
    @IBOutlet weak var HOD_status: UILabel!
    @IBOutlet weak var HOD_date: UILabel!
    @IBOutlet weak var HOD_Remarlk: UILabel!
    
    
    @IBOutlet weak var HR_status: UILabel!
    @IBOutlet weak var HR_date: UILabel!
    @IBOutlet weak var HR_Remarlk: UILabel!
    
    @IBOutlet weak var view_Email: UIView!
    @IBOutlet weak var hieght_Email: NSLayoutConstraint!
    
    @IBOutlet weak var view_Approval: UIView!
    
    @IBOutlet weak var view_rm: UIView!
    @IBOutlet weak var view_HOD: UIView!
    @IBOutlet weak var view_HR: UIView!
    var ReqID = ""
    var Typeeee = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Resignation Details"
        apicall()
    }
    
func apicall()
    {
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
       let parameters = ["ReqType": Typeeee,"ReqID": self.ReqID,
                             "UserId": UserID!,
                             "TokenNo": "abcHkl7900@8Uyhkj"] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"RequestDetail", parameters: parameters) { (response,data) in
            if response["Status"].intValue == 1
            {
                self.name.text = response["EmpName"].stringValue
                self.emp_code.text = response["EmpCode"].stringValue
                self.DOJ.text = response["EmpDOJ"].stringValue
                self.Department.text = response["EmpDepartment"].stringValue
                self.Designation.text = response["EmpDesignation"].stringValue
                self.Location.text = response["EmpLocation"].stringValue
                self.Designation.text = response["EmpDesignation"].stringValue
                
                self.requestDate.text = response["ReqDate"].stringValue
                self.ResignationDate.text = response["ResignDate"].stringValue
                self.notice_Period_days.text = response["NoticePeriod_Per_Policy"].stringValue
                self.Relieving_PoloicyDate.text = response["RelivingDate_PerPolicy"].stringValue
                self.early_relieving_date.text = response["EarlyRelievingDate"].stringValue
                self.early_notice_period.text = response["EarlyNoticeperiod"].stringValue
                self.reason.text = response["Reason"].stringValue
                self.plant_name.text = response["PlantName"].stringValue
                self.final_Reliving_date.text = response["RelievingDateApprover1"].stringValue
                self.final_notice_period.text = response["NoticePeriod_by_RM"].stringValue
                
                self.email.text = response["UserEmail"].stringValue
                self.forwarding.text = response["ForwordP3"].stringValue
                
                self.rm_status.text = response["Approver1Status"].stringValue
                self.rm_date.text = response["Approver1Date"].stringValue
                self.rm_Remarlk.text = response["Approver1Remark"].stringValue
                self.view_rm.isHidden = response["Approver1Isvisible"].boolValue == false
                
                self.HOD_date.text = response["Approver2Date"].stringValue
                self.HOD_Remarlk.text = response["Approver2Remark"].stringValue
                self.HOD_status.text = response["Approver2Status"].stringValue
                self.view_HOD.isHidden = response["Approver2Isvisible"].boolValue == false
                
                
                self.HR_date.text = response["Approver3Date"].stringValue
                self.HR_Remarlk.text = response["Approver3Remark"].stringValue
                self.HR_status.text = response["Approver3Status"].stringValue
                self.view_HR.isHidden = response["Approver3Isvisible"].boolValue == false
                
                
                self.btn_doc.isHidden = response["Attachment"].stringValue == ""
                self.hieght_doc.constant = response["Attachment"].stringValue == "" ? 0:45
                
                
                self.camcel_status.isHidden = response["CancelStatus"].stringValue == ""
                self.camcel_status.text = response["CancelStatus"].stringValue
                + " on (\(response["CancelDate"].stringValue))"
            }
            else
            {
                self.showAlertWithAction(message: response["Message"].stringValue)
            }
            
            
        }
    }
   
}
