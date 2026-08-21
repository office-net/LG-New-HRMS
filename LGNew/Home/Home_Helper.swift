//  Home_Helper.swift
//  VishalMegaMartls
//  Created by Netcommlabs on 20/10/23.

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import SemiModalViewController
import SDWebImage
import SideMenu

extension HomeVC {
    func setBrightness(_ brightness: CGFloat) {
        let screen = UIScreen.main
        screen.brightness = brightness
    }
    func MarkAttendance() {
        if self.AttendanceInput == "A" {
            if self.IsFaceRecognitionRequired == true {
                self.FaceAttendance()
            } else {
                let options: [SemiModalOption: Any] = [
                    SemiModalOption.pushParentBack: false
                ]
                let storyboard = UIStoryboard(name: "Attendance", bundle: nil)
                let pvc = storyboard.instantiateViewController(withIdentifier: "MarkAttendanceVC") as! MarkAttendanceVC
                
                pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
                
                pvc.modalPresentationStyle = .overCurrentContext
                pvc.delegate = self
                
                presentSemiViewController(pvc, options: options, completion: {
                    print("Completed!")
                }, dismissBlock: {})
            }
        } else {
            showAlert(message: "You Are not Allowed to Mark Attendance")
        }
    }

    func FaceAttendance() {
        if IsUploaded == true {
        
            self.MarkFaceAttendance()
        } else {
            GoToFaceRegistration()
        }
    }

    func MarkFaceAttendance() {
        let storyboard = UIStoryboard(name: "Attendance", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FacseDedicationVC")as! FacseDedicationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func GoToFaceRegistration() {
                let alertController = UIAlertController(title: "Image Not Uploaded", message: "Do you want to upload an image?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                }
                alertController.addAction(cancelAction)
                let uploadAction = UIAlertAction(title: "Upload Image", style: .default) { _ in
                    let storyboard = UIStoryboard(name: "Attendance", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "UploadUserImageVC") as! UploadUserImageVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                alertController.addAction(uploadAction)
                present(alertController, animated: true, completion: nil)
   }
}




//====================================Get User location 1 time =============================================================



extension HomeVC:CLLocationManagerDelegate
{
    @objc func getLocation()
    {          print("Location Function Called ")
                let defaults = UserDefaults.standard
                let data = defaults.object(forKey: "IsLocationUpdate") as? Bool
                 if data == true
                {
                     if let lat  = UserDefaults.standard.object(forKey: "Lat") as? String, let Long = UserDefaults.standard.object(forKey: "Long") as? String
                     {
                         if lat == "a" && Long == "a"
                         {
                             print("Lat long is empty")
                             UserDefaults.standard.set("\(self.lat!)", forKey: "Lat")
                             UserDefaults.standard.set("\(self.long!)", forKey: "Long")
                             ApiCallingTrackLocation(lat: "\(self.lat!)", long: "\(self.long!)", Address: self.Address, AccuracyMeters: self.accurecy)
                          }
                         else
                         {
                                 print(lat,Long)
                             let Distance = GetDistance_btw_Cordinates(latitude1: self.lat!, longitude1: self.long!, latitude2: Double(lat)!, longitude2: Double(Long)!)
                             if  Distance > 10
                             {
                                 UserDefaults.standard.set("\(self.lat!)", forKey: "Lat")
                                 UserDefaults.standard.set("\(self.long!)", forKey: "Long")
                                 ApiCallingTrackLocation(lat: "\(self.lat!)", long: "\(self.long!)", Address: self.Address, AccuracyMeters: self.accurecy)
                             }
                             else
                             {
                                 print("Distance is \(Distance) which is less then 100 meters")
                             }
                         }
                     }
                     else
                     {
                         UserDefaults.standard.set("\(self.lat ?? 0)", forKey: "Lat")
                         UserDefaults.standard.set("\(self.long ?? 0)", forKey: "Long")
                         ApiCallingTrackLocation(lat: "\(self.lat!)", long: "\(self.long!)", Address: self.Address, AccuracyMeters: self.accurecy)
                     }
                   
                     


                   
                }
      

        

    }


    func GetDistance_btw_Cordinates(latitude1:Double,longitude1:Double,latitude2:Double,longitude2:Double) -> Double
    {   let location1 = CLLocation(latitude: latitude1, longitude: longitude1)
        let location2 = CLLocation(latitude: latitude2, longitude: longitude2)
        let distanceInMeters = location1.distance(from: location2)
        return distanceInMeters
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.lat = location.coordinate.latitude
            self.long = location.coordinate.longitude
            self.accurecy = String(format: "%f", location.horizontalAccuracy)
            // getting address from coordinate using reverseGeocode
            let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
                 
                   let geocoder = CLGeocoder()
                   geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarkArray, error) in
                       guard let placemarks = placemarkArray, let placemark = placemarks.first else {
                           return
                       }
                 
                       // creating complete address
                       var address = ""
//                       if let name = placemark.name {
//                           address += "\(name))"
//                       }
                       if let thoroughfare = placemark.thoroughfare {
                           address += "\(thoroughfare), "
                       }
                       if let subThoroughfare = placemark.subThoroughfare {
                           address += "\(subThoroughfare)"
                       }
                       if let locality = placemark.locality {
                           address += "\(locality)"
                       }
                       if let subLocality = placemark.subLocality {
                           address += ", \(subLocality)"
                       }
                       if let administrativeArea = placemark.administrativeArea {
                           address += ", \(administrativeArea)"
                       }
                       if let postalCode = placemark.postalCode {
                           address += ", \(postalCode)"
                       }
                       if let country = placemark.country {
                           address += ", \(country)"
                       }
                       self.Address = address
                     //  print(address)
                   })

            
            
            
            
            
            

        }
    }




    func ApiCallingTrackLocation(lat:String , long:String , Address:String,AccuracyMeters:String)
    {  var parameters:[String:Any]?
        
       if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
       

        { parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserId":UserID,"LocationArrList":[["LocationID":0,"Latitude":lat,"Longitude":long,"Timestamp":base.getCurrentTimestamp(),"AccuracyMeters":AccuracyMeters,"Address":Address] as [String : Any]] ]
          }
       

        Networkmanager2.postRequest(remainingUrl:"TrackedUserLocations", parameters: parameters!) { (response,data) in
            let json:JSON = response
            let status = json["Status"].intValue
            if status == 1
            {
                print(json)
                self.showAlert(message: "\(json)")
            }

        }
    }
    func timeDifference(fromTime: String, toTime: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let fromDate = dateFormatter.date(from: fromTime),
              let toDate = dateFormatter.date(from: toTime) else {
            return nil
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: fromDate, to: toDate)
        
        if let hour = components.hour, let minute = components.minute {
            return "\(hour):\(minute) Hrs."
        } else {
            return nil
        }
    }
}
