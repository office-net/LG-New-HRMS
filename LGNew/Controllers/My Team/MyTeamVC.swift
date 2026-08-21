//
//  MyTeamVC.swift
//  Myomax officenet
//
//  Created by Mohit Shrama on 16/06/20.
//  Copyright © 2020 Mohit Sharma. All rights reserved.
//

import UIKit

class MyTeamVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var arrMyTeamList = [String]() as? NSMutableArray

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Team"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
       
        GetMyTeamListAPI()
    }
    
   
    
    func SendToHome() {
        self.navigationController?.popViewController(animated: true)

    
    }
    
  
    
    // Service Call
    func GetMyTeamListAPI()  {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters =  ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        
        let url = URL(string: base.url+"GetMyTeamList")! //change the url
        //create the session object
        print(url)
        print(parameters!)
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
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
                    let status = json["Status"] as? Int
                    if status == 1 {
                        
                        
                        self.arrMyTeamList = (json["MyTeamList"] as? NSMutableArray)!
                        print("self.arrMyTeamList",self.arrMyTeamList!)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }else{
                        
                        let Message = json["Message"] as? String
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
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
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if let dic =  self.arrMyTeamList?[(sender?.view!.tag)!] as? NSDictionary {
            let empID = dic.value(forKey: "EmpID") as? String
            let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CalenderClass") as! CalenderClass
            vc.UserIDD = "\(empID!)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
      
    }
}

extension MyTeamVC:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyTeamList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTeamCell") as! myTeamCell
      //  cell.imgProfile.makeRounded()
        if let dic =  self.arrMyTeamList?[indexPath.row] as? NSDictionary {
            cell.lblName.text = dic.value(forKey: "EmpName") as? String
            cell.lblPosition.text =  "Employee Code : " + "\(dic.value(forKey: "EmpCode") as? String ?? "")"
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.ImageCalender.isUserInteractionEnabled = true
            cell.ImageCalender.tag = indexPath.row
            cell.ImageCalender.addGestureRecognizer(tap)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
//MARK:-MenuTableViewCell
class myTeamCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ImageCalender: UIImageView!
    @IBOutlet weak var imgCalender: NSLayoutConstraint!
    @IBOutlet weak var lblPosition: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

}
extension UIImageView {

    func makeRounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
