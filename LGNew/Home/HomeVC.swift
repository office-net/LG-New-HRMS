//
//  HomeVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 01/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import SemiModalViewController
import SDWebImage
import SideMenu

class HomeVC: UIViewController,reloadData{

   
    @IBOutlet weak var btnpunch: UIButton!
    @IBOutlet weak var working_Hrs: UILabel!

    @IBOutlet weak var lbl_UserName: UILabel!
   
    @IBOutlet weak var lbl_OutTime: UILabel!
    @IBOutlet weak var lbl_inOut: UILabel!
//    @IBOutlet weak var banner_Hieght: NSLayoutConstraint!
    @IBOutlet weak var lbl_intTime: UILabel!
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var TitlePunchInOut:UILabel!
    @IBOutlet weak var TitlePunchIn:UILabel!
    @IBOutlet weak var TitlePunchOut:UILabel!
    @IBOutlet weak var TitleLeaveAndReg:UILabel!
    @IBOutlet weak var TitleLeave:UILabel!
//    @IBOutlet weak var TitleCompOff:UILabel!
//    @IBOutlet weak var TitleHolidayList:UILabel!
//    @IBOutlet weak var Titleregularsation:UILabel!
    @IBOutlet weak var TitleManagement:UILabel!
    @IBOutlet weak var TitleDirectory:UILabel!
//    @IBOutlet weak var TitleAttendance:UILabel!
    @IBOutlet weak var TitleMyTeam:UILabel!

    @IBOutlet weak var TitleAnniversary:UILabel!
//    @IBOutlet weak var TitleNotes:UILabel!
    @IBOutlet weak var TitleSuggestion:UILabel!
    @IBOutlet weak var titleMyRequest: UIButton!
    @IBOutlet weak var title_MyApprovals: Gradientbutton!

    var lat : Double?
    var long :Double?
    var Address = ""
    var accurecy = ""
    var IsFaceRecognitionRequired: Bool?
    var IsUploaded: Bool?
    var FaceImage: String?
    var AttendanceInput = ""
    func ab() {
      //  getinOutstatus()
        getdetailsApi()
    }
    var x = 1
    var imgaray:JSON = []
    var timer = Timer()
    var counter = 0
    var counter2 = 0
    var counter3 = 0
    var birthdayData:JSON = []
    var newjoineeData:JSON = []
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let TokenNo = "abcHkl7900@8Uyhkj"
        UserDefaults.standard.set(TokenNo, forKey: "TokenNo")
        self.checkForUpdates(appID: base.APP_ID, url_Name: base.Url_Name)
        let userName = UserDefaults.standard.object(forKey: "UserName") as? String
        lbl_UserName.text = userName
        btnpunch.isHidden = false
        self.getUserLocation()
    }
    
    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        
    }
 
    @IBAction func Short_Leave(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SL", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "ShortLeaveVC")as! ShortLeaveVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btn_MyApproval(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "MyApprovalVC")as! MyApprovalVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btn_myRequest(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "MyRequestVC")as! MyRequestVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func setupSideMenu() {
        
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func getdetailsApi()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"VersionName":""]
        }
        Networkmanager.postRequest(vv: self.view, remainingUrl:"GetPushNotificationList", parameters: parameters!) { (response,data) in
            let json:JSON = response
            print(json)
            let status =  json["Status"].intValue
            if status == 1
            {
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                let defaults = UserDefaults.standard
                if json["InTimeLive"].stringValue == "" || json["OutTimeLive"].stringValue != ""
                {
                    defaults.set(false, forKey: "IsLocationUpdate")
                }
                else
                {
                    defaults.set(true, forKey: "IsLocationUpdate")
                    
                }
                self.IsUploaded = response["Isuploaded"].boolValue
                self.IsFaceRecognitionRequired = response["IsFaceRecgonisationRequired"].boolValue
                self.FaceImage = response["FaceImage"].stringValue
                let FaceImage = self.FaceImage
                defaults.set(FaceImage, forKey: "FaceImage")
                let Attendanceinput = json["AttendanceInput"].stringValue
                self.AttendanceInput =  Attendanceinput
                UserDefaults.standard.set(Attendanceinput, forKey: "AttendanceInput")
                self.imgaray = json["SliderImageList"]
                print(self.imgaray)
    
                let checkUser = UserDefaults.standard.object(forKey: "ChangePWDDate") as? String
                print("changepwdPass ====>>>>> \(String(describing: checkUser))")
                if json["ChangePwdDate"].stringValue == checkUser && json["ActiveUserStatus"].boolValue == true {
                    print("ChangePwdDate is match =====>>>> ")
                }
                else{
                    print("ChangePwdDate is not match =====>>>> ")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                }
              
                let totalPendingCount = json["PendingCount"].intValue
                // Assuming your tab indices are 1 and 2
                if let tabBarController = self.tabBarController {
                    // Set badges for tab indices 1 and 2
                    if let tabBarItems = tabBarController.tabBar.items {
                        tabBarItems[1].badgeValue = totalPendingCount > 0 ? "\(totalPendingCount)" : nil
                    }
                }
                // code Complete
                //MARK: Attendance punchIN
                self.lbl_intTime.text = json["InTimeLive"].stringValue
                self.lbl_OutTime.text = json["OutTimeLive"].stringValue
                    if json["InTimeLive"].stringValue != "" && json["OutTimeLive"].stringValue == ""
                    {
                        let wrkHrs = self.timeDifference(fromTime: json["InTimeLive"].stringValue, toTime: Date.getCurrentTime_HH_mm_a())
                        self.working_Hrs.text = "\(wrkHrs ?? "")"
                    }
                    else if json["OutTimeLive"].stringValue != ""
                    {
                        let wrkHrs = self.timeDifference(fromTime: json["InTimeLive"].stringValue, toTime:json["OutTimeLive"].stringValue)
                        self.working_Hrs.text = "\(wrkHrs ?? "")"
                    }
                    if json["IsInButtonVisable"].intValue == 1
                    {
                        self.lbl_inOut.text = "Punch In"
                    }
                    else if json["IsOutButtonVisable"].intValue == 1
                    {
                        self.lbl_inOut.text = "Punch Out"
                    }
                    else
                    {
                        print("Unknowmn")
                    }
         
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
            }
            else
            {
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
        
    }
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let url = URL(string: urlString), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
  
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setBrightness(0.5)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barStyle = .default
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = base.firstcolor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.getLocation()
        }
      //  getinOutstatus()
        getdetailsApi()
        
        if let Language = UserDefaults.standard.string(forKey: "Language")
        {
            print("============\(Language)")
            
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
    func maskCircle(anyImage: UIImageView) -> UIImageView {
        let img = anyImage
        img.contentMode = UIView.ContentMode.scaleAspectFill
        img.layer.cornerRadius = img.frame.height / 2
        img.layer.masksToBounds = false
        img.clipsToBounds = true
        return img
        
    }
    
   
    @IBAction func btn_HolidayCalander(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HolidayVC")as! HolidayVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
        @IBAction func btn_markatendance(_ sender: Any) {
        self.MarkAttendance()
    }
    @IBAction func btn_suggestion(_ sender: Any) {
        
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "SalaryVC") as! SalaryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btn_mytean(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "MyTeamVC") as! MyTeamVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
   @IBAction func Attendabce_btn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
       
        let vc = storyboard.instantiateViewController(withIdentifier: "CalenderClass") as! CalenderClass
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        vc.UserIDD = "\(UserID!)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btn_WorkAnniver(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Note", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotesVC") as! NotesVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btn_Reguarzation(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AR", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegulazationVC") as! RegulazationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
      @IBAction func btn_dierctoryt(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Directory", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "Directory") as! Directory
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    @IBAction func btn_leave(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Leave", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "LeaveVC")as! LeaveVC
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    
    @IBAction func Con_Leave(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Con_Leave", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "Con_Leave")as! Con_Leave
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    @IBAction func Con_Reg(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Con_AR", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "Con_AR")as! Con_AR
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
}



extension HomeVC
{
    func Translate(index:Int)
    {
        if index == 0
        {   self.title = "Home"
            self.TitlePunchInOut.text = "PunchInOut".localizableString(loc: "en")
            self.TitlePunchIn.text = "PunchInt".localizableString(loc: "en")
            self.TitlePunchOut.text = "PunchOut".localizableString(loc: "en")
            self.TitleLeaveAndReg.text = "Leave & Regularization".localizableString(loc: "en")
            self.TitleLeave.text = "Leave".localizableString(loc: "en")
            self.TitleManagement.text = "Management".localizableString(loc: "en")
            self.TitleDirectory.text = "Directory".localizableString(loc: "en")
            self.TitleMyTeam.text = "MyTeam".localizableString(loc: "en")
            self.titleMyRequest.setTitle( "Myrequest".localizableString(loc: "en"), for: .normal)
            self.title_MyApprovals.setTitle( "MyApprovals".localizableString(loc: "en"), for: .normal)
   
        }
        else
        {
            self.title = "होम"
            self.TitlePunchInOut.text = "PunchOut".localizableString(loc: "hi")
            self.TitlePunchIn.text = "PunchInt".localizableString(loc: "hi")
            self.TitlePunchOut.text = "PunchOut".localizableString(loc: "hi")
            self.TitleLeaveAndReg.text = "LeaveAndRegularazation".localizableString(loc: "hi")
            self.TitleLeave.text = "Leave".localizableString(loc: "hi")

            self.TitleManagement.text = "Management".localizableString(loc: "hi")
            self.TitleDirectory.text = "Directory".localizableString(loc: "hi")
            self.TitleMyTeam.text = "MyTeam".localizableString(loc: "hi")
            self.titleMyRequest.setTitle( "Myrequest".localizableString(loc: "hi"), for: .normal)
            self.title_MyApprovals.setTitle( "MyApprovals".localizableString(loc: "hi"), for: .normal)

            
        }
    }
    
}


