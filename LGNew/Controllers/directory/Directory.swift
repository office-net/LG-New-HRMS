//
//  Directory.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 05/10/21.
//

import UIKit
import SDWebImage
import SemiModalViewController
import SwiftyJSON

class Directory: UIViewController,UITabBarDelegate,UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, DirectortFilterProtocol {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var selectedIndexPath: NSIndexPath? = nil
    var arrEmpDirList = [String]() as? NSMutableArray
    var filtered = [String]() as? NSMutableArray
    var searchActive : Bool = false
    var SearchBarValue:String!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                self.title = "Directory"
            }
            else
            {
                self.title = "निर्देशिका"

            }
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        Dir_EmployeeListAPI(name: "", empCode: "%", locationID: "0", departmentID: "0", designationID: "0")
        
        // Do any additional setup after loading the view.
        self.searchBar.showsCancelButton = false
        self.searchBar.delegate = self
        
        
        
    }
    
//    @IBAction func btn_filter(_ sender: UIButton) {
//        let vc = DirectorySearch(nibName: "DirectorySearch", bundle: nil)
//        vc.delegate = self
//        self.navigationController!.present(vc, animated: true, completion: nil)
//    }
//
    
    func getAllInfo(depId:String,desigId:String,locId:String,name:String,empCode:String) {
        Dir_EmployeeListAPI(name: name, empCode: empCode, locationID: locId, departmentID: depId, designationID: desigId)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            
            return self.filtered?.count ?? 0
            
        }else{
            return self.arrEmpDirList?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dirtableviewcell", for: indexPath)as! dirtableviewcell
        
        if(searchActive){
            
            if let dic =  self.filtered?[indexPath.row] as? NSDictionary {
                
                cell.lbl_name.text = dic.value(forKey: "EmpName") as? String
                cell.lbl_desiginatiom.text = dic.value(forKey: "EmpDesignation") as? String
                cell.lbl_department.text = dic.value(forKey: "EmpDepartment") as? String
                cell.lbl_rm.text = dic.value(forKey: "EmpRM") as? String
                cell.number = (dic.value(forKey: "EmpMobileNo") as? String)!
                cell.mailid = (dic.value(forKey: "EmpEmailID") as? String)!
                let EmpImagePath = dic.value(forKey: "EmpImagePath") as? String
                
             
            }
        }
        else
        {
            if let dic =  self.arrEmpDirList?[indexPath.row] as? NSDictionary {
                cell.lbl_name.text = dic.value(forKey: "EmpName") as? String
                cell.lbl_desiginatiom.text =  dic.value(forKey: "EmpDesignation") as? String
                cell.lbl_department.text = dic.value(forKey: "EmpDepartment") as? String
                cell.lbl_rm.text = dic.value(forKey: "EmpRM") as? String
                cell.number = (dic.value(forKey: "EmpMobileNo") as? String)!
                cell.mailid = (dic.value(forKey: "EmpEmailID") as? String)!
                let EmpImagePath = dic.value(forKey: "EmpImagePath") as? String
          
                
            }
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(searchActive){
            
            let dic =  self.filtered?[indexPath.row] as? NSDictionary
            
            let options: [SemiModalOption : Any] = [
                SemiModalOption.pushParentBack: false
            ]
            let storyboard = UIStoryboard(name: "Directory", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "DirectoryChildVC") as! DirectoryChildVC
            pvc.rmname = (dic!.value(forKey: "EmpRM") as? String)!
            pvc.hodname = (dic?.value(forKey: "EmpHOD") as? String)!
            pvc.departmentname = (dic?.value(forKey: "EmpDepartment") as? String)!
            pvc.location = (dic?.value(forKey: "EmpLocation") as? String)!
            pvc.bloodgroup = (dic?.value(forKey: "EmpBloodGroup") as? String)!
       
            pvc.number = (dic?.value(forKey: "EmpMobileNo") as? String)!
            pvc.mailid = (dic?.value(forKey: "EmpEmailID") as? String)!
            
            pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 440)
            
            pvc.modalPresentationStyle = .overCurrentContext
            //  pvc.transitioningDelegate = self
            
            presentSemiViewController(pvc, options: options, completion: {
                print("Completed!")
            }, dismissBlock: {
            })
            
            
        }
        else
        {
            let dic =  self.arrEmpDirList?[indexPath.row] as? NSDictionary
            
            let options: [SemiModalOption : Any] = [
                SemiModalOption.pushParentBack: false
            ]
            let storyboard = UIStoryboard(name: "Directory", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "DirectoryChildVC") as! DirectoryChildVC
            pvc.rmname = (dic!.value(forKey: "EmpRM") as? String)!
            pvc.hodname = (dic?.value(forKey: "EmpHOD") as? String)!
            pvc.departmentname = (dic?.value(forKey: "EmpDepartment") as? String)!
            pvc.location = (dic?.value(forKey: "EmpLocation") as? String)!
            pvc.bloodgroup = (dic?.value(forKey: "EmpBloodGroup") as? String)!
     
            pvc.number = (dic?.value(forKey: "EmpMobileNo") as? String)!
            pvc.mailid = (dic?.value(forKey: "EmpEmailID") as? String)!
            pvc.emergencyname = (dic?.value(forKey: "EmpEmergencyContactPerson") as? String)!
            pvc.emergencyNO = (dic?.value(forKey: "EmpEmergencyContactNo") as? String)!
            
            pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 520)
            
            pvc.modalPresentationStyle = .overCurrentContext
            //  pvc.transitioningDelegate = self
            
            presentSemiViewController(pvc, options: options, completion: {
                print("Completed!")
            }, dismissBlock: {
            })
            
            
        }
        
    }
    
    //Search bar
      func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
          searchActive = true
      }
      
      func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
          searchActive = false
          searchBar.text = nil
          self.searchBar.showsCancelButton = false
           tableView.reloadData()
      }
      
      func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
          searchActive = false;
          searchBar.text = nil
          searchBar.resignFirstResponder()
          //tableView.resignFirstResponder()
          self.searchBar.showsCancelButton = false
          self.filtered?.removeAllObjects()
          self.tableView.reloadData()
      }
      
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         // searchActive = true
         // searchBar.resignFirstResponder()
          searchBar.endEditing(true)
      }
      
      func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
          return true
          
      }
    
    // add adition implement 
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.isEmpty && searchBar.text?.isEmpty == true {
            // Clear button was pressed, reset the search state
            searchActive = false
            tableView.reloadData() // Reload the table view with the original data
        }
        return true
    }
      
      
      func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          
          self.searchActive = true;
          self.searchBar.showsCancelButton = true
    
          
          self.filtered?.removeAllObjects()
          let namePredicate = NSPredicate(format: "EmpName CONTAINS[C] %@",searchText);
          let EmpCodePredicate = NSPredicate(format: "EmpCode CONTAINS[C] %@",searchText);
          let DepartmentPredicate = NSPredicate(format: "EmpDepartment CONTAINS[C] %@",searchText);
          let filter = self.arrEmpDirList?.filtered(using: namePredicate)
          
          let filter2 = self.arrEmpDirList?.filtered(using: EmpCodePredicate)
          
          let filter3 = self.arrEmpDirList?.filtered(using: DepartmentPredicate)
          
          self.filtered = NSMutableArray(array: filter ?? [])
          if self.filtered == []
          {
              self.filtered = NSMutableArray(array: filter2 ?? [])
          }
          
          if self.filtered == []
          {
              self.filtered = NSMutableArray(array: filter3 ?? [])
          }
          
        
          self.tableView.reloadData()
          
          
      }
      // Touch event
      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          searchBar.resignFirstResponder()
          searchBar.endEditing(true)
          self.view.endEditing(true)
          self.searchBar.showsCancelButton = false
          self.searchBar.text=""
      }
    
    // service call
    
    func Dir_EmployeeListAPI(name:String,empCode:String,locationID:String,departmentID:String ,designationID:String )  {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        var parameters:[String:Any]?
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj","Name":name,"EmpCode":empCode,"LocationID":Int(locationID)!,"DepartmentID":Int(departmentID)!,"DesignationID":Int(designationID)!,"Status":1,"LoginID":UserID!]
        
        
        
        let url = URL(string: base.url+"Dir_EmployeeList")! //change the url
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
            // pass dictionary to nsdata object and set it as request body
            print("hvfhjdfvhdvdfvhjdfv\(request.httpBody)")
            print(parameters as Any)
        } catch let error {
            print(error.localizedDescription)
        }
        
        // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJlbmRlciI6Im5hbmRhbiIsImlhdCI6MTU4MDIwNTI5OH0.ATXxNeOUdiCmqQlCFf0ZxHoNA7g9NrCwqRDET6mVP7k", forHTTPHeaderField:"x-access-token" )
        
        
        //create dataTask using the session object to send data to the server
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
                
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    print(request)
                    print(parameters as Any)
                    let status = json["Status"] as? Int
                    
                    if status == 1 {
                        print(json)
                        print(request)
                        print(parameters as Any)
                        
                        self.arrEmpDirList = (json["EmpDirList"] as? NSMutableArray)!
                        print("self.arrDashboardList",self.arrEmpDirList!)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }else{
                        
                        let Message = json["Message"] as? String
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        // Create the actions
                        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.SendToHome()
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            
                            self.present(alertController, animated: true)
                        }
                        
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        
    }
    func SendToHome()
    {        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
class dirtableviewcell:UITableViewCell
{
    // outlets
    var number = ""
    var mailid = ""
    @IBOutlet weak var Title_Name: UILabel!
    @IBOutlet weak var Title_desigination: UILabel!
    @IBOutlet weak var Title_department: UILabel!
    @IBOutlet weak var Title_RM: UILabel!
    @IBOutlet weak var btn_Call: UIButton!
    @IBOutlet weak var btn_Mail: UIButton!
   
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_desiginatiom: UILabel!
    @IBOutlet weak var lbl_rm: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
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
    }
    
    @IBOutlet weak var lbl_department: UILabel!
    
    @IBAction func btn_Mail(_ sender: Any) {
        
        let mailtoString = "mailto:\(mailid)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mailtoUrl = URL(string: mailtoString!)!
        if UIApplication.shared.canOpenURL(mailtoUrl) {
            UIApplication.shared.open(mailtoUrl, options: [:])
        }
        
    }
    func Translate(index:Int)
    {
        
        
        if index == 0
        {
            self.Title_Name.text = "Name".localizableString(loc: "en")
            self.Title_desigination.text = "Desigination".localizableString(loc: "en")
            self.Title_department.text = "DepartmentKey".localizableString(loc: "en")
            self.Title_RM.text = "ReportingManager".localizableString(loc: "en")
            
            
            //OtherDetails
        }
        else
        {
            
            
            self.Title_Name.text = "Name".localizableString(loc: "hi")
            self.Title_desigination.text = "Desigination".localizableString(loc: "hi")
            self.Title_department.text = "DepartmentKey".localizableString(loc: "hi")
            self.Title_RM.text = "ReportingManager".localizableString(loc: "hi")
            
            
            
            
        }
        
        
    }
    @IBAction func btn_Call(_ sender: Any) {
        
        if let url = URL(string: "tel://\(number)") {
            UIApplication.shared.open(url)
        }
    }
    
}

