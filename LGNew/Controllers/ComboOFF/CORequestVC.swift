
//  CORequestVC.swift
//  NewOffNet
//  Created by Ankit Rana on 28/10/21.


import UIKit
import Alamofire
import SwiftyJSON

class CORequestVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoRequestToDisplay: UILabel!
    
    
    var previousMonthStr = ""
    var nextMonthStr = ""
    var strRequestId = "1"
    var json:JSON = []
    
    
    
    override func viewDidLoad()
{
        super.viewDidLoad()
    self.title = "CompOff Request"
        self.lblNoRequestToDisplay.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        let nextMonth = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        let PreviousMonth = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: nextMonth!)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let strNextMonth = formatter.string(from: yourDate!)
        let myStringPrevious = formatter.string(from: PreviousMonth!)
        let yourDatePrevious = formatter.date(from: myStringPrevious)
        formatter.dateFormat = "dd-MMM-yyyy"
        let strPreviousMonth = formatter.string(from: yourDatePrevious!)
        previousMonthStr = strPreviousMonth
        nextMonthStr = strNextMonth
        print("strNextMonth",strNextMonth)
        print("strPreviousMonth",strPreviousMonth)
       
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.RequestApi()
    }
    

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.json["objGPGetDataRes"].arrayValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CORequestDetailsCell") as! CORequestDetailsCell
        let index = indexPath.row
        cell.lblDate.text = json["objGPGetDataRes"][index]["ReqNo"].stringValue
        cell.lblDateDiffrence.text = json["objGPGetDataRes"][index]["CompOffDate"].stringValue
        cell.lbl_Status.text = json["objGPGetDataRes"][index]["RMStatus"].stringValue
        
        
        
//          if json["objGPGetDataRes"][index]["HRStatus"].stringValue == "NA"
//          {
//              if json["objGPGetDataRes"][index]["HODStatus"].stringValue == "NA"
//              {
//                  cell.lblStatus.text = json["objGPGetDataRes"][index]["RMStatus"].stringValue
//              }
//              else
//              {
//                  cell.lblStatus.text = json["objGPGetDataRes"][index]["HODStatus"].stringValue
//              }
//          }
//
//          else if json["objGPGetDataRes"][index]["HODStatus"].stringValue == "NA"
//          {
//              cell.lbl_Status.text = json["objGPGetDataRes"][index]["RMStatus"].stringValue
//          }
//        else
//        {
//            cell.lbl_Status.text = json["objGPGetDataRes"][index]["HRStatus"].stringValue
//        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "OD", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CODetailsVC") as! CODetailsVC
        vc.isFromCancelVC = false
        vc.isFromPendingVC = false
        let index =  indexPath.row
        vc.dodo = json["objGPGetDataRes"][index]
        self.navigationController?.pushViewController(vc, animated: true)

        
    
    
    
    
    
    }
    
    
    
    func RequestApi()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"FromDate":previousMonthStr,"ToDate":nextMonthStr,"DateType":strRequestId,"ReqNo":""]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","PlantID":"0","Year":""]
        }
        AF.request( base.url+"CompOff_MyRequest", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseDecodable(of:JSON.self)  { response in
                       
                        switch response.result
                        {
                        
                        case .success(let Value):
                            self.json = JSON(Value)
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
                                
                                DispatchQueue.main.async {
                                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
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
class CORequestDetailsCell: UITableViewCell {
    @IBOutlet weak var viewColor: UIView!
   
    @IBOutlet weak var lbl_Status: UILabel!
    
    @IBOutlet weak var lblDateDiffrence: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var tLeavePeriod: UILabel!
    @IBOutlet weak var tRequestCode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
        
                self.tRequestCode.text = "Request No"
                self.tLeavePeriod.text = "Compensatory Reimb. Date"
            }
            else
            {
                
                self.tRequestCode.text = "अनुरोध कोड"
                self.tLeavePeriod.text = "छुट्टी अवधि"
            }
        }
    }
}
