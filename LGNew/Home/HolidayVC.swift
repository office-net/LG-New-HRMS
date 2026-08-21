//   HolidayVC.swift
//  NewOffNet
//  Created by Ankit Rana on 16/11/21.


import UIKit
import SemiModalViewController
import Alamofire
import SwiftyJSON


class HolidayVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource , UIPickerViewDelegate, UITextFieldDelegate {
     var isfromHome = 0
    var year = [String]()
    var LocationList:JSON = []
    var holidaylist:JSON = []
    var plantid = ""
    var gradePicker = UIPickerView()
  
    @IBOutlet weak var txt_Year: UITextField!
    @IBOutlet weak var btnfilter: UIBarButtonItem!
    @IBOutlet weak var txt_Location: UITextField!
    @IBOutlet weak var btn_Search: UIButton!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet weak var view_hight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let PlantID = UserDefaults.standard.object(forKey: "PlantID") as? String
        self.plantid = PlantID!
        self.view_hight.constant = 0
        self.viewFilter.layer.borderWidth = 1
        self.viewFilter.layer.borderColor = base.secondcolor.cgColor
        self.btn_Search.layer.borderWidth = 1
        self.btn_Search.layer.borderColor =  base.secondcolor.cgColor
        self.btn_Search.layer.backgroundColor = UIColor.white.cgColor
        gradePicker.delegate = self
        gradePicker.dataSource = self
        if #available(iOS 16.0, *) {
            self.btnfilter.isHidden = true
        } else {
            // Fallback on earlier versions
        }
        
        txt_Location.delegate = self
        txt_Location.inputView = gradePicker
        txt_Year.delegate = self
        txt_Year.inputView = gradePicker
        
        
        

        
        
        //=======================
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        let tyear = components.year
        self.year = ["\(tyear! - 1)","\(tyear!)","\(tyear! + 1)"]
      //  self.txt_Year.text = year[1]
        
        getHolidayList(year: Date.getCurrentYear(), LocationID: PlantID ?? "")
        getPlantID()
     
        
        //=============================
       
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(selectorMethod))
        
    }
    @objc func selectorMethod() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        
    }
  
    
    func getPlantID()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        

        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserId":UserID!,"HolidayYear": self.year[1] ] as [String : Any]
        AF.request(base.url+"GetLocationList", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self) { response in
                print(parameters)
                print(response.request!)
                switch response.result
                {
                
                case .success(let ankit):
                    let json:JSON = JSON(ankit)
                    let status = json["Status"].intValue
                    if status == 1
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.LocationList = json["LocationList"]
                        self.txt_Location.text = json["LocationList"][0]["LocationName"].stringValue
                        self.plantid = json["LocationList"][0]["LocationID"].stringValue
//                        self.getHolidayList(year: Date.getCurrentYear(), LocationID: json["LocationList"][0]["LocationID"].stringValue)
                        
                    }
                    else
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let massage = json["Message"].stringValue
                       // self.showAlert(message: massage)
                    }
                    print(json)
                case .failure(let rana):
                    print(rana.localizedDescription)
                }
                
                
                
            }
        
        
    }
    
    

    

    
    func getHolidayList(year:String,LocationID:String)
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        var parameters:[String:Any]?
      
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj","LocationID":LocationID,"HolidayYear":year,"UserId":UserID ?? 0 ]
        
        AF.request(base.url+"GetHolidayList", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self) { response in
                print(response.request!)
                print(parameters!)
                switch response.result
                {
                    
                
                case .success(let Ankit):
                    self.holidaylist = JSON(Ankit)
                    print(self.holidaylist)
                    
                    let status =  self.holidaylist["Status"].intValue
                    if status == 1
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        
                    }
                    else{
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let massage = self.holidaylist["Message"].stringValue
                        
                        let alert = UIAlertController(title: base.Title, message:massage , preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: base.ok, style: UIAlertAction.Style.destructive, handler: { action in

                            // do something like...
                            //self.navigationController?.popViewController(animated: true)

                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    self.tblview.reloadData()
                case .failure(let rana):
                    print(rana.localizedDescription)
                }
            }
    
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if txt_Location.isFirstResponder {
        
        return LocationList.arrayValue.count
        }
        else
        {
            return year.count
        }
       
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if txt_Location.isFirstResponder
        {
        
        return LocationList[row]["LocationName"].stringValue
        }
        else{
            return year[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    
        if txt_Location.isFirstResponder
        {
          
        txt_Location.text = LocationList[row]["LocationName"].stringValue
        self.plantid = LocationList[row]["LocationID"].stringValue
        }
        else
        {
            txt_Year.text = year[row]
        }
     
       
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txt_Year
        {
            if txt_Year.text == ""
            {
                txt_Year.text = year[0]
            }
        }
        
        if textField == txt_Location
        {
            if txt_Location.text == ""
            {
                txt_Location.text = LocationList[0]["LocationName"].stringValue
                self.plantid = LocationList[0]["LocationID"].stringValue
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // No need for semicolon
        if isfromHome == 1
        {
          self.navigationController?.setNavigationBarHidden(false, animated: true)
          navigationController?.navigationBar.barStyle = .default
          self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
          self.navigationController?.navigationBar.tintColor = UIColor.black
          self.navigationController!.view.backgroundColor = UIColor.clear
            self.navigationController?.navigationBar.backgroundColor = base.firstcolor
          self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        else
        {
            print("from launcher")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return holidaylist["HolidayCalList"].arrayValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "holidatcel")as! holidatcel
        cell.lbl_FestivalName.text = holidaylist["HolidayCalList"][indexPath.row]["Occation"].stringValue
        cell.lbl_daycoutn.text = holidaylist["HolidayCalList"][indexPath.row]["DayStatus"].stringValue

        cell.lbl_time.text = ("\(holidaylist["HolidayCalList"][indexPath.row]["Date"].stringValue) ,") + holidaylist["HolidayCalList"][indexPath.row]["Day"].stringValue
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        self.getHolidayList(year: self.txt_Year.text!, LocationID: self.plantid )
        self.view_hight.constant = 0
        
       
    }
    @IBAction func btn_filter(_ sender: Any) {
        if view_hight.constant == 0
        {
            self.view_hight.constant = 0
            
        }
        else
        {
            self.view_hight.constant = 0
        }
      
    }
      
}
class holidatcel:UITableViewCell
{
  
    override func awakeFromNib() {
        super.awakeFromNib()

      
        
        
    }
    @IBOutlet weak var lbl_FestivalName: UILabel!
    @IBOutlet weak var card_view: UIView!
    

    @IBOutlet weak var lbl_daycoutn: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    
}
