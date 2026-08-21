//
//  RequestDetailsVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 05/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class RequestDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var gradePicker: UIPickerView!
    let arrYear = ["Applied Leave","Casual Leave"]
    var strRequestId = "1" // reqyest Date and 2 for AppyDate
    
    var previousMonthStr = ""
    var nextMonthStr = ""
    
    var json:JSON = []
    @IBOutlet weak var lblNoRequestToDisplay: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Leave Request"
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
      
        self.lblNoRequestToDisplay.isHidden = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        
        
        let nextMonth = Calendar.current.date(byAdding: .month, value: 2, to: Date())
        let PreviousMonth = Calendar.current.date(byAdding: .month, value: -2, to: Date())
        
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
        // Do any additional setup after loading the view.
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.LeaveHistoryListAPI()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json["objleaveGetDetailsRes"].arrayValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requesttblcell")as! requesttblcell
        let index = indexPath.row
        cell.lblDate.text = json["objleaveGetDetailsRes"][index]["ReqNo"].stringValue
        cell.lbl_status.text = json["objleaveGetDetailsRes"][index]["LeaveFinalStatus"].stringValue
        cell.lblDateDiffrence.text = json["objleaveGetDetailsRes"][index]["Period"].stringValue
        cell.lbl_LeaveType.text = json["objleaveGetDetailsRes"][index]["Leave_Name"].stringValue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Leave", bundle: nil)
       let vc = storyboard.instantiateViewController(withIdentifier: "DetailsVC")as! DetailsVC
       let index =  indexPath.row
        vc.dodo = json["objleaveGetDetailsRes"][index]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func LeaveHistoryListAPI()  {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"FromDate":previousMonthStr,"ToDate":nextMonthStr,"ReqTypeID":strRequestId,"ReqNo":""]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","PlantID":"0","Year":""]
        }
        
        AF.request( base.url+"LeaveHistoryList", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                switch response.result
                {
                
                case .success(let value):
                    self.json = JSON(value)
                    print(self.json)
                    print(response.request!)
                    print(parameters!)
                    
                    let status = self.json["Status"].intValue
                    if status == 1 {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        DispatchQueue.main.async {
                            self.lblNoRequestToDisplay.isHidden = true
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                        }
                    }else {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
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
class requesttblcell:UITableViewCell
{
    @IBOutlet weak var lbl_status: UILabel!
    
    @IBOutlet weak var viewColor: UIView!
    
    
    @IBOutlet weak var lbl_LeaveType: UILabel!
    @IBOutlet weak var lblDateDiffrence: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var tLeaveType:UILabel!
    @IBOutlet weak var trequestCode:UILabel!
    @IBOutlet weak var tLeavePeriod:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                self.tLeaveType.text = "Leave Type"
                self.trequestCode.text = "Request No"
                self.tLeavePeriod.text = "Leave Period"
                
            }
            else
            {
                self.tLeaveType.text = "छुट्टी का प्रकार"
                self.trequestCode.text = "अनुरोध कोड"
                self.tLeavePeriod.text = "छुट्टी अवधि"
            }
        }
    }
    
}
extension UIView {
    
    func circleView(borderColor:UIColor,borderWidth:Float)  {
        
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
        
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = CGFloat(borderWidth)
        
    }
    
}
