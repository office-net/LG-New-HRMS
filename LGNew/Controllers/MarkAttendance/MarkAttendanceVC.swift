import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SemiModalViewController
protocol reloadData {
    func ab()
   
}
class MarkAttendanceVC: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate { 
    var locationManager = CLLocationManager()
    var lat : Double?
    var long :Double?
    var currentLocation: CLLocation!
    var strPunchInOut = ""
    var strintime = ""
    var strouttime = ""
    var strMatching = "0"
    var delegate:reloadData?
    var strmag = ""
    var UserID = 0
    var EmpCode = ""
    var arr:JSON = ["ankit":"1"]
    @IBOutlet weak var mapview: MKMapView!
    
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lb_intime: UILabel!
    
    @IBOutlet weak var btn_MarkAttendance: UIButton!
    @IBOutlet weak var lbl_outTime: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mark Attendance"
        lbl_Address.text = ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(MarkAttendanceVC.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()

        let status = Reach().connectionStatus()

        switch status {
        case .unknown, .offline:
            print("Not connected")
            presentAlert(title: base.Title, message: "Kindly wait for the address to be generated.") {
                self.navigationController?.popViewController(animated: true)
            }

        case .online(.wwan), .online(.wiFi):
            print("Connected via \(status)")
            setupLocationManager()
            setupMapView()
        }

        GetInOutStatusAPI()
     
       
        
    }
    
    
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
            
        }
        
    }
    
    @IBAction func btn_MarkAttendance(_ sender: Any) {
        if lbl_Address.text == ""
        {
            self.showAlert(message: "Please wait while address will be genrated.")
        }
        else
        {
            SavePunchInOutDetailsAPI()
        }
     
    }
    
    
    
    
    //=========================================================getLatLong===========================================================
    func getLatLong()
    {
       
        var parameters:[String:Any]?
        parameters = ["TokenNo": "abcHkl7900@8Uyhkj", "UserID": UserID, "VersionName": ""]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"GetPushNotificationList", parameters: parameters!) { (response,data) in
            print(response["LatlongdisattList"])
            let status =  response["Status"].intValue
            if status == 1
            {   let coordinateCurrent = CLLocation(latitude: self.lat ?? 0, longitude: self.long ?? 0)
                print("==================Current cordinate\(coordinateCurrent)")

                let notificationlist: JSON = response["LatlongdisattList"]
                print("==================cordinates Array \(notificationlist)")
                guard !notificationlist.isEmpty else {
                    print(notificationlist)
                    return
                }
                 for i in 0..<notificationlist.count {
                    let latitude = notificationlist[i]["Latitude"].stringValue
                    let longitude = notificationlist[i]["Longitude"].stringValue
                    let distancefromApi =  notificationlist[i]["Distance"].stringValue
                    print("api lat long and distance is ================ ", Double(distancefromApi) ?? 0, "  ", latitude, longitude)

                    let distance = coordinateCurrent.distance(from: CLLocation(latitude: Double("\(latitude)") ?? 0, longitude: Double("\(longitude)") ?? 0))

                    if distance <= Double(distancefromApi) ?? 0 {
                        print("from cordinste \(i)"," distance is \(distance) "," and Attendence Status is sucess")
                        self.strMatching = "1"
                        break
                    }
                    print("++++++++++++++++++++++++++++", distance)
                }

                if self.strMatching == "1" {
                    print("Succes")
                } else {
                  
                    self.GoToHome(Message:  self.strmag)
                }
                
                

            }
            else
            {   let msg = response["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
    }
    

    //=========================================================GetInOutStatusAPI===========================================================
 
    
    func GetInOutStatusAPI()
    {
        
        let EmpCodes = UserDefaults.standard.object(forKey: "EmpCode") as? String
        let UserIDs = UserDefaults.standard.object(forKey: "UserID") as? Int
        var parameters:[String:Any]?
        parameters = ["EmpCode":EmpCodes ?? "","TokenNo":"abcHkl7900@8Uyhkj","UserID":UserIDs ?? 0]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"GetInOutStatus", parameters: parameters!) { (response,data) in
            print(response)
            let status =  response["Status"].intValue
            if status == 1
            {   self.strmag =  response["distanceMessage"].stringValue
                self.lbl_outTime.text = response["OutTime"].stringValue
                self.lb_intime.text = response["InTime"].stringValue
                let Intime =  response["InTime"].stringValue
                self.strintime = Intime
                let outtime = response["OutTime"].stringValue
                self.strouttime = outtime
                if Intime == "0"
                {
                    self.btn_MarkAttendance.layer.name = "Day Off"
                    self.strPunchInOut = "PUNCHOUT"
                    
                }
                else if Intime == "1"
                {
                    self.btn_MarkAttendance.layer.name = "Mark Attendance"
                    self.strPunchInOut = "PUNCHIN"
                }
                if outtime == "0"
                {
                    self.btn_MarkAttendance.layer.name = "Mark Attendance"
                    self.strPunchInOut = "PUNCHIN"
                }
                else if outtime == "1"
                {
                    self.btn_MarkAttendance.layer.name = "Day Off"
                    self.strPunchInOut = "PUNCHOUT"
                }
                self.getLatLong()
            }
        }
    }
    
    
    
    
    //=========================================================SavePunchInOutDetailsAPI===========================================================
 
    
    
    func SavePunchInOutDetailsAPI()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        var parameters:[String:Any]?
        let UserIDs = UserDefaults.standard.object(forKey: "UserID") as? Int
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserIDs,"Latitude":lat ?? 0,"Longitude":long ?? 0,"Address":self.lbl_Address.text!,"Type":strPunchInOut,"DateTime":formattedDate,"FileInBase64":"","FileExt":"","AttendanceType":"ONLINE","Intime":self.strintime,"OutTime":self.strouttime]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"SavePunchInOutDetails", parameters: parameters!) { (response,data) in
            print(response)
            let status = response["Status"].intValue
            let Message = response["Message"].stringValue
            if status == 1
            {
                self.GoToHome(Message: Message)
            }
            else
            {
                self.GoToHome(Message: Message)
            }
            
        }
    }
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            
            mapview.mapType = MKMapType.standard
            
            let span =  MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: locValue, span: span)
            mapview.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = locValue
            annotation.title = "current location"
            annotation.subtitle = "current location"
            mapview.addAnnotation(annotation)
            
            
            
            
            let userLocation:CLLocation = locations[0] as CLLocation
            let geocoder =  CLGeocoder()
            geocoder.reverseGeocodeLocation(userLocation) { (Placemarks , error) in
                if error != nil
                {
                    print("error in reverseGeocodeLocation ")
                }
                
                let placemark = Placemarks ?? [] as [CLPlacemark]
                                  if (placemark.count>0)
                {
                    let placemark = Placemarks? [0]
                    let name =  placemark?.name ?? ""
                    
                    let subthouhfair = placemark?.subThoroughfare ?? ""
                    let throughfair = placemark?.thoroughfare ?? ""
                    let sublocality = placemark?.subLocality ?? ""
                    let localcity = placemark?.locality ?? ""
                    let subadmistrativearea = placemark?.subAdministrativeArea ?? ""
                    
                    let  administrativearea =  placemark?.administrativeArea ?? ""
                    let country = placemark?.country ?? ""
                    let postalcode = placemark?.postalCode ?? ""
                    self.lbl_Address.text = "\(subthouhfair) \(throughfair) \(sublocality) \(localcity) \(subadmistrativearea) \(administrativearea) \(country) \(postalcode) "
                    
                    //                print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\(name)")
                }
                
            }
            
            
            
        }
        
        
    }

    
    









extension MarkAttendanceVC
{
    func presentAlert(title: String, message: String, completion: (() -> Void)?) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: base.ok, style: .default) { _ in
            completion?()
        }
        dialogMessage.addAction(ok)
        present(dialogMessage, animated: true, completion: nil)
    }

    func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingLocation()
        }

        if let coor = mapview.userLocation.location?.coordinate {
            mapview.setCenter(coor, animated: true)
        }

        if let currentLocation = locationManager.location,
           currentLocation.horizontalAccuracy > 0 {
            self.lat = currentLocation.coordinate.latitude
            print(self.lat!)
            self.long = currentLocation.coordinate.longitude
            print(self.long!)
        }
    }

    func setupMapView() {
        mapview.delegate = self
        mapview.mapType = .standard
        mapview.isZoomEnabled = true
        mapview.isScrollEnabled = true
    }
    
    
    func GoToHome(Message:String)
    {
         
           let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
           let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
                UIAlertAction in
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            }
           alertController.addAction(okAction)
            DispatchQueue.main.async {
               
                self.dismissSemiModalView()
                self.delegate?.ab()
                self.present(alertController, animated: true)
            }
            
            
        }
    

}
