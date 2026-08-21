//
//  NotificationVC.swift
//  NewOffNet
//
//  Created by Ankit Rana on 30/09/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
class NotificationVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var SliderImageList:JSON = []
    var Notificationid = ""
    var viewColor = ""
    
    @IBOutlet weak var tblview: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ApiCall()
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
        if Language == "English"
            {
            self.navigationItem.title = "Notification"
        }
            else
            {
                self.navigationItem.title = "सूचनाएं"
            }
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(selectorMethod))
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barStyle = .default
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = base.firstcolor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        ApiCall()
        
    }
    
    func ApiCall()
    {   let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID!] as [String : Any]
        
        //"TokenNo":"abcHkl7900@8Uyhkj","UserID":"14"}
        
        AF.request(base.url+"GetPushNotificationList", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response.request!)
                print(parameters)
                switch response.result
                {
            
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    let status = json["Status"].intValue
                    if status == 1
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.SliderImageList = json["PushNotificationList"]
                        self.tblview.reloadData()
                        if self.SliderImageList.isEmpty
                        {
                            let alert = UIAlertController(title: base.Title, message: "No New Notification ", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { action in
                                
                                
                                self.navigationController?.popViewController(animated: true)
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                    else
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        
                        let msg = json["Message"].stringValue
                        let alert = UIAlertController(title: base.Title, message: msg, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { action in
                            
                            // do something like...
                            self.navigationController?.popViewController(animated: true)
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
                
                
                
                
                
            }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SliderImageList.arrayValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "tblcell") as! tblcell
        cell.txt_msg.text = SliderImageList[indexPath.row]["Message"].stringValue
        cell.txt_Time.text = SliderImageList[indexPath.row]["DateTime"].stringValue
        self.Notificationid = SliderImageList[indexPath.row]["NotificationID"].stringValue
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MarkReadApi()
        var viewColor = "1"
    }
    
}

class tblcell: UITableViewCell {
    @IBOutlet weak var txt_Time: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txt_msg: UILabel!
    @IBOutlet weak var notificationView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


extension NotificationVC {
    func MarkReadApi()
    {   let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID!,"NotificatioID": self.Notificationid] as [String : Any]
        AF.request(base.url+"MarkNotification", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response.request!)
                print(parameters)
                switch response.result
                {
            
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    let status = json["Status"].intValue
                    if status == 1
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                     
                        self.ApiCall()
                       
                        
                    }
                    else
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        
                        let msg = json["Message"].stringValue
                        let alert = UIAlertController(title: base.Title, message: msg, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { action in
                            
                            // do something like...
                            self.navigationController?.popViewController(animated: true)
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
                
                
                
                
                
            }
        
        
    }
}

