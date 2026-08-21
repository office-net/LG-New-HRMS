//
//  LeaveBalanceVC.swift
//  NewOffNet
//
//  Created by Ankit Rana on 09/12/21.


import UIKit
import SemiModalViewController
import Alamofire
import SwiftyJSON

class LeaveBalanceVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    @IBOutlet weak var view_Blanve: UIView!
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var Main_View: UIView!
    var blancetype:JSON = []
    var year = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor.clear.cgColor
        getblanveAPI()
        self.Main_View.layer.borderWidth = 2
        self.Main_View.layer.borderColor = #colorLiteral(red: 0.7803921569, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blancetype.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vc  = tableView.dequeueReusableCell(withIdentifier: "LeaveBlancecell") as! LeaveBlancecell
        let index = indexPath.row
        vc.lbl_Type.text = blancetype[index]["LeaveType"].stringValue
        vc.lbl_CarryForworded.text = blancetype[index]["CarryForwarded"].stringValue
        vc.lbl_Credited.text = blancetype[index]["CreditedIn"].stringValue
        vc.lbl_Aviled.text = blancetype[index]["AvailedIn"].stringValue
        vc.lbl_Pending.text = blancetype[index]["PendingForApproval"].stringValue
        vc.lbl_Balance.text = blancetype[index]["Balance"].stringValue
        return vc
    }
    @IBAction func btn_close(_ sender: Any) {
        dismissSemiModalView()
    }
    
    func getblanveAPI()
    {    CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
          var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int ,
           let PlantID = UserDefaults.standard.object(forKey: "PlantID") as? String{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"PlantID":PlantID,"Year":self.year]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserId":"0","PlantID":"0","Year": "2021"]
        }
        
        AF.request(base.url+"Leave_GetBalance", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseDecodable(of:JSON.self) { response in
                        print(parameters ?? "")
                        print(response ?? "")
                        switch response.result
                        {
                        
                        case .success(let value):
                            let json = JSON(value)
                            print(json)
                            let status = json["Status"].intValue
                            if status == 1
                            {
                                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                             
                            
                            self.blancetype = json["objLeaveBalanceType"]
                                self.tbl.reloadData()
                            }
                            else
                            {
                                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                                let msg = json["Message"].stringValue
                                self.showAlert(message: msg)
                                
                            }
               
                        case .failure(_):
                            print("code is not working .....")
                        }
                    
                    
                    
                    }
    }
    
}
class LeaveBlancecell:UITableViewCell
{
    @IBOutlet weak var lbl_Type: UILabel!
    @IBOutlet weak var lbl_CarryForworded: UILabel!
    @IBOutlet weak var lbl_Credited: UILabel!
    @IBOutlet weak var lbl_Aviled: UILabel!
    @IBOutlet weak var lbl_Pending: UILabel!
    @IBOutlet weak var lbl_Balance: UILabel!
    
}
