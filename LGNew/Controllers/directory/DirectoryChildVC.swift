//
//  DirectoryChildVC.swift
//  NewOffNet
//
//  Created by Ankit Rana on 04/12/21.
//

import UIKit
import SDWebImage
import SemiModalViewController


class DirectoryChildVC: UIViewController {
    
    @IBOutlet weak var Title_btnClose: UIButton!
    @IBOutlet weak var Title_EmergencyContactNumber: UILabel!
    @IBOutlet weak var Title_EmergencyContactPerson: UILabel!
    @IBOutlet weak var Title_Bloodgroup: UILabel!
    @IBOutlet weak var Title_Location: UILabel!
    @IBOutlet weak var Title_Department: UILabel!
    @IBOutlet weak var Title_HOD: UILabel!
    @IBOutlet weak var Title_RM: UILabel!
    @IBOutlet weak var lblRMname: UILabel!
    var rmname = ""
    @IBOutlet weak var lblHODname: UILabel!
    var hodname = ""
    @IBOutlet weak var lblDepartmentName: UILabel!
    var departmentname = ""
    @IBOutlet weak var lblLocation: UILabel!
    var location = ""
    @IBOutlet weak var lblBloodGroup: UILabel!
    var bloodgroup = ""
    
    @IBOutlet weak var btn_phonr: UIButton!
    var number = ""
    @IBOutlet weak var btn_mail: UIButton!
    var mailid = ""
    @IBOutlet weak var btn_close: UIButton!
   
    @IBOutlet weak var lbl_EmergencyNO: UILabel!
    var emergencyname = ""
    @IBOutlet weak var lbl_EmergencyPersonName: UILabel!
    var emergencyNO = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                self.Translate(index: 0)
            }
            else
            {
                self.Translate(index: 1)
            }
        }
        self.lbl_EmergencyPersonName.text = emergencyname
        self.lbl_EmergencyNO.text = emergencyNO
        self.lblRMname.text = rmname
        self.lblHODname.text = hodname
        self.lblDepartmentName.text = departmentname
        self.lblLocation.text = location
        self.lblBloodGroup.text = bloodgroup
        self.btn_close.layer.cornerRadius = 5
        self.btn_close.layer.borderWidth = 1
        self.btn_close.layer.borderColor = UIColor.red.cgColor
   
    }
    
    @IBAction func btnPhone(_ sender: Any) {
        if let url = URL(string: "tel://\(number)") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func btnMail(_ sender: Any) {
        let mailtoString = "mailto:\(mailid)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mailtoUrl = URL(string: mailtoString!)!
        if UIApplication.shared.canOpenURL(mailtoUrl) {
                UIApplication.shared.open(mailtoUrl, options: [:])
        }
    }
    
    @IBAction func btnClose(_ sender: Any) {
        dismissSemiModalView()
    }
    
}
extension DirectoryChildVC
{
    func Translate(index:Int)
    {
        
        
        if index == 0
        {
            
            self.Title_RM.text = "ReportingManager".localizableString(loc: "en")
            self.Title_HOD.text = "HOD".localizableString(loc: "en")
            self.Title_Department.text = "DepartmentKey".localizableString(loc: "en")
            self.Title_Location.text = "Location".localizableString(loc: "en")
            self.Title_Bloodgroup.text = "BloodGroup".localizableString(loc: "en")
            self.Title_EmergencyContactPerson.text = "EmergencyContactPerson".localizableString(loc: "en")
            self.Title_EmergencyContactNumber.text = "EmergencyContactNumber".localizableString(loc: "en")
            self.Title_btnClose.setTitle("Close".localizableString(loc: "en"), for: .normal)
        }
        else
        {
        
            self.Title_RM.text = "ReportingManager".localizableString(loc: "hi")
            self.Title_HOD.text = "HOD".localizableString(loc: "hi")
            self.Title_Department.text = "DepartmentKey".localizableString(loc: "hi")
            self.Title_Location.text = "Location".localizableString(loc: "hi")
            self.Title_Bloodgroup.text = "BloodGroup".localizableString(loc: "hi")
            self.Title_EmergencyContactPerson.text = "EmergencyContactPerson".localizableString(loc: "hi")
            self.Title_EmergencyContactNumber.text = "EmergencyContactNumber".localizableString(loc: "hi")
            self.Title_btnClose.setTitle("Close".localizableString(loc: "hi"), for: .normal)
        }
    }
}
