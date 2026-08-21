//
//  SuggestionVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 14/10/21.
//

import UIKit
import Photos
import SwiftyJSON
import Alamofire

class SuggestionVC: UIViewController, UITextViewDelegate {
    @IBOutlet weak var titel_sendwithidentity: Gradientbutton!
    @IBOutlet weak var titelbtn_sendasanonymous: Gradientbutton!
    @IBOutlet weak var lblImgName: UILabel!
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var tbl: UITableView!
    var ImageType =  ""
    
    var Getallsuccessionboxlist:JSON = []
    
    var imgString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.register(UINib(nibName: "SuggestionCell", bundle: nil), forCellReuseIdentifier: "SuggestionCell")
        tbl.separatorStyle = .none
    
        
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                self.Translate(index: 0)
            }
            else
            {
                self.Translate(index: 1)
            }
        }
        
        lblImgName.isHidden = true
        txtView.layer.borderWidth = 1.0
        txtView.text = "Enter Here..."
        txtView.textColor = UIColor.lightGray
        txtView.delegate = self
        tbl.isHidden = true
        // Do any additional setup after loading the view.
    }
    
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtView.textColor == UIColor.lightGray {
            txtView.text = nil
            txtView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtView.text.isEmpty {
            txtView.text = "Enter Here..."
            txtView.textColor = UIColor.lightGray
        }
    }
    func randomString(length: Int) -> String {
        let letters = "0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    @IBAction func attachedFileAction(_ sender: Any) {
        callImagePicker()
        
    }
    
    @IBAction func sendAnonymous(_ sender: Any) {
        
        if txtView.text == "Enter Here..."
        {
            self.showAlert(message: "Please enter your suggestion")
           
            
        }
        else {
            Suggestion_SendByAnonymousAPI()
            txtView.text = ""
            lblImgName.text = ""
        }
    }
    @IBAction func sendIdentity(_ sender: Any) {
        
        if txtView.text == "Enter Here..."
        {
            self.showAlert(message: "Please enter your suggestion")
            
        }
        else {
            Suggestion_SendWithIdentityAPI()
            txtView.text = ""
            lblImgName.text = ""
        }
    }
    
    func Suggestion_SendByAnonymousAPI()
    {
        
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"Suggestion":self.txtView.text ?? "","FileInBase64":imgString,"FileExt":self.ImageType, "FileName": self.lblImgName.text ?? ""]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","Notes":"Fufi"]
        }
        AF.request(base.url+"Suggestion_SendByAnonymous", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self) { response in
                print(response.request!)
                print(parameters!)
                switch response.result
                {
                case .success(let ankit):
                    let json:JSON = JSON(ankit)
                    print(json)
                    let status = json["Status"].intValue
                    if status == 1 {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let Message = json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            //self.APiCalling()
                            self.navigationController?.popViewController(animated: true)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            
                            self.present(alertController, animated: true)
                        }
                        
                    }else {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let Message = json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: true)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
                
            }
        
    }
    func Suggestion_SendWithIdentityAPI()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"Suggestion":self.txtView.text ?? "","FileInBase64":imgString,"FileExt":self.ImageType, "FileName": self.lblImgName.text ?? ""]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","Notes":"Fufi"]
        }
        AF.request(base.url+"Suggestion_SendWithIdentity", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: JSON.self) { response in
                print(response.request!)
                print(parameters!)
                switch response.result
                {
                case .success(let ankit):
                    let json:JSON = JSON(ankit)
                    print(json)
                    let status = json["Status"].intValue
                    if status == 1 {
                        
                        let Message = json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: true)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            
                            self.present(alertController, animated: true)
                        }
                        
                    }else {
                        
                        let Message = json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: true)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
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

extension SuggestionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let imagePicked = info[.editedImage] as? UIImage {
            let imageData: Data? = imagePicked.jpegData(compressionQuality: 0.4)

            imgString = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            self.ImageType = ".PNG"
        }

        if let url = info[.phAsset] as? URL {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
            if let firstAsset = assets.firstObject,
                let firstResource = PHAssetResource.assetResources(for: firstAsset).first {
                lblImgName.text = firstResource.originalFilename
            } else {
                lblImgName.text = "image_" + randomString(length: 8)
            }
        } else {
            lblImgName.text = "image_" + randomString(length: 8)
        }

        lblImgName.isHidden = false

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func callImagePicker() {

        let imagePicker = UIImagePickerController()

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let optionMenu = UIAlertController(title: nil, message: "Choose preferred source type", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { action in

            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        })
        optionMenu.addAction(camera)
        optionMenu.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)

        }))
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            optionMenu.dismiss(animated: true, completion: nil)
        }))

        if let popoverController = optionMenu.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(optionMenu, animated: true, completion: nil)
    }
}
    

extension SuggestionVC{
    func Translate(index:Int)
    {
        if index == 0
        {   self.title = "Suggestion"
            self.titelbtn_sendasanonymous.setTitle("sendasanonymous".localizableString(loc: "en"), for: .normal)
            self.titel_sendwithidentity.setTitle("sendwithidentity".localizableString(loc: "en"), for: .normal)
            //OtherDetails
        }
        else
        {
            self.title = "सुझाव"
            
            self.titelbtn_sendasanonymous.setTitle("sendasanonymous".localizableString(loc: "hi"), for: .normal)
            self.titel_sendwithidentity.setTitle("sendwithidentity".localizableString(loc: "hi"), for: .normal)
            
            
            
            
        }
        
    }
}


extension SuggestionVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Getallsuccessionboxlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)as! SuggestionCell
        cell.SuggestionBy.text = Getallsuccessionboxlist[indexPath.row]["SuggestionsBy"].stringValue
        cell.Date.text = Getallsuccessionboxlist[indexPath.row]["SendDate"].stringValue
        cell.Suggestion.text = Getallsuccessionboxlist[indexPath.row]["Suggestions"].stringValue
        cell.status.text = Getallsuccessionboxlist[indexPath.row]["Status"].stringValue
        cell.adminRemark.text = Getallsuccessionboxlist[indexPath.row]["AdminRemark"].stringValue
//        let attachmentURL = Getallsuccessionboxlist[indexPath.row]["Attachment"].stringValue
//        print("fgahdfbdhfbdhfbh>>>>>>/\(attachmentURL)")
//        if attachmentURL == "" {
//                cell.viewDoc.isHidden = true
//                print("123456>>>>>>/\(attachmentURL)")
//
//            } else {
//                cell.viewDoc.isHidden = false
//            }
        cell.viewDoc.addTarget(self, action: #selector(viewDoc(_:)), for: .touchUpInside)
        cell.viewDoc.tag = indexPath.row // Set a tag to identify the row
        //cell.viewDoc.accessibilityValue = url
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290
    }
    @objc func viewDoc(_ sender: UIButton) {
        let url = Getallsuccessionboxlist[sender.tag]["Attachment"].stringValue
        self.openURLInSafari(urlString: url)
    }

    func openURLInSafari(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}


extension SuggestionVC
{
    func APiCalling()
    {
        var parameters:[String:Any]?
        
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        parameters = ["UserId": UserID!,"TokenNo": "abcHkl7900@8Uyhkj",]
        
        Networkmanager.postRequest(vv: self.view, remainingUrl:"GetSuccessionbox", parameters: parameters!) { (response,data) in
            
            print(response)
            let status = response["Status"].intValue
          
            if status == 1
            {
                self.Getallsuccessionboxlist = response["Getallsuccessionboxlist"]
                self.tbl.isHidden = true
                self.tbl.reloadData()
            }
            else
            {
                self.tbl.isHidden = true
            }
        }
        
    }
}
