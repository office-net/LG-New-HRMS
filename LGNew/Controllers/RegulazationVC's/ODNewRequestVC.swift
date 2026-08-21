//  ODNewRequestVC.swift
//  Myomax officenet
//  Created by Mohit Sharma on 05/05/20.
//  Copyright © 2020 Mohit Sharma. All rights reserved.


import UIKit
import SwiftyJSON

class ODNewRequestVC: UIViewController {
    
    @IBOutlet weak var txt_Place: UITextField!
    @IBOutlet weak var placeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var placeView: UIView!
    @IBOutlet weak var txtRM: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtReason: UITextField!
    @IBOutlet weak var txtToTime: UITextField!
    @IBOutlet weak var txtFromTime: UITextField!
    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var txtToDate: UITextField!
    @IBOutlet weak var txtSelectType: UITextField!
    
    @IBOutlet weak var txtPlace: UITextField!
    
    
    
    var gradePicker: UIPickerView!
    var  arrObjARRegularizationType:JSON = []
    var strTypeId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UiSetup()
        placeView.isHidden = true
        placeViewHeight.constant = 0
    }
    
    @IBAction func submitBtnAction(_ sender: Any)
    {
        btn_Submit()
    }
    
    
    
}




extension ODNewRequestVC
{
    func OD_GetBasicDetailsAPI()  {
        
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters:[String:Any] = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID ?? 0]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"OD_GetBasicDetails", parameters: parameters) { (response,data) in
            let status = response["Status"].intValue
            print(response)
            if status == 1 
            {
                
                self.arrObjARRegularizationType = response["objARRegularizationType"]
                self.txtRM.text = response["RMName"].stringValue
                self.txtMobileNumber.text = response["MobileNo"].stringValue
                
            }
            else {
                let msg = response["Message"].stringValue
                self.showAlertWithAction(message: msg)
            } } }
    
    
    // Service Call
    func OD_SubmitRequestAPI()  {
        let arrFromTime = self.txtFromTime.text?.components(separatedBy: ":")
        var strFromTimeHours = ""
        var strFromTimeMins = ""
        if txtFromTime.isHidden == false
        {
            strFromTimeHours = arrFromTime![0]
            strFromTimeMins = arrFromTime![1]
        }
        
        let arrToTime = self.txtToTime.text?.components(separatedBy: ":")
        var strToTimeHours = ""
        var strToTimeMins = ""
        if txtToTime.isHidden == false
        {
            strToTimeHours = arrToTime![0]
            strToTimeMins = arrToTime![1]
        }
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters:[String:Any] = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID!,"FromDate":txtFromDate.text ?? "","FromTimeHour":strFromTimeHours,"FromTimeMin":strFromTimeMins,"ToDate":self.txtToDate.text ?? "","ToTimeHour":strToTimeHours,"ToTimeMin":strToTimeMins,"Reason":self.txtReason.text ?? "","RegularizationTypeID":strTypeId,"ContactNo":self.txtMobileNumber.text ?? "","Place":self.txtPlace.text ?? ""]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"OD_SubmitRequest", parameters: parameters) { (response,data) in
            print(response)
            let status = response["Status"].intValue
            let msg = response["Message"].stringValue
          if status == 1  {
              self.showAlertWithAction(message: msg)
            }
            else
            {
                self.showAlert(message: msg)
            }
           
           
        } }
    
}









extension ODNewRequestVC:UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return arrObjARRegularizationType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if arrObjARRegularizationType.count > 0{
            let dic  = arrObjARRegularizationType[row]
            return dic["Text"].stringValue
        }
        return ""
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        
        let dic  = arrObjARRegularizationType[row]
        txtSelectType.text = dic["Text"].stringValue
        
        if txtSelectType.text != "On Tour"{
            txtToDate.isHidden = true
        }
        else
        {
            txtToDate.isHidden = false
        }
        strTypeId = dic["ID"].stringValue
    }
}



extension ODNewRequestVC:UITextFieldDelegate
{
    func UiSetup()
    {
        
   
        self.title = "New Request"
        if let myImage = UIImage(named: "calendar")
        {
            
            txtFromDate.withImage(direction: .Left, image: myImage, colorBorder: UIColor.clear)
            txtToDate.withImage(direction: .Left, image: myImage,  colorBorder: UIColor.clear)
        }
        if let img2 = UIImage(named: "wallclock")
        {
            txtToTime.withImage(direction: .Left, image: img2,  colorBorder: UIColor.clear )
            txtFromTime.withImage(direction: .Left, image: img2,  colorBorder: UIColor.clear )
        }
        gradePicker = UIPickerView()
        gradePicker.dataSource = self
        gradePicker.delegate = self
        txtSelectType.delegate = self
        txtSelectType.inputView = gradePicker
        
        self.txtFromDate.delegate = self
        self.txtToDate.delegate = self
        
        self.txtFromTime.delegate = self
        self.txtToTime.delegate = self
        
        self.txtFromDate.setInputViewDatePicker(target: self, selector: #selector(tapDoneFromDate))
        self.txtToDate.setInputViewDatePicker(target: self, selector: #selector(tapDoneToDate))
        
        self.txtFromTime.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneFromTime))
        self.txtToTime.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneToTime))
        
        self.OD_GetBasicDetailsAPI()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtSelectType{
            // gradePicker.selectRow(0, inComponent: 0, animated: false)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        if textField == txtSelectType{
            if txtSelectType.text == "" {
                
                if arrObjARRegularizationType.count > 0{
                    let dic  = arrObjARRegularizationType[0]
                    txtSelectType.text =  dic["Text"].stringValue
                    strTypeId = dic["ID"].stringValue
                } } }
        
        if txtSelectType.text == "Missed In-Out Punch Regularisation"{
            self.txtToDate.isHidden = true
            self.txtFromDate.isHidden = false
            self.txtToTime.isHidden = false
            self.txtFromTime.isHidden = false
            self.placeView.isHidden = true
            self.placeViewHeight.constant = 0
            
        }
        else if txtSelectType.text == "Card Not punch"
        {
            self.txtToDate.isHidden = true
            self.txtToTime.isHidden = false
            self.txtFromDate.isHidden = false
            self.txtFromTime.isHidden = false
            self.placeView.isHidden = true
            self.placeViewHeight.constant = 0
        }
        else if txtSelectType.text == "Work From Home"
        {
            self.txtToDate.isHidden = false
            self.txtToTime.isHidden = false
            self.txtFromDate.isHidden = false
            self.txtFromTime.isHidden = false
            self.placeView.isHidden = true
            self.placeViewHeight.constant = 0
        }
        else if txtSelectType.text == "OD Duty"
        {
            self.txtToDate.isHidden = false
            self.txtToTime.isHidden = false
            self.placeView.isHidden = false
            self.placeViewHeight.constant = 63
            self.txtFromTime.isHidden = false
            self.txtFromDate.isHidden = false
            
        }
        
        
        
    }
    
    @objc func tapDoneFromDate() {
        if let datePicker = self.txtFromDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.txtFromDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txtFromDate.resignFirstResponder() // 2-5
    }
    
    @objc func tapDoneToDate() {
        if let datePicker = self.txtToDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.txtToDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txtToDate.resignFirstResponder() // 2-5
    }
    
    @objc func tapDoneFromTime() {
        if let datePicker = self.txtFromTime.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            dateformatter.dateFormat = "HH:mm"
            
            self.txtFromTime.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txtFromTime.resignFirstResponder() // 2-5
    }
    
    @objc func tapDoneToTime() {
        if let datePicker = self.txtToTime.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateStyle = .medium
            dateformatter.dateFormat = "HH:mm"
            self.txtToTime.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txtToTime.resignFirstResponder() // 2-5
    }
    
    
    
    func btn_Submit()
    {
        
        if (self.txtSelectType.text == "" ) {
            self.showAlert(message: "Please select type")
            
        }
        
        else   if (self.txtFromDate.text == "" ) {
            self.showAlert(message: "Please select from date")
            
        }
        else   if txtToDate.isHidden == false && self.txtToDate.text == ""  {
            self.showAlert(message: "Please select to date")
            
        }
        else   if txtFromTime.isHidden == false && self.txtFromTime.text == ""  {
            self.showAlert(message: "Please select from time")
            
        }
        
        else   if txtToTime.isHidden == false && self.txtToTime.text == ""  {
            self.showAlert(message: "Please select to time")
            
            
            
        }
       
        else   if (self.txtReason.text == "" ) {
            self.showAlert(message: "Please enter Reason")
            
        }
        
        else   if (self.txtMobileNumber.text == "" ) {
            self.showAlert(message: "Please enter contact number")
            
        }
        else if Validation.validaPhoneNumber(phoneNumber: self.txtMobileNumber.text ?? "" ) == false
        {
            self.showAlert(message: "Please enter Correct Mobile Number")
        }
        
        else   if (self.txtRM.text == "" ) {
            self.showAlert(message: "Please enter RM Name")
            
        }
        else if self.placeView.isHidden == false {
            if txtPlace.text == "" {
                showAlert(message: "Please fill Place")
            }
        }
        else{
            OD_SubmitRequestAPI()
        }
      
        
    }
    
    func compareTimes(time1: String, time2: String) -> ComparisonResult? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard let date1 = formatter.date(from: time1),
              let date2 = formatter.date(from: time2) else {
            return nil
        }
        
        return date1.compare(date2)
    }
    
    func checkTime()
    {
        if let result = compareTimes(time1: "10:30:00", time2: "09:45:00") {
            if result == .orderedAscending {
                print("Time 1 is earlier than Time 2")
            } else if result == .orderedDescending {
                print("Time 1 is later than Time 2")
            } else {
                print("Time 1 is equal to Time 2")
            }
        } else {
            print("Invalid time format")
        }
    }
}
