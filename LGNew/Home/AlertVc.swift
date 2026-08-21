//
//  AlertVc.swift
//  NewOffNet
//
//  Created by Ankit Rana on 21/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class AlertVc: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var getdata:JSON = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "alertcell") as! alertcell
        cell.Alertname.text = getdata[indexPath.row]["ModuleName"].stringValue
        cell.alertcount.text = getdata[indexPath.row]["PendingCount"].stringValue
       // cell.vv = statusView
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id =  getdata[indexPath.row]["ModuleID"].stringValue
        let count = getdata[indexPath.row]["PendingCount"].stringValue
        if id == "1"
        {   if count == "0"
        {
            self.showAlert(message: "There Is No Request Found")        }
        else
        {   
            let storyboard = UIStoryboard(name: "Leave", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "PendingDetailVC")as! PendingDetailVC
            self.navigationController?.pushViewController(secondVC, animated: true)
        }}
        else if id == "2"
        {   if count == "0"
        {
            self.showAlert(message: "There Is No Request Found")        }
        else {
            let storyboard = UIStoryboard(name: "AR", bundle: nil)
            let vc =  storyboard.instantiateViewController(withIdentifier: "ODPendingRequestVC") as! ODPendingRequestVC
            self.navigationController?.pushViewController(vc, animated: true)
        }}
        else if id == "3"
        {   if count == "0"
        {
            self.showAlert(message: "There Is No Request Found")        }
        else {
            let storyboard = UIStoryboard(name: "SL", bundle: nil)
            let vc =  storyboard.instantiateViewController(withIdentifier: "SL_Pending") as! SL_Pending
            self.navigationController?.pushViewController(vc, animated: true)
        }}
        else
        {
            if count == "0"
           {
               self.showAlert(message: "There Is No Request Found")        }
           else {
               let storyboard = UIStoryboard(name: "OD", bundle: nil)
               let vc =  storyboard.instantiateViewController(withIdentifier: "COPendingVC") as! COPendingVC
               self.navigationController?.pushViewController(vc, animated: true)
           }
        }
   

        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @IBOutlet weak var tblView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        servicecall()
       //
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(selectorMethod))
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
        if Language == "English"
            {
            self.navigationItem.title = "Alerts"
        }
            else
            {
                self.navigationItem.title = "अलर्ट"
            }
        }
        // Do any additional setup after loading the view.
    }
    @objc func selectorMethod() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        // CALL API
        servicecall()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barStyle = .default
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = base.firstcolor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    func servicecall()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        
        AF.request(base.url+"Dashboard_GetPendingData", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self)  { response in
                switch response.result
                {
                case .success(let Value):
                    let json:JSON = JSON(Value)
                    print(json)
                    print(response.request!)
                    print(parameters!)
                    let status = json["Status"].intValue
                    if status == 1
                    {
                        self.getdata = json["DashboardList"]
                        self.tblView.reloadData()
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        
                    }
                    else
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let msg = json["Message"].stringValue
                        self.showAlert(message: msg)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
    }
    
    
    
}
class alertcell:UITableViewCell
{
    @IBOutlet weak var vv: UIView!
    @IBOutlet weak var Alertname: UILabel!
    @IBOutlet weak var alertcount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        vv.layer.cornerRadius = 15
    }
    
}

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            
            alpha: 1.0
        )
    }
}
