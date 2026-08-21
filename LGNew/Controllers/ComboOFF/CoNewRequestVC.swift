//
//  CoNewRequestVC.swift
//  NewOffNet
//
//  Created by Ankit Rana on 28/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class CoNewRequestVC: UIViewController ,UITextFieldDelegate {
    @IBOutlet weak var txt_Resion: UITextView!
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var btnFullDay: UIButton!
    @IBOutlet weak var btnHalfDay: UIButton!
    var strDayStaus = ""
    var arrObjCompOffRes:JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnFullDay.isHidden = true
        self.btnHalfDay.isHidden = true
        // Do any additional setup after loading the view.
        self.txt_Resion.layer.borderWidth = 1
        self.txt_Resion.layer.borderColor = #colorLiteral(red: 0.537254902, green: 0.07058823529, blue: 0.05098039216, alpha: 1)
        self.txt_Resion.layer.cornerRadius = 10
        
        
        
        self.txtDate.delegate = self
        txt_Resion.delegate = self
        txt_Resion.text = "Enter your Purpose here..."
        txt_Resion.textColor = UIColor.lightGray
        txtDate.text = ""
        txtDate.placeholder = "Select Date Here"
        
        strDayStaus = "0"
        btnFullDay.isSelected = true
//        btnFullDay.backgroundColor = .blue
//        btnFullDay.setTitleColor(.white, for: .normal)
        
        self.txtDate.setInputViewDatePicker(target: self, selector: #selector(tapDoneFromDate))
        
    }
    
    @objc func tapDoneFromDate() {
        if let datePicker = self.txtDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd/MM/yyyy"
            // 2-2
            //dateformatter.dateStyle = .medium // 2-3
            self.txtDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txtDate.resignFirstResponder() // 2-5
    }
    @IBAction func submitBtnAction(_ sender: Any) {
        
        
        if txtDate.text == "" {
            self.showAlert(message: "Please select date")
        }
        else if strDayStaus == "" {
            self.showAlert(message: "Please select day")
        }
        else if txt_Resion.text == "Enter your Purpose here..."{
            self.showAlert(message: "Please Enter Some Reason")
        }
        else {
            CompOff_SubmitRequest ()
        }
    }
    @IBAction func fullAction(_ sender: Any) {
//        strDayStaus = "0"
//
//        btnHalfDay.backgroundColor = .clear
//        btnHalfDay.setTitleColor(.black, for: .normal)
//        btnFullDay.backgroundColor = .blue
//        btnFullDay.setTitleColor(.white, for: .normal)
        if btnFullDay.isSelected == true
        {
            btnFullDay.isSelected = true
                strDayStaus = "0"

        }
        else
        { btnFullDay.isSelected = true
            btnHalfDay.isSelected = false
        }
//
    }
    @IBAction func HalfAction(_ sender: Any) {
        if btnHalfDay.isSelected == true
        {
            strDayStaus = "1"
            btnHalfDay.isSelected = true
        }
        else
        { btnHalfDay.isSelected = true
            btnFullDay.isSelected = false
        }

//        strDayStaus = "1"
//        btnHalfDay.backgroundColor = .blue
//        btnHalfDay.setTitleColor(.white, for: .normal)
//        btnFullDay.backgroundColor = .clear
//        btnFullDay.setTitleColor(.black, for: .normal)
        
    }
    func CompOff_CheckValidation(date:String)
    {        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"Date":date]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","Date":date]
        }
        AF.request( base.url+"CompOff_CheckValidation", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self)  { response in
                switch response.result
                {
                
                case .success(let Value):
                    let json = JSON(Value)
                    print(json)
                    
                    let status = json["Status"].intValue
                    
                    if status == 1 {
                        
                        
                        
                    }
                    else {
                        
                        
                        
                        self.arrObjCompOffRes = json["objCompOffRes"]
                        print(self.arrObjCompOffRes)
                        
                        
                        
                        DispatchQueue.main.async {
                            
                        }
                        let Message = json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
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
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        
    }
    
    func CompOff_SubmitRequest ()
    {
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID , "Purpose":self.txt_Resion.text ?? "","DayStatus":self.strDayStaus,"Date":txtDate.text ?? ""]
        }
        else{
        }
        AF.request( base.url+"CompOff_SubmitRequest", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self)  { response in
                switch response.result
                {
                
                case .success(let value):
                    
                    let json:JSON = JSON(value)
                    print(json)
                    print(parameters!)
                    print(response.request!)
                    let status = json["Status"].intValue
                    if status == 1 {
                        let Message = json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: true)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }else {
                        let Message = json["Message"].stringValue
                        self.showAlert(message: Message)
                    }
                    
                case .failure(let erroe):
                    print(erroe.localizedDescription)
                }
                
                
                
                
            }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtDate {
            CompOff_CheckValidation(date: txtDate.text ?? "")
        }
    }
    
}

extension CoNewRequestVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your Purpose here..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    
}
