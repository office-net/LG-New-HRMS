//
//  UploadUserImageVC.swift
//  IOS
//
//  Created by Netcommlabs on 17/11/22.
//

import UIKit
import FaceSDK
import SwiftyJSON

class UploadUserImageVC: UIViewController {
    var imgString = ""
    
    @IBOutlet weak var Profile_img:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register User Image"
        createImageForPosition() { [weak self] (image) in
            self?.Profile_img.image = image?.image
            let image : UIImage = (self?.Profile_img.image!)!
            //Now use image to create into NSData format
            //let imageData:NSData = image.pngData()! as NSData
            let imageData: Data? = image.jpegData(compressionQuality: 0.4)
            self?.imgString = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func UploadImage(_ sender: Any) {
        
        MyPage_UpdateProfilePicAPI()
    }
    
    @IBAction func btn(_ sender: Any) {
        
        createImageForPosition() { [weak self] (image) in
            self?.Profile_img.image = image?.image
            let image : UIImage = (self?.Profile_img.image!)!
            //Now use image to create into NSData format
            let imageData: Data? = image.jpegData(compressionQuality: 0.4)
            self?.imgString = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        }
    }
    private func createImageForPosition(_ completion: @escaping (MatchFacesImage?) -> Void) {
        
        FaceSDK.service.presentFaceCaptureViewController(
            from: self,
            animated: true,
            onCapture: { response in
                let image = response.image.map {
                    MatchFacesImage(
                        rfsImage: $0
                    )
                }
                completion(image)
            },
            completion: nil
        )
        
        
    }
    
}




extension UploadUserImageVC
{
    func MyPage_UpdateProfilePicAPI()  {
        let EmpCode = UserDefaults.standard.object(forKey: "EmpCode") as? String
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserId":UserID,"ImageBase64":imgString, "FileExt":".png","EmpCode":EmpCode ?? ""]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","Notes":"Fufi"]
        }
        Networkmanager.postRequest(vv: self.view, remainingUrl:"FRRegistration", parameters: parameters!) { (response,data) in
            print(response)
            let status = response["Status"].intValue
            if status == 1
            {
                let Message = response["Message"].stringValue
                self.showAlertWithAction(message:Message )
            }
            
            else {
                
                let Message = response["Message"].stringValue
                self.showAlert(message: Message)}}
        
    }
}
