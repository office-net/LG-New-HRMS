//
//  Resignation_Form.swift
//  ADLls
//
//  Created by Ankit Rana on 26/08/24.
//

import UIKit
import SwiftyJSON

class Resignation_Form: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btn_Erly: UIButton!
    @IBOutlet weak var policy_days: UILabel!
    @IBOutlet weak var resigination_Date: UITextField!
    @IBOutlet weak var notice_period_days: UITextField!
    @IBOutlet weak var remarks: UITextField!
    @IBOutlet weak var reaseon: UITextField!
    @IBOutlet weak var btn_submit: Gradientbutton!
    @IBOutlet weak var confirmed_Date: UITextField!
    @IBOutlet weak var confirm_Status: UITextField!
    @IBOutlet weak var Relieving_Date: UITextField!
    @IBOutlet weak var lbl: UILabel!
    
    var MASTER_DATA:JSON = []
    var gradepicker = UIPickerView()
    var Reason_ID = ""
    var earlybtn = false
    override func viewDidLoad() {
        super.viewDidLoad()
        uisetup()
    }
    
    
    
    @IBAction func erly(_ sender: Any) {
        if btn_Erly.isSelected == false
        {
            btn_Erly.isSelected = true
            earlybtn = true
            Relieving_Date.isUserInteractionEnabled = true
        }
        else
        {
            btn_Erly.isSelected = false
            earlybtn = false
            Relieving_Date.isUserInteractionEnabled = false
            self.notice_period_days.text = MASTER_DATA["NoticePeriodDays"].stringValue
            self.Relieving_Date.text = MASTER_DATA["RLDate"].stringValue
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        if notice_period_days.text == "0"
        {
            self.showAlert(message: "Please select last working date ")
        }
        else if reaseon.text == ""
        {
           
            self.showAlert(message: "Please select reason of Resignation")
        }
        else if remarks.text == ""
        {
            self.showAlert(message: "Please fill the remarks!")
        }
        else
        {
            SubmitAPI()
        }
        
    }
    
}






// MARK: Service call Submit

extension Resignation_Form
{  func SubmitAPI()
    {
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        var parameters = ["UserId":UserID!,"TokenNo":"abcHkl7900@8Uyhkj","FILENAME":"","FILEEXT":"","FILEBASE64":"","Reason":reaseon.text!,"Remarks":remarks.text!,"REGDate":resigination_Date.text!,"NPPolicyDays":MASTER_DATA["NoticePeriodDays"].stringValue,"IsEarlyReleaving":earlybtn,"ReleavingDate":Relieving_Date.text!,"NoticePeriodDays":notice_period_days.text!] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"SepSubmit", parameters: parameters) { (response,data) in
            print(response)
            if response["Status"].intValue == 1
            {
                self.showAlertWithAction(message: response["Message"].stringValue)
            }
            else
            {
                self.showAlert(message: response["Message"].stringValue)
            }
        }
    }
}















// MARK: UISETUP FUNCTIO N AND DATEPICKER FUNCTIONS



extension Resignation_Form
{
    func uisetup()
    {
        self.title = "Resignation Form"
        base.changeImageCalender(textField: resigination_Date)
        base.changeImageCalender(textField: Relieving_Date)
        resigination_Date.text = Date.getCurrentDate()
        Relieving_Date.text = Date.getCurrentDate()
        Relieving_Date.delegate = self
        Relieving_Date.Set_DatePicker_With_From_date(target: self, selector:#selector(tapStrtDate), FromDate: Date.getCurrentDate())
        Relieving_Date.isUserInteractionEnabled = false
        gradepicker = UIPickerView()
        gradepicker.delegate = self
        gradepicker.dataSource = self
        reaseon.delegate = self
        reaseon.inputView = gradepicker
        ServiceCall_MasterData()
    }
    @objc func tapStrtDate() {
        if let datePicker = self.Relieving_Date.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
            self.Relieving_Date.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.Relieving_Date.resignFirstResponder()
        self.notice_period_days.text = Calculate_Days(fromDate: resigination_Date.text!, toDate: Relieving_Date.text!)
    }
}





//MARK: UIPICKERVIEW AND SETUP OF DROPDOWM


extension Resignation_Form:UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MASTER_DATA["SepList"].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return MASTER_DATA["SepList"][row]["Value"].stringValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reaseon.text = MASTER_DATA["SepList"][row]["Value"].stringValue
        Reason_ID = MASTER_DATA["SepList"][row]["ID"].stringValue
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == reaseon
        {
            if reaseon.text == ""
            {
                reaseon.text = MASTER_DATA["SepList"][0]["Value"].stringValue
                Reason_ID = MASTER_DATA["SepList"][0]["ID"].stringValue
            }
        }
    }
    
    
}






//MARK: UIPICKERVIEW AND SETUP OF DROPDOWM


extension Resignation_Form
{
    func ServiceCall_MasterData()
    {
         let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        var parameters = ["UserId":UserID!,"TokenNo":"abcHkl7900@8Uyhkj"] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"SeparationSpinner", parameters: parameters) { (response,data) in
            print(response)
            if response["Status"].intValue == 1
            {
                self.MASTER_DATA = response
                self.notice_period_days.text = response["NoticePeriodDays"].stringValue
                self.confirmed_Date.text = response["ConfirmDate"].stringValue
                self.confirm_Status.text = response["ConfirmStatus"].stringValue
                self.resigination_Date.text = response["REGDate"].stringValue
                self.Relieving_Date.text = response["RLDate"].stringValue
                self.btn_submit.isHidden = response["ResignationApplied"].stringValue  != ""
                self.lbl.isHidden = response["ResignationApplied"].stringValue == ""
                self.lbl.text = response["ResignationApplied"].stringValue 
            }
            else
            {
                self.showAlert(message: response["Message"].stringValue)
            }
        }
        
    }
    
    func Calculate_Days(fromDate: String, toDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
         guard let startDate = dateFormatter.date(from: fromDate),
              let endDate = dateFormatter.date(from: toDate) else {
            return "Invalid date format" // Return error message if the input dates are invalid
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        if let dayCount = components.day {
            return "\(dayCount)"
        } else {
            return "Error calculating days"
        }
    }
}
