
//  DirectorySearch.swift
//  Myomax officenet
//
//  Created by Ankitrana
//  Copyright © 2021 Ankit Rana. All rights reserved.


import UIKit

protocol DirectortFilterProtocol:AnyObject {
    func getAllInfo(depId:String,desigId:String,locId:String,name:String,empCode:String)
}

class DirectorySearch: UIViewController  , UIPickerViewDelegate , UIPickerViewDataSource{

    @IBOutlet weak var Title_Filter: UILabel!
    @IBOutlet weak var Title_btnSearch: UIButton!
    @IBOutlet weak var txtDesignation: UITextField!
    @IBOutlet weak var txtDepartment: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtEmpCode: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    var arrLocationList = [String]() as? NSMutableArray
    var arrDesignationList = [String]() as? NSMutableArray
    var arrDepartmentList = [String]() as? NSMutableArray
    
    var gradePicker = UIPickerView()
    
    var isLocation = false
    var isDepartment = false

    var  departmentId:String = "0"
    var locationId:String = "0"
    var designationId:String = "0"
    
    weak var delegate:DirectortFilterProtocol?

    override func viewDidLoad() {
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
        gradePicker.delegate = self
        gradePicker.dataSource = self
        
        txtDesignation.delegate = self
       txtDepartment.delegate = self
       txtLocation.delegate = self
       txtEmpCode.delegate = self
       txtName.delegate = self
        
        txtDesignation.inputView = gradePicker
        txtDepartment.inputView = gradePicker
        txtLocation.inputView = gradePicker
        
     
         Dir_DirectoryMasterAPI()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if isDepartment {
            return arrDepartmentList?.count ?? 0
        }
      else  if isLocation {
        return arrLocationList?.count ?? 0
        }
        else {
            return arrDesignationList?.count ?? 0
        }
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if isDepartment {
            let dic = arrDepartmentList![row] as! NSDictionary
            return dic.value(forKey: "DepName") as? String
        }
        
      else  if isLocation {
            
        let dic = arrLocationList![row] as! NSDictionary
            return dic.value(forKey: "LocName") as? String
            
        }
        else {
            let dic = arrDesignationList![row] as! NSDictionary
            return dic.value(forKey: "DesgName") as? String
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if isDepartment {
            let dic = arrDepartmentList![row] as! NSDictionary
            departmentId = dic.value(forKey: "DepID") as! String
            self.txtDepartment.text =  dic.value(forKey: "DepName") as? String
        }
      else  if isLocation {
            
        let dic = arrLocationList![row] as! NSDictionary
            locationId = dic.value(forKey: "LocID") as! String
            self.txtLocation.text =  dic.value(forKey: "LocName") as? String
        }
        else {
            let dic = arrDesignationList?[row] as! NSDictionary
            designationId = dic.value(forKey: "DesgID") as! String
            self.txtDesignation.text = dic.value(forKey: "DesgName") as? String
        }
       
    }
    
    // Service Call
    func Dir_DirectoryMasterAPI()  {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        
        let url = URL(string: base.url+"Dir_DirectoryMaster")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJlbmRlciI6Im5hbmRhbiIsImlhdCI6MTU4MDIwNTI5OH0.ATXxNeOUdiCmqQlCFf0ZxHoNA7g9NrCwqRDET6mVP7k", forHTTPHeaderField:"x-access-token" )
        
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            
            do {
                
                DispatchQueue.main.async {
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                }
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    
                    self.arrLocationList = (json["LocationList"] as? NSMutableArray)!
                    self.arrDesignationList = (json["DesignationList"] as? NSMutableArray)!
                    self.arrDepartmentList = (json["DepartmentList"] as? NSMutableArray)!
                    let status = json["Status"] as? Int
                    if status == 1 {
                        
                    }else{
                        
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        delegate?.getAllInfo(depId: departmentId, desigId: designationId, locId: locationId, name: self.txtName.text ?? "", empCode:self.txtEmpCode.text ?? "")
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension DirectorySearch : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == txtDepartment {
            isDepartment = true
            isLocation = false
        }
        if textField == txtLocation {
            isDepartment = false
            isLocation = true
            
            
        }
        if textField == txtDesignation {
            isDepartment = false
            isLocation = false
        }
        
        gradePicker.reloadAllComponents()

        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        gradePicker.reloadAllComponents()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
extension DirectorySearch
{
    func Translate(index:Int)
    {
        
        
        if index == 0
        {
            self.Title_Filter.text = "Filter".localizableString(loc: "en")
            self.txtName.text = "Name".localizableString(loc: "en")
            self.txtEmpCode.text = "EmployeCode".localizableString(loc: "en")
            self.txtLocation.text = "Location".localizableString(loc: "en")
            self.txtDepartment.text = "DepartmentKey".localizableString(loc: "en")
            self.txtDesignation.text = "Desigination".localizableString(loc: "en")
            self.Title_btnSearch.setTitle("Search".localizableString(loc: "en"), for: .normal)
        }
        else
        {
            self.Title_Filter.text = "Filter".localizableString(loc: "hi")
            self.txtName.text = "Name".localizableString(loc: "hi")
            self.txtEmpCode.text = "EmployeCode".localizableString(loc: "hi")
            self.txtLocation.text = "Location".localizableString(loc: "hi")
            self.txtDepartment.text = "DepartmentKey".localizableString(loc: "hi")
            self.txtDesignation.text = "Desigination".localizableString(loc: "hi")
            self.Title_btnSearch.setTitle("Search".localizableString(loc: "hi"), for: .normal)
        }
    }
}
