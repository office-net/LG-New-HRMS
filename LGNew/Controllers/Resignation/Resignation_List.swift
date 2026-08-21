//
//  Resignation_List.swift
//  ADLls
//
//  Created by Ankit Rana on 26/08/24.
//

import UIKit
import SwiftyJSON

class Resignation_List: UIViewController {
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var SepReqList:JSON = []
    var Typee = "UserView"
    override func viewDidLoad() {
        super.viewDidLoad()
        uisetup()
    }
    
    @IBAction func btn_New(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Resignation", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "Resignation_Form") as! Resignation_Form
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
   
    @IBAction func sg(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0
        {
            self.Typee = "UserView"
            ServiceCall()
        }
        else
        {
            self.Typee = "Archived"
            ServiceCall()
        }
        
    }
    
}



extension Resignation_List
{
    func uisetup()
    {   self.title = "Resignation List"
        let normalTextColor = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.setTitleTextAttributes(normalTextColor, for: .normal)
        let selectedTextColor = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(selectedTextColor, for: .selected)
        tbl.delegate = self
        tbl.dataSource = self
        ServiceCall()
    }
}







extension Resignation_List
{
    func ServiceCall()
    {
         let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["Type":Typee,"RegDate": "","ReqNo": "","UserId":UserID!,"TokenNo":"abcHkl7900@8Uyhkj"] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"SeparationList", parameters: parameters) { (response,data) in
            print(response)
            if response["Status"].intValue == 1
            {
                self.SepReqList = response["SepReqList"]
                self.tbl.reloadData()
            }
            else
            {
                self.showAlert(message: response["Message"].stringValue)
            }
        }
        
    }
}









//MARK: TABLEVIEW DELEGATE DATASOURCE



extension Resignation_List:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SepReqList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resigimationCell", for: indexPath) as! resigimationCell
        cell.status.text = SepReqList[indexPath.row]["FinalStatus"].stringValue
        cell.request_Date.text = SepReqList[indexPath.row]["ReqDate"].stringValue
        cell.Resign_Date.text = SepReqList[indexPath.row]["ResignDate"].stringValue
        cell.Request_number.text = SepReqList[indexPath.row]["ReqNo"].stringValue
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Resignation", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "Resigination_Details") as! Resigination_Details
        vc.ReqID = SepReqList[indexPath.row]["ResigID"].stringValue
        vc.Typeeee = self.Typee
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}















//MARK: Table view cell class

class resigimationCell:UITableViewCell
{
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var request_Date: UILabel!
    @IBOutlet weak var Resign_Date: UILabel!
    @IBOutlet weak var Request_number: UILabel!
    
}
