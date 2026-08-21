//
//  BirthdayWishVC.swift
//  NewOffNet
//
//  Created by Ankit Rana on 04/01/22.
//

import UIKit
import Foundation
import SemiModalViewController
import Alamofire
import SwiftyJSON
class BirthdayWishVC: UIViewController,UITextViewDelegate {
    var imgString = ""
    @IBOutlet weak var btn_Post: UIButton!
    @IBOutlet weak var img_Profile: UIImageView!
    var imgpath = ""
    @IBOutlet weak var view_Select: UIView!
    @IBOutlet weak var txt_Text: UITextView!
    var txtname = ""
    @IBOutlet weak var img_Selected: UIImageView!
    @IBOutlet weak var btn_SelectPhoto: UIButton!
    
    @IBOutlet weak var title_PhotoGreating: UILabel!
    var empcode = ""
    var strWishType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
             
                self.txt_Text.text = "Write Something On " + txtname + " Timeline..."
                self.btn_Post.setTitle(" Post ", for: .normal)
                self.title_PhotoGreating.text = "Photo/Greeting (Optional)"
                self.btn_SelectPhoto.setTitle("Select Greeting/Photos", for: .normal)
                //"अंकित कुमार की टाइमलाइन पर कुछ लिखें"
            }
            else
            {
             
                self.txt_Text.text = txtname + " की टाइमलाइन पर कुछ लिखें..."
                self.btn_Post.setTitle(" भेजें ", for: .normal)
                self.title_PhotoGreating.text = "फोटो/ग्रीटिंग (वैकल्पिक)"
                self.btn_SelectPhoto.setTitle("ग्रीटिंग/तस्वीरें चुनें", for: .normal)
            }
        }
        
       
        txt_Text.textColor = UIColor.darkGray
        self.txt_Text.delegate = self
        self.img_Profile?.sd_setImage(with: URL(string:imgpath), placeholderImage: UIImage())
        txt_Text.layer.borderWidth = 1
        txt_Text.layer.borderColor = UIColor.darkGray.cgColor
        
        view_Select.layer.borderWidth = 1
        view_Select.layer.borderColor = UIColor.darkGray.cgColor

        img_Profile.layer.borderWidth = 1
        img_Profile.layer.borderColor = UIColor.darkGray.cgColor
        img_Profile.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txt_Text.textColor == UIColor.darkGray {
            txt_Text.text = nil
            txt_Text.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                if txt_Text.text.isEmpty {
                    txt_Text.text = "Write Something On " + txtname + " Timeline..."
                    txt_Text.textColor = UIColor.darkGray
                }
            }
            else
            {
                if txt_Text.text.isEmpty {
                    txt_Text.text = txtname + " की टाइमलाइन पर कुछ लिखें..."
                    txt_Text.textColor = UIColor.darkGray
                }
            }
            
        }
    }

    @IBAction func btnSelect(_ sender: Any) {
        callImagePicker()
    }
    
    @IBAction func btnPost(_ sender: Any) {
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                if txt_Text.text == "Write Something On " + txtname + " Timeline..."
                {
                    self.showAlert(message: "Enter Something for " + txtname)
                }
                else if txt_Text.text == ""
                {
                    self.showAlert(message: "Enter Something for " + txtname)
                }
                else
                {
                  serviceCall()
                }
            }
            else
            {
                if txt_Text.text == txtname + " की टाइमलाइन पर कुछ लिखें..."
                {
                    self.showAlert(message: txtname + " की टाइमलाइन पर कुछ लिखें...")
                }
                else if txt_Text.text == ""
                {
                    self.showAlert(message:  txtname + "के लिए कुछ दर्ज करें")
                }
                else
                {
                  serviceCall()
                }
            }
        }
     
        
    }
    
    
    @IBAction func btn_Dismis(_ sender: Any) {
        self.dismissSemiModalView()
    }
    func serviceCall()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"EmpCode":self.empcode,"EncodedBase64Url":self.imgString,"WishMessage":self.txt_Text.text!,"Extension":".png","WishType":self.strWishType]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        
        AF.request(base.url+"EmpWishesDetails", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self)  { response in
                switch response.result
                { case .success(let Value):
                    let json:JSON = JSON(Value)
                    print(json)
                    print(parameters!)
                    print(response.request!)
                    let status = json["Status"].intValue
                    if status == 1
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let Message = json["Message"].stringValue
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
                            UIAlertAction in
                   
                            self.dismissSemiModalView()
                        }
                       alertController.addAction(okAction)
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true)
                        }
                        
                    }
                    else
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let Message = json["Message"].stringValue
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.dismissSemiModalView()
                        }
                        alertController.addAction(okAction)
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true)
                        }
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
    }

    
}


extension BirthdayWishVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let imagePicked = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
        let imageData: Data? = imagePicked.jpegData(compressionQuality: 0.4)
    
     self.img_Selected.image = imagePicked
        imgString = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        
        
       

    }
   
    dismiss(animated: true, completion: nil)
}

func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
}
    
    func callImagePicker() {
        
        
        
        let imagePicker=UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let optionMenu = UIAlertController(title : nil , message: "Choose preferred source type", preferredStyle: UIAlertController.Style.actionSheet)
        let camera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { action in
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        })
        optionMenu.addAction(camera)
        optionMenu.addAction(UIAlertAction(title: "Photo Library", style: UIAlertAction.Style.default, handler: { action in
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        }))
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            action in
            optionMenu.dismiss(animated: true, completion: nil)}))
        self.present(optionMenu, animated: true, completion: nil)
    }


}
