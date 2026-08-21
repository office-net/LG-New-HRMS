//
//  SL_NewRequest.swift
//  Prince_Pipes_Newls
//
//  Created by Netcommlabs on 25/08/23.
//

import UIKit
import SwiftyJSON
import Alamofire

class SL_NewRequest:UIViewController, UITextFieldDelegate,UIPickerViewDataSource , UIPickerViewDelegate, UITextViewDelegate{
    
    @IBOutlet weak var txtDestination: UILabel!
    
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtReasonForGoingOut: UITextView!
    @IBOutlet weak var txtFromTime: UITextField!
    @IBOutlet weak var txtToTime: UITextField!
    
    @IBOutlet weak var btn_Submit: Gradientbutton!
    
    @IBOutlet weak var Title_Date: UILabel!
    
    @IBOutlet weak var Title_ContactNumber: UILabel!
    @IBOutlet weak var title_Reporting_Manager: UILabel!
    
    @IBOutlet weak var title_ReasonForGoingOut: UILabel!
    
    
    
 
    var SlfromTimelist:JSON = []
    var SlToTimelist:JSON = []
    var gradePicker = UIPickerView()
    var fromTimeId = ""
    var totimeid = ""
        override func viewDidLoad() {
        super.viewDidLoad()
           // changeLanguage()
            self.title = "New Request"
        txtReasonForGoingOut.text = "Enter Here..."
        txtReasonForGoingOut.textColor = UIColor.lightGray
        txtReasonForGoingOut.delegate = self
        if let img2 = UIImage(named: "wallclock")
        {
            txtToTime.withImage(direction: .Left, image: img2,  colorBorder: UIColor.clear )
            txtFromTime.withImage(direction: .Left, image: img2,  colorBorder: UIColor.clear )
        }
        txtFromTime.delegate = self
        txtToTime.delegate = self
        gradePicker.delegate = self
        gradePicker.dataSource = self
        self.txtFromTime.inputView = gradePicker
        self.txtToTime.inputView = gradePicker
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let result = formatter.string(from: date)
            self.txtDate.text = result
            
        SL_getBasicDetails()
        SL_GetfromTimeApi()
            self.txtDate.delegate = self
            self.txtDate.setInputViewDatePicker(target: self, selector: #selector(tapStrtDate))
            
        
    }
    @objc func tapStrtDate() {
        if let datePicker = self.txtDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.txtDate.text = dateformatter.string(from: datePicker.date)
            self.SL_GetfromTimeApi()
            //2-4
        }
        self.txtDate.resignFirstResponder() // 2-5
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if txtFromTime.isFirstResponder
        {
        return self.SlfromTimelist.arrayValue.count
        }
        else
        {
            return SlToTimelist.arrayValue.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if txtFromTime.isFirstResponder
        {
        return SlfromTimelist[row]["ShiftFromTimeText"].stringValue
        }
        else
        {
            return SlToTimelist[row]["ShiftToTimeText"].stringValue
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if txtFromTime.isFirstResponder
        {
        txtFromTime.text = SlfromTimelist[row]["ShiftFromTimeText"].stringValue
        self.fromTimeId = SlfromTimelist[row]["ShiftFromTimeID"].stringValue
            self.txtToTime.text = ""
        self.SltotimeApi()
        }
        else if txtFromTime.text == ""
        {
            showAlert(message: "Please Select From Time")
        }
        
          else
        {
            txtToTime.text = SlToTimelist[row]["ShiftToTimeText"].stringValue
             self.totimeid = SlToTimelist[row]["ShiftToTimeID"].stringValue
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtFromTime.text == ""
        {
            if textField ==  txtFromTime
            {
                txtFromTime.text = SlfromTimelist[0]["ShiftFromTimeText"].stringValue
                self.fromTimeId = SlfromTimelist[0]["ShiftFromTimeID"].stringValue
                self.SltotimeApi()
            }
        }
        if txtToTime.text == ""
        {
            
            if textField == txtToTime
            {
                txtToTime.text = SlToTimelist[0]["ShiftToTimeText"].stringValue
                self.totimeid = SlToTimelist[0]["ShiftToTimeID"].stringValue
            }
            
        }
    }
    
    
    @IBAction func submitBtnAction(_ sender: Any) {
        if txtFromTime.text == ""
        {
            self.showAlert(message: "Please Select From time")
        }
        else if txtToTime.text == ""
        {
            self.showAlert(message: "Please Select To time ")
        }
        else if txtReasonForGoingOut.text == "Enter Here..."
        {
        self.showAlert(message: "Please Enter Reason")
        }
        else
        {
        SlSubmitbtnApi()
    }
        
    }
    func SL_getBasicDetails()
    { CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID]  }
        else {parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]}
        AF.request( base.url+"SL_GetBasicDetails", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self ) { response in
                switch response.result
                {
                case .success(let Value):
                    let json:JSON = JSON(Value)
                    print(json)
                    print(response.request!)
                    print(parameters!)
                    let status = json["Status"].intValue
                    if status == 1
                    { CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.txtDestination.text = json["RMName"].stringValue
                        self.txtName.text = json["MobileNo"].stringValue
                    }
                    else
                    {CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.txtDestination.text = json["RMName"].stringValue
                        self.txtName.text = json["MobileNo"].stringValue }
                case .failure(let error):
                    print(" something went worng in api   \(error.localizedDescription)")
                }}}
    
    
    func SL_GetfromTimeApi()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"Date":self.txtDate.text!] }
        else {  parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"] }
        AF.request( base.url+"SL_GetDataOnDateChange", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self ) { response in
                switch response.result
                {
                case .success(let value):
                    let json:JSON = JSON(value)
                    
                    print(json)
                    print(response.request!)
                    print(parameters!)
                    let status = json["Status"].intValue
                    if status == 1
                    {  CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.SlfromTimelist = json["SLAttendanceTimeList"]
                        
                    }
                    else
                    {   CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let msg = json["Message"].stringValue
                        self.showAlert(message: msg)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    print("Api is not hit properly")
                }}}
    
    func SltotimeApi()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"FromTimeID":fromTimeId]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        AF.request( base.url+"SL_GetDataOnShiftFromTimeChange", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self ) { response in
                switch response.result
                {
                 case .success(let value):
                    let json:JSON = JSON(value)
                    print(json)
                    print(response.request!)
                    print(parameters!)
                    let status =  json["Status"].intValue
                    if status == 1
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.SlToTimelist = json["SLAttendanceToTimeList"] }
                    else
                    { let msg = json["Message"].stringValue
                        self.showAlert(message: msg)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("something went wrong in api ")
                } }}
    
 func SlSubmitbtnApi()
 {
    CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
    var parameters:[String:Any]?
    if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"LeaveDate":self.txtDate.text!,"FromTime":fromTimeId ,"ToTime":totimeid,"ContactNo":txtName.text!,"Purpose":self.txtReasonForGoingOut.text!,"SourceType":"3"]
    }

    AF.request( base.url+"SL_SubmitRequest", method: .post, parameters: parameters, encoding: JSONEncoding.default)
         .responseDecodable(of:JSON.self ) { response in
             print(response.request!)
             print(parameters!)
            switch response.result
            {
            case .success(let value):
                let json:JSON = JSON(value)
                print(json)
            
                let status =  json["Status"].intValue
                if status == 1
                {   let msg = json["Message"].stringValue
                    let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        self.navigationController?.popViewController(animated: true)
                    }
                    // Add the actions
                    alertController.addAction(okAction)
                    // Present the controller
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                        
                }
                }
                else{
                    
                    let mssg = json["Message"].stringValue
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                    self.showAlert(message: mssg)
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            } }}

   
    
    
}
extension SL_NewRequest  {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Here..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    
}


extension SL_NewRequest
{
    func changeLanguage()
    {
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                
                self.Title_Date.text = "Date"
                self.Title_ContactNumber.text = "Contact Number"
                self.title_Reporting_Manager.text = "Reporting Manager"
                self.title_ReasonForGoingOut.text = "Reason For Going Out"
                self.txtToTime.placeholder = "To Time"
                self.txtFromTime.placeholder = "From Time"
                self.btn_Submit.setTitle("Submit", for: .normal)
            }
            else
            {
                self.title = "कम व़क्त की छुट्टी फॉर्म"
                self.title = "नया अनुरोध"
                self.Title_Date.text = "तारीख"
                self.Title_ContactNumber.text = "छुट्टी के दौरान संपर्क नंबर"
                self.title_Reporting_Manager.text = "रिपोर्टिंग प्रबंधक"
                self.title_ReasonForGoingOut.text = "बाहर जाने का कारण"
                self.txtToTime.placeholder = "आने का समय"
                self.txtFromTime.placeholder = "जाने का समय"
                self.btn_Submit.setTitle("छुट्टी फॉर्म जमा करें", for: .normal)
                
            }
        }
        
    }
    
}
