//
//  ODArchiveVC.swift
//  Myomax officenet
//
//  Created by Mohit Sharma on 05/05/20.
//  Copyright © 2020 Mohit Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ODArchiveVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var gradePicker: UIPickerView!
    let arrYear = ["Applied Leave","Casual Leave"]
    var strRequestId = "1"
    var regularizationData:JSON = []
    var previousMonthStr = ""
    var nextMonthStr = ""
    
    var arrObjleaveGetDetailsRes = [] as? NSMutableArray
    @IBOutlet weak var lblNoRequestToDisplay: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoRequestToDisplay.isHidden = true

        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                self.lblNoRequestToDisplay.text = "No Request To Display"
            }
            else
            {
                self.lblNoRequestToDisplay.text = "प्रदर्शित करने के लिए कोई अनुरोध नहीं है"
            }
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
       
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        let PreviousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: nextMonth!) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let strNextMonth = formatter.string(from: yourDate!)
        
        
        let myStringPrevious = formatter.string(from: PreviousMonth!) // string purpose I add here
        let yourDatePrevious = formatter.date(from: myStringPrevious)
        formatter.dateFormat = "dd-MMM-yyyy"
        let strPreviousMonth = formatter.string(from: yourDatePrevious!)

        
        previousMonthStr = strPreviousMonth
        nextMonthStr = strNextMonth
        
        print("strNextMonth",strNextMonth)
        print("strPreviousMonth",strPreviousMonth)
        
      odAPi()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return arrYear.count
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return arrYear[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
    }
    
    
    @IBAction func filterAction(_ sender: UIButton) {
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
    }
    @IBAction func FILTERACTION(_ sender: Any) {
    }
    
    // Service Call
   
    func odAPi()
    
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"FromDate":previousMonthStr,"ToDate":nextMonthStr,"DateType":strRequestId,"ReqNo":"","Type":"Archived"]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","PlantID":"0","Year":""]
        }
        AF.request( base.url+"OD_ArchiveRequest", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response.request!)
                print(parameters!)
                switch response.result
                {
                    
                case .success(let Value):
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                    let json:JSON = JSON(Value)
                    self.regularizationData = json["objARGetDataRes"]
                    print(json)
                   
                    let status = json["Status"].intValue
                    if status == 1 {
                       
                        DispatchQueue.main.async {
                            self.lblNoRequestToDisplay.isHidden = true
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                        }
                    }else {
                        
                        DispatchQueue.main.async {
                            self.lblNoRequestToDisplay.isHidden = false
                            self.tableView.isHidden = true
                        }
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    
}


extension ODArchiveVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.regularizationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ODArchivCell") as! ODArchivCell
        

        
        cell.lblDate.text = regularizationData[indexPath.row]["ReqNo"].stringValue
        
        cell.lblDateDiffrence.text = regularizationData[indexPath.row]["Period"].stringValue
        
        cell.lblStatus.text = regularizationData[indexPath.row]["RegularisationType"].stringValue
      
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "AR", bundle: nil)
       let vc = storyboard.instantiateViewController(withIdentifier: "RegulazationDetailsVC") as! RegulazationDetailsVC
        vc.dicObjleaveGetDetailsRes = regularizationData[indexPath.row]
       vc.isFromCancelVC = false
       vc.isFromPendingVC = false
       self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

//MARK:-MenuTableViewCell
class ODArchivCell: UITableViewCell {
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblDateDiffrence: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
}
