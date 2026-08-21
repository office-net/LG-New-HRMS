//
//  Con_Leave_Pending.swift
//  LGNew
//
//  Created by Ankit Rana on 10/08/26.
//

import UIKit
import SwiftyJSON
import Alamofire
class Con_Leave_Pending: UIViewController , UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet weak var lblNoRequestToDisplay: UILabel!
    var previousMonthStr = ""
    var nextMonthStr = ""
    var strRequestId = "1"
    var arrGetDetails:JSON = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGetDetails.arrayValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leavependingcell")as! leavependingcell
        let index =  indexPath.row
     
        if arrGetDetails[index]["Rm_Status"].stringValue == ""
        {
      
        cell.lblStatus.text = "Pending"
        }
        else
        {
            cell.lblStatus.text = arrGetDetails[index]["Rm_Status"].stringValue
        }
        cell.lblRequestNO.text = arrGetDetails[index]["ReqNo"].stringValue
        cell.lblDateDiffrence.text = arrGetDetails[index]["Period"].stringValue
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Leave", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        vc.dodo = arrGetDetails[indexPath.row]
       
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Leave Pending "
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
        self.view.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
        self.tblview.delegate = self
        self.lblNoRequestToDisplay.isHidden = true
        self.tblview.dataSource = self
        // Do any additional setup after loading the view.
        let nextMonth = Calendar.current.date(byAdding: .month, value: 2, to: Date())
        let PreviousMonth = Calendar.current.date(byAdding: .month, value: -2, to: Date())
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: nextMonth!) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd/MM/yyyy"
        let strNextMonth = formatter.string(from: yourDate!)
        
        
        let myStringPrevious = formatter.string(from: PreviousMonth!) // string purpose I add here
        let yourDatePrevious = formatter.date(from: myStringPrevious)
        formatter.dateFormat = "dd/MM/yyyy"
        let strPreviousMonth = formatter.string(from: yourDatePrevious!)
        previousMonthStr = strPreviousMonth
        nextMonthStr = strNextMonth
        
        print("strNextMonth",strNextMonth)
        print("strPreviousMonth",strPreviousMonth)
  
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LeavePendingListAPI()
    }
    func LeavePendingListAPI()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"FromDate":previousMonthStr,"ToDate":nextMonthStr,"ReqTypeID":strRequestId,"ReqNo":""]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","PlantID":"0","Year":""]
        }
        
        AF.request( base.url+"ConLeavePendingList", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self) { response in
                
                switch response.result
                {
                
                case .success(let Value):
                    let json:JSON = JSON(Value)
                    print(json)
                    print(response.request!)
                    print(parameters!)
                    
                    let status = json["Status"].intValue
                    if status == 1 {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        
                        self.arrGetDetails = json["objleaveGetDetailsRes"]
                        
                        DispatchQueue.main.async {
                            self.lblNoRequestToDisplay.isHidden = true
                            self.tblview.isHidden = false
                            self.tblview.reloadData()
                        }
                    }else {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        DispatchQueue.main.async {
                            self.lblNoRequestToDisplay.isHidden = false
                            self.tblview.isHidden = true
                        }
                        
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
            }
        
    }
    
    
}

