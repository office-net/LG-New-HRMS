import CoreData
import IQKeyboardManagerSwift
import SwiftyJSON
import CoreLocation
import IQKeyboardToolbarManager
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate ,CLLocationManagerDelegate{
    //
    private var locationManager:CLLocationManager?
    var lat : Double?
    var long :Double?
    var Address = ""
    var n = 10
    var accurecy = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardToolbarManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistance = 10.0       // var timer = Timer.scheduledTimer(timeInterval: TimeInterval(n), target: self, selector: #selector(getLocation), userInfo: nil, repeats: true)
      //  getUserLocation()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    
}


extension AppDelegate
{
    @objc func getLocation()
    {
                    print("Location function Called From App Delegate")
                    let defaults = UserDefaults.standard
                    let data = defaults.object(forKey: "IsLocationUpdate") as? Bool
                     if data == true
                     {
                         if let lat  = UserDefaults.standard.object(forKey: "Lat") as? String, let Long = UserDefaults.standard.object(forKey: "Long") as? String
                         {
                             if lat == "a" && Long == "a"
                             {
                               print("Lat long is empty APP Delegate")
                              }
                             else
                             {
                                 print(lat,Long)
                                 let Distance = GetDistance_btw_Cordinates(latitude1: self.lat!, longitude1: self.long!, latitude2: Double(lat)!, longitude2: Double(Long)!)
                                 if Distance > 10
                                 {   UserDefaults.standard.set("\(self.lat!)", forKey: "Lat")
                                     UserDefaults.standard.set("\(self.long!)", forKey: "Long")
                                     ApiCallingTrackLocation(lat: "\(self.lat!)", long: "\(self.long!)", Address: self.Address, accurecy: self.accurecy)
                                 }
                                 else
                                 {
                                     print("Distance is \(Distance) which is less then 100 meters")
                                 }
                             }
                         }
                         
                     }
                     else
                    {
                         print("Attenadnce not Marked")
                    }
        
        

    }
    
    
    func GetDistance_btw_Cordinates(latitude1:Double,longitude1:Double,latitude2:Double,longitude2:Double) -> Double
    {
        let location1 = CLLocation(latitude: latitude1, longitude: longitude1)
        let location2 = CLLocation(latitude: latitude2, longitude: longitude2)
        let distanceInMeters = location1.distance(from: location2)
        return distanceInMeters
    }
    
    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.allowsBackgroundLocationUpdates = true
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.lat = location.coordinate.latitude
            self.long = location.coordinate.longitude
            self.accurecy = String(format: "%f", location.horizontalAccuracy)
            let UserLocation = locations[0] as CLLocation
            let GeoCoder = CLGeocoder()
            GeoCoder.reverseGeocodeLocation(UserLocation) { (Placemarks,error) in
                if (error != nil)
                {
                    print("Error in reverseGeocodeLocation ")
                }
                
                
                let placemark = (Placemarks ?? [] ) as [CLPlacemark]
                if (placemark.count>0)
                {
                    let p = Placemarks![0]
                    let street = p.subLocality ?? ""
                    let locatity = p.locality ?? ""
                    let subThoroughfare  = p.postalCode ?? ""
                    let addmistraivearea = p.administrativeArea ?? ""
                    let country = p.country ?? ""
                    self.Address = "\(street) \(locatity) \(subThoroughfare) \(addmistraivearea) \(country)"
                    
                }
                
                
                
            }
            
            
            
        }
    }
    
    
    
    
    func ApiCallingTrackLocation(lat:String , long:String , Address:String , accurecy:String)
    {  var parameters:[String:Any]?
       if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int

        { parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserId":UserID,"LocationArrList":[["LocationID":0,"Latitude":lat,"Longitude":long,"Timestamp": base.getCurrentTimestamp(),"AccuracyMeters":accurecy,"Address":Address,"IsFakeUser": 0]]]
          }
        else
        {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserId":0,"LocationArrList":[["LocationID":0,"Latitude":lat,"Longitude":long,"Timestamp":base.getCurrentTimestamp(),"AccuracyMeters":accurecy,"Address":Address]] ]
        }
        Networkmanager2.postRequest(remainingUrl:"TrackedUserLocations", parameters: parameters!) { (response,data) in
            let json:JSON = response
            let status = json["Status"].intValue
            if status == 1
            {
                print(json)
            
            }

        }
    }
}
