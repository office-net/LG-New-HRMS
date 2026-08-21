//
//  SalaryVC.swift
//  NewOffNet
//
//  Created by Ankit Rana on 17/12/21.

import UIKit
import WebKit
import Alamofire
import SwiftyJSON

class SalaryVC: UIViewController, UITextFieldDelegate , UIPickerViewDelegate, UIPickerViewDataSource {
  
    
     
    @IBOutlet weak var btn_Download: UIButton!
    
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var btn_find: UIButton!
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var  txtYear: UITextField!
    var gradePicker: UIPickerView!
    var months  = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    var year = [String]()
   var PdfPath = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Salary Slip"
        gradePicker = UIPickerView()
        gradePicker.dataSource = self
        gradePicker.delegate = self
        txtYear.delegate = self
        txtYear.inputView = gradePicker
        txtMonth.delegate = self
        txtMonth.inputView = gradePicker
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        let tyear = components.year
        let a = tyear! + 1
        let b = tyear!

        let c = tyear! - 1
        self.year = ["\(c)","\(b)","\(a)"]

        print(self.year)
        self.txtYear.text = year[0]
        self.txtMonth.text = months[0]

        // Do any additional setup after loading the view.
 
        
        
    }
    
    @IBAction func btn_DownloadSalary(_ sender: Any) {
        if PdfPath == ""
        {
            self.showAlert(message: "Please find Salary Slip first.")
        }
        else
        {
            print(PdfPath)
        savePdf(urlString: PdfPath)
        }
        
        
    }
    
    
    func SalaryApi()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
         let empcode  = UserDefaults.standard.object(forKey: "EmpCode") as? String
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","EmpCode": empcode ?? "" ,"Month":txtMonth.text ?? "","Year":txtYear.text ?? "","UserID":UserID]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","PlantID":"0","Year":""]
        }
        
        
        AF.request( base.url+"GetSalarySlip", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self) { response in
                print(response.request!)
                print(parameters!)
                switch response.result
                {
                case .success(let value):
                    let json:JSON = JSON(value)
                    print(json)
                    let status =  json["Status"].intValue
                    if status == 1
                    {   self.PdfPath = json["PDFPath"].stringValue
                        let url = URL (string: json["PDFPath"].stringValue)
                        let requestObj = URLRequest(url: url!)
                        self.webview.load(requestObj)
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                    }
                    else
                    {   self.txtYear.text = ""
                        self.txtMonth.text = ""
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.showAlert(message: json["Message"].stringValue)
                        
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }}
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if txtMonth.isFirstResponder ==  true
        {
            return months.count
        }
        else
        {
            return year.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if txtMonth.isFirstResponder
        {
            return  months[row]
        }
        return year[row]
       
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if txtMonth.isFirstResponder
        {
            txtMonth.text = months[row]
        }
        else
        {
            txtYear.text = year[row]
        }
 
    }

    @IBAction func btn_find(_ sender: Any) {
        if txtYear.text == ""
        {
            self.showAlert(message: "Please select Year")
        }
        else if txtMonth.text == ""
        {
            showAlert(message: "Please Select Month")
        }
        else{
         SalaryApi()
        }
    }
    
    func savePdf(urlString: String) {
        // Convert the urlString to URL
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            // Get the documents directory
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            // Set the filename for the pdf file downloaded
            let filename = " SalarySlip-\(txtMonth.text ?? "").pdf"
            
            // Set the path for the pdf file
            let fileURL = documentsDirectory.appendingPathComponent(filename)
            
            // Save the pdf file in our documents directory
            try data.write(to: fileURL, options: .atomic)
            
            print("PDF Saved Successfully")
            self.showAlert(message: "PDF Saved Successfully")
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
