
//  Update_Check.swift
//  VishalMegaMartls
//  Created by Ankit Rana on 18/01/24.

import Foundation
import UIKit
import StoreKit
extension UIViewController
{
    
    
    func checkForUpdates(appID:String,url_Name:String) {
        getAppStoreVersion(appID: appID) { appStoreVersion in
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
           if let storeVeriosn = appStoreVersion
            {
               if storeVeriosn == appVersion
               {
                  print("storeVeriosn\(storeVeriosn)===================d=d=d=d=d=appVersion\(appVersion ?? "")")
               }
               else
               {
                   print("storeVeriosn\(storeVeriosn)===================d=d=d=d=d=appVersion\(appVersion ?? "")")
                   self.ShowMessage_For_update(url_Namr_With_ID: url_Name + "/" + appID)
               }
           }
        }
     }
    
    func ShowMessage_For_update(url_Namr_With_ID:String)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Update Available",
                message: "A new version of the app is available. Please update for the latest features and improvements.",
                preferredStyle: .alert
            )

            let updateAction = UIAlertAction(title: "Update", style: .default) { _ in
                // Open App Store for the update
                if let url = URL(string: "itms-apps://itunes.apple.com/app/" + url_Namr_With_ID) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            alert.addAction(updateAction)
            alert.addAction(cancelAction)

            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func getAppStoreVersion(appID: String, completion: @escaping (String?) -> Void) {
        
        let iTunesLookupURLString = "https://itunes.apple.com/lookup?id=\(appID)"
        if let iTunesLookupURL = URL(string: iTunesLookupURLString) {
            let task = URLSession.shared.dataTask(with: iTunesLookupURL) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                } else if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                        if let results = json?["results"] as? [[String: Any]], let appStoreVersion = results.first?["version"] as? String {
                            completion(appStoreVersion)
                        } else {
                            completion(nil)
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
            }

            task.resume()
        } else {
            completion(nil)
        }
    }
}
