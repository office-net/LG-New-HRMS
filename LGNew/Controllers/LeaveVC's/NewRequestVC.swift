//
//  NewRequestVC.swift
//  NewOffNet
//
//  Created by Ankit Rana on 19/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SemiModalViewController
import Photos

class NewRequestVC: UIViewController {
    
    @IBOutlet weak var attachedfileLbl: UILabel!
    @IBOutlet weak var attachedFileView: UIView!
    @IBOutlet weak var tReason: UILabel!
    @IBOutlet weak var titleLeaveApplyFor: UILabel!
    @IBOutlet weak var tAddress: UILabel!
    @IBOutlet weak var title_LeaveBalance: UILabel!
    @IBOutlet weak var ReportingMaNAGER: UILabel!
    @IBOutlet weak var titleContactNoDuringLeave: UILabel!
    @IBOutlet weak var txt_YearBlance: UITextField!
    @IBOutlet weak var txt_LeaveType: UITextField!
    @IBOutlet weak var txt_startDate: UITextField!
    @IBOutlet weak var txt_EndDate: UITextField!
    @IBOutlet weak var txt_Resion: UITextView!
    @IBOutlet weak var txt_address: UITextView!
    @IBOutlet weak var txt_mobonumber: UITextField!
    @IBOutlet weak var txt_ReportingManager: UITextField!
    @IBOutlet weak var btnSecondHalf: UIButton!
    @IBOutlet weak var btnFirstHalf: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var txt_DeliveruDAte: UITextField!
    @IBOutlet weak var HieghtDelevry: NSLayoutConstraint!
    var validation = Validation()
    
    @IBOutlet weak var lblAppyLeaveFor: UILabel!
    @IBOutlet weak var Hieght_Tbl: NSLayoutConstraint!
    
    @IBOutlet weak var btn_AttachFile: UIButton!
    @IBOutlet weak var comOffTableView: UITableView!

    var Leavetype:JSON = []
    var blancetype:JSON = []
    var UsersCompOff:JSON = []
    var gradePicker: UIPickerView!
    var strLeaveTypeID = ""
    var strFirstHalf = "0"
    var strSecondHalf = "0"
    var MaximumFrequency = ""
    var SystemLeaveName = ""
    var FutureGracePeriod = ""
    var CertificateReqDayLmt = ""
    var leavetypeeee = ""
    var imgString = ""
    var AlertLeaveType = ""
    var AlertfromDate = ""
    var AlertTodate = ""
    var AlertReasion = ""
    var AlertAddress = ""
    var AlertNumber = ""
    var reverseYearData = [[String:Any]]()
    var YearID = ""
    var AttachButton_Is_Enable = false
    var IMG_String = ""
    var LeaveCompOffReq = [[String:Any]]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_DeliveruDAte.isHidden = true
        btn_AttachFile.isHidden = true
        HieghtDelevry.constant = 0
        UiSetup()
        txt_mobonumber.delegate = self
        txt_Resion.delegate = self
        txt_address.delegate = self
        comOffTableView.delegate = self
        comOffTableView.dataSource = self
        Hieght_Tbl.constant = 0
        comOffTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Calculate the new length after the user's input
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Set your character limit for the mobile number (e.g., 10 digits)
            let characterLimit = 10
            
            // Check if the new text length exceeds the character limit
            if newText.count <= characterLimit {
                return true // Allow the change
            } else {
                return false
            }
        }
    @IBAction func firstHalfAction(_ sender: Any)
    {
        Setup_firstHalf()
    }
    @IBAction func btn_Balance(_ sender: Any) {
        let options: [SemiModalOption : Any] = [
            SemiModalOption.pushParentBack: false
        ]
        let storyboard = UIStoryboard(name: "Leave", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "LeaveBalanceVC") as! LeaveBalanceVC
        pvc.year = self.YearID
        pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 440)
        pvc.modalPresentationStyle = .overCurrentContext
       
       presentSemiViewController(pvc, options: options, completion: {
            print("Completed!")
        }, dismissBlock: {
        })
    }
    @IBAction func secondHalfAction(_ sender: Any)
    {
        Setup_SecondHalf()
    }

    @IBAction func submitBtnAction(_ sender: Any) {
        self.validateFields()
        
        
    }
   
    
    @IBAction func attachedFileBtn(_ sender: Any) {
        callImagePicker()
        
    }
    func randomString(length: Int) -> String {
        let letters = "0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}

extension NewRequestVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            let imageData: Data? = imagePicked.jpegData(compressionQuality: 0.4)
            
            self.IMG_String = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            
        }
        
        if let url = info[UIImagePickerController.InfoKey.phAsset] as? URL {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
            if let firstAsset = assets.firstObject,
               let firstResource = PHAssetResource.assetResources(for: firstAsset).first {
                attachedfileLbl.text = firstResource.originalFilename
            } else {
                attachedfileLbl.text = "image_"+randomString(length: 8)+".png"
            }
        } else {
            attachedfileLbl.text = "image_"+randomString(length: 8)+".png"
            
        }
        
        attachedfileLbl.isHidden = false
        
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
        
      
        if let popoverController = optionMenu.popoverPresentationController {
          popoverController.sourceView = self.view
          popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
          popoverController.permittedArrowDirections = []
        }
        self.present(optionMenu, animated: true, completion: nil)
      }
    }
//========================================================API Calling==================================
extension NewRequestVC
{
    // Service Call
    func getblanveAPI()
    {     CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let PlantID = UserDefaults.standard.object(forKey: "PlantID") as? String
        let Mobileno = UserDefaults.standard.object(forKey: "MobileNo") as? String
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID!,"PlantID":PlantID!,"Year": Date.getCurrentYear()]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"Leave_GetBalance", parameters: parameters!) { (response,data) in
            let status =  response["Status"].intValue
            print(response)
            if status == 1
            {
            CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
            self.Leavetype = response["objLeaveType"]
            self.blancetype = response["objLeaveBalanceType"]
            self.txt_ReportingManager.text = response["RMName"].stringValue
            self.txt_mobonumber.text = Mobileno ?? ""
                for i in 0...response["objLeaveCalFinYear"].count - 1
                {
                    let dic = ["Year":response["objLeaveCalFinYear"][i]["Year"].stringValue,"YearName":response["objLeaveCalFinYear"][i]["YearName"].stringValue]
                    self.reverseYearData.append(dic)
                }
                
                self.reverseYearData.reverse()
                
                self.txt_YearBlance.text =  self.reverseYearData[0]["YearName"] as? String
                self.YearID =  (self.reverseYearData[0]["Year"] as? String)!
                
            }
            else
            
            {
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                let msg =  response["Message"].stringValue
                self.showAlert(message: msg)
            }
        }

    }
    func Leave_GetDataOnLeaveTypeChangeApi ()
    {
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let  parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID!,"LeaveTypeID":strLeaveTypeID,"LeaveTypeText":self.txt_LeaveType.text ?? "","FYear":YearID, "BalYear": self.YearID] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"Leave_GetDataOnLeaveTypeChange", parameters: parameters) { (response,data) in
            print(response)
            let status = response["Status"].intValue
            if status == 1 {
                self.MaximumFrequency = response["MaximumFrequency"].stringValue
                self.SystemLeaveName = response["SystemLeaveName"].stringValue
                self.CertificateReqDayLmt = response["CertificateReqDayLmt"].stringValue
                self.FutureGracePeriod = response["FutureGracePeriod"].stringValue
                if self.txt_startDate.text != "" && self.txt_EndDate.text != "" && self.txt_LeaveType.text != "" {
                    self.Leave_CalculateDaysApi() }
                
                if self.txt_LeaveType.text == "Comp Off"
                {
                    self.UsersCompOff = response["UsersCompOff"]
                    self.comOffTableView.reloadData()
                }
                else
                {
                    self.Hieght_Tbl.constant = 0
                }
                
            }
            else {
                
                let Message = response["Message"].stringValue
                self.showAlertWithAction(message: Message)
            } } }

    
    func Leave_CalculateDaysApi()  {
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID!,"LeaveTypeID":strLeaveTypeID,"LeaveTypeText":self.txt_LeaveType.text ?? "","MaximumFrequency":MaximumFrequency,"SystemLeaveName":SystemLeaveName,"FutureGracePeriod":FutureGracePeriod,"CertificateReqDayLmt":CertificateReqDayLmt,"SecondHalfLeave":strSecondHalf,"FirstHalfLeave":strFirstHalf,"FromDate":self.txt_startDate.text ?? "","ToDate":self.txt_EndDate.text ?? "","FYear":YearID] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"Leave_CalculateDays", parameters: parameters) { (response,data) in
            print(response)
            let status = response["Status"].intValue
            if status == 1 {
                let noOfDays = response["NoOfDays"].floatValue
                self.lblAppyLeaveFor.text = "\(noOfDays )"
                self.btn_submit.isUserInteractionEnabled = true
                if  response["IsUploadDocumentVisable"].boolValue == true {
                    self.btn_AttachFile.isHidden = false
                    self.AttachButton_Is_Enable = true
                }
                else {
                    self.btn_AttachFile.isHidden = true
                    self.AttachButton_Is_Enable = false
                    self.attachedfileLbl.text = ""
                }
            }
            else {
                let Message = response["Message"].stringValue
                let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.txt_startDate.text = ""
                    self.txt_EndDate.text = ""
                    self.btn_submit.isUserInteractionEnabled = false
                    self.strFirstHalf = "0"
                    self.btnFirstHalf.isSelected = false
                    self.strSecondHalf = "0"
                    self.btnSecondHalf.isSelected = false
                    let noOfDays = response["NoOfDays"].floatValue
                    self.lblAppyLeaveFor.text = "\(noOfDays )"
                    self.btn_AttachFile.isHidden = true
                    self.AttachButton_Is_Enable = false
                    self.attachedfileLbl.text = ""
                }
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                } } }
    }
    
    func subbmitAPI ()
    {
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID!,"LeaveTypeID":strLeaveTypeID,"LeaveTypeText":self.txt_LeaveType.text!,"SecondHalfStatus":self.strSecondHalf,"FirstHalfStatus":strFirstHalf,"FromDate":self.txt_startDate.text!,"ToDate":self.txt_EndDate.text!,"NoOfDays":self.lblAppyLeaveFor.text!,"Reason":self.txt_Resion.text!,"Address":self.txt_address.text!,"ContactNo":self.txt_mobonumber.text!,"SystemLeaveType":self.SystemLeaveName,"BalanceYearType":YearID,"DeliveryDate":txt_DeliveruDAte.text ?? "","LeaveCompOffReq":LeaveCompOffReq,"FileInBase64":self.IMG_String,"FileExt":"","Remarks":""] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"leaveSubmitRequest", parameters: parameters) { (response,data) in
            print(response)
            let status = response["Status"].intValue
            let Message = response["Message"].stringValue
            if status == 1
            { self.showAlertWithAction(message: Message)
            }
            else
            { self.showAlertWithAction(message: Message)}
        }
    }


    

}

//==========================================================PickerView==========================================================

extension NewRequestVC:UIPickerViewDelegate, UIPickerViewDataSource ,UITextFieldDelegate,UITextViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if txt_LeaveType.isFirstResponder
        {
        return Leavetype.arrayValue.count
    }
    else
        {
            return reverseYearData.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if txt_LeaveType.isFirstResponder
        {
             if Leavetype.arrayValue.count > 0{
                return Leavetype[row]["LeaveTypeText"].stringValue
                
             }
        return ""
        }
        else
        {
            return reverseYearData[row]["YearName"] as? String
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if txt_LeaveType.isFirstResponder
        {
            
            if Leavetype.arrayValue.count > 0{
                
                txt_LeaveType.text = Leavetype[row]["LeaveTypeText"].stringValue
                strLeaveTypeID = Leavetype[row]["LeaveTypeID"].stringValue
                leavetypeeee = self.Leavetype[row]["LeaveType"].stringValue
                if txt_LeaveType.text == "Maternity Leave"
                {
                    txt_DeliveruDAte.isHidden = false
                    HieghtDelevry.constant = 45
                }
                else
                {
                    txt_DeliveruDAte.isHidden = true
                    HieghtDelevry.constant = 0
                }
                
            
            }
            if txt_LeaveType.text == "Sick Leave"
            {
//                btn_AttachFile.isHidden = false
//                AttachButton_Is_Enable = true
            }
            else
            {
                btn_AttachFile.isHidden = true
                AttachButton_Is_Enable = false
            }
           
        }
        else
        {
            txt_YearBlance.text = reverseYearData[row]["YearName"] as? String
            YearID = reverseYearData[row]["Year"] as? String ?? ""
        }
        
    }
}







//==========================================================UI SETUP==========================================================





extension NewRequestVC
{
    func UiSetup()
    {
        Languagchange()
       
        btn_submit.layer.cornerRadius = 10
 
        self.txt_LeaveType.layer.borderWidth = 0.5
        self.txt_LeaveType.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.txt_LeaveType.layer.cornerRadius = 5
        
        self.txt_startDate.layer.borderWidth = 0.5
        self.txt_startDate.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.txt_startDate.layer.cornerRadius = 5
        
        self.txt_EndDate.layer.borderWidth = 0.5
        self.txt_EndDate.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.txt_EndDate.layer.cornerRadius = 5
        
        self.txt_Resion.layer.borderWidth = 0.5
        self.txt_Resion.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.txt_Resion.layer.cornerRadius = 5
        
        self.txt_address.layer.borderWidth = 0.5
        self.txt_address.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.txt_address.layer.cornerRadius = 5
        
        self.txt_mobonumber.layer.borderWidth = 0.5
        self.txt_mobonumber.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.txt_mobonumber.layer.cornerRadius = 5
        
        self.txt_ReportingManager.layer.borderWidth = 0.5
        self.txt_ReportingManager.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.txt_ReportingManager.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        
        
        
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        txt_LeaveType.delegate = self
        txt_LeaveType.inputView = gradePicker
        txt_YearBlance.inputView = gradePicker
        txt_YearBlance.delegate = self
        self.txt_startDate.delegate = self
        self.txt_EndDate.delegate = self
        self.txt_startDate.setInputViewDatePicker(target: self, selector: #selector(tapStrtDate))
        self.txt_EndDate.setInputViewDatePicker(target: self, selector: #selector(tapEndDate))
        self.txt_Resion.delegate = self
        self.txt_address.delegate = self
        
        if let myImage = UIImage(named: "calendar")
        {

            txt_startDate.withImage(direction: .Left, image: myImage, colorBorder: UIColor.clear)
            txt_EndDate.withImage(direction: .Left, image: myImage,  colorBorder: UIColor.clear)
            txt_DeliveruDAte.withImage(direction: .Left, image: myImage,  colorBorder: UIColor.clear)
        }
        applyPlaceholderStyle(aTextview: txt_Resion!, placeholderText: "Reason of Leave")
        applyPlaceholderStyle(aTextview: txt_address!, placeholderText: "Address during Leave (Optional)")
        
        txt_DeliveruDAte.delegate = self
        txt_DeliveruDAte.setInputViewDatePicker(target: self, selector: #selector(DeleveryDateee))
        
        // Call Api
        
        getblanveAPI()
        
        
    }

    //==========================================================Date Function==========================================================
    @objc func tapEndDate() {
        if let datePicker = self.txt_EndDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2

            dateformatter.dateFormat = "dd/MM/yyyy"

            self.txt_EndDate.text = dateformatter.string(from: datePicker.date)//2-4
      
          
    
        }
        self.txt_EndDate.resignFirstResponder() // 2-5
        self.Leave_CalculateDaysApi()
    }


    
    

    

    

    @objc func tapStrtDate() {
        if let datePicker = self.txt_startDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.txt_startDate.text = dateformatter.string(from: datePicker.date) //2-4
            //checkDateRange()
          
        }
        self.txt_startDate.resignFirstResponder()
        
        // 2-5
    }
    
    
    @objc func DeleveryDateee() {
        if let datePicker = self.txt_DeliveruDAte.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.txt_DeliveruDAte.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txt_DeliveruDAte.resignFirstResponder()
        
        // 2-5
    }
    
    
    
    func Setup_firstHalf()
    {
       // strFirstHalf = "1"
        
        if (self.txt_startDate.text == "") {
            
            self.showAlert(message: self.AlertfromDate)
            return
        }
        
       else if (self.txt_EndDate.text == "") {
            
           self.showAlert(message: self.AlertTodate)
            return
        }
        
       else if (self.txt_LeaveType.text == "") {
           self.showAlert(message: self.AlertLeaveType)
            return
        }
        
        else if btnFirstHalf.isSelected == true
        {     strFirstHalf = "0"
            btnFirstHalf.isSelected = false
            self.Leave_CalculateDaysApi()
        }
        
        else {

            btnFirstHalf.isSelected = true
            strFirstHalf = "1"
            self.Leave_CalculateDaysApi()
        }
        
    }
    
    func Setup_SecondHalf()
    {
       // strSecondHalf = "1"
        if (self.txt_startDate.text == "") {
            
            self.showAlert(message: self.AlertfromDate)
            return
        }
        
       else if (self.txt_EndDate.text == "") {
            
           self.showAlert(message: self.AlertTodate)
            return
        }
        
        else if (self.txt_LeaveType.text == "") {
            self.showAlert(message: self.AlertLeaveType)
            return
        }
        
        else if btnSecondHalf.isSelected == true
        {     strSecondHalf = "0"
            btnSecondHalf.isSelected = false
            self.Leave_CalculateDaysApi()
        }
        
        else {

            btnSecondHalf.isSelected = true
            strSecondHalf = "1"
            self.Leave_CalculateDaysApi()
        }
    }
    
    func validateFields()  {
        
        if (self.txt_LeaveType.text == "" ) {
            self.showAlert(message: self.AlertLeaveType)
            return
        }
        if (self.txt_startDate.text == "") {
            self.showAlert(message: self.AlertfromDate)
            return
        }
        
        if (self.txt_EndDate.text == "") {
            
            self.showAlert(message: self.AlertTodate)
            return
        }
        
        if (self.txt_Resion.text == "Reason of Leave") {
            
            self.showAlert(message: self.AlertReasion)
            return
        }
                
        if self.AttachButton_Is_Enable == true && self.IMG_String == ""
        {
            self.showAlert(message: "Please Select Medical Certificate")
            return
        }
        
        let isValidateMobileNumber = Validation.validaPhoneNumber(phoneNumber: self.txt_mobonumber.text!)
        if (isValidateMobileNumber == false) {
            self.showAlert(message: self.AlertNumber)
            return
        }
        
        if txt_LeaveType.text == "Comp Off" {
            var compOffSelected = false

            for i in 0..<UsersCompOff.count {
                let index = IndexPath(row: i, section: 0)
                if let cell = self.comOffTableView.cellForRow(at: index) as? TableViewCell {
                    if cell.selectBtn.isSelected {
                        compOffSelected = true
                        break // Exit the loop if a Comp Off is selected
                    }
                }
            }

            if !compOffSelected {
                self.showAlert(message: "Please Select a Comp Off")
            }
            else
            {
                self.subbmitAPI()
            }
        }
        else
        {
            self.subbmitAPI()
        }
    }

    
    
}
    




//=========================================================TextField & TextView ============================
extension NewRequestVC
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txt_LeaveType{
         if txt_LeaveType.text == "" {
         if Leavetype.arrayValue.count > 0 {
                   txt_LeaveType.text =  Leavetype[0]["LeaveTypeText"].stringValue
                    strLeaveTypeID = Leavetype[0]["LeaveTypeID"].stringValue
             } }
            Leave_GetDataOnLeaveTypeChangeApi()
           
         
        }
        
        if textField == txt_startDate {
          if txt_startDate.text != "" && txt_EndDate.text != "" && txt_LeaveType.text != "" {
                Leave_CalculateDaysApi()
            } }
        
        if textField == txt_startDate {
            if txt_startDate.text != "" && txt_EndDate.text != "" && txt_LeaveType.text != "" {
             Leave_CalculateDaysApi()
             } }
        if txt_LeaveType.text == "Paternity Leave" || txt_LeaveType.text == "Maternity Leave" {
            self.btn_AttachFile.isHidden = false
            self.AttachButton_Is_Enable = true
            self.btnFirstHalf.isHidden = true
            self.btnSecondHalf.isHidden = true
        }else{
            self.btn_AttachFile.isHidden = true
            self.AttachButton_Is_Enable = false
            self.attachedfileLbl.text = ""
            self.btnFirstHalf.isHidden = false
            self.btnSecondHalf.isHidden = false
        }
        
        
         }
    
    // textView
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
    {
        aTextview.textColor = UIColor.lightGray
        aTextview.text = placeholderText
    }
    
    func applyNonPlaceholderStyle(aTextview: UITextView)
    {
        // make it look like normal text instead of a placeholder
        aTextview.textColor = UIColor.darkText
        aTextview.alpha = 1.0
    }
    

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let newLength = textView.text.utf16.count + text.utf16.count - range.length

            // Check if the text view contains the placeholder text and the user starts typing.
            if newLength > 0 && textView.text == "Reason of Leave" {
                applyNonPlaceholderStyle(aTextview: textView)
                textView.text = ""
            }
            
            if newLength > 0 && textView.text == "Address during Leave (Optional)" {
                applyNonPlaceholderStyle(aTextview: textView)
                textView.text = ""
            }
            
            // Check if the user hits the back button and the text view is empty.
            if newLength == 0 {
                if textView == txt_address {
                    applyPlaceholderStyle(aTextview: textView, placeholderText: "Address during Leave (Optional)")
                } else {
                    applyPlaceholderStyle(aTextview: textView, placeholderText: "Reason of Leave")
                }
                moveCursorToStart(aTextView: textView)
                return false
            }
            
            // Check if the new length exceeds the character limit (e.g., 30 characters).
            let characterLimit = 80
            if newLength > characterLimit {
                return false
            }
            
            return true
        }

    
    func textViewShouldBeginEditing(aTextView: UITextView) -> Bool
    {
        if aTextView == txt_Resion && aTextView.text == "Reason of Leave"
        {
            // move cursor to start
            moveCursorToStart(aTextView: aTextView)
        }
        
        if aTextView == txt_address && aTextView.text == "Address during Leave (Optional)"
        {
            // move cursor to start
            moveCursorToStart(aTextView: aTextView)
        }
        return true
    }
    
    func moveCursorToStart(aTextView: UITextView)
    {
        
        DispatchQueue.main.async {
            aTextView.selectedRange = NSMakeRange(0, 0);
        }
    }
}








//==========================================================Language Change==========================================================


extension NewRequestVC
{
    func Languagchange()
    {
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                self.title = "New Request"
                self.title_LeaveBalance.text = "Leave Balance Details"
                self.txt_LeaveType.placeholder = " Select Leave Type"
                self.txt_startDate.placeholder = "Start Date"
                self.txt_EndDate.placeholder = "End Date"
                self.btnFirstHalf.setTitle("Firts Half", for: .normal)
                self.btnSecondHalf.setTitle("Second Half", for: .normal)
                self.titleLeaveApplyFor.text = "Applying Leave For"
                self.btnSecondHalf.setTitle("Second Half", for: .normal)
                self.btnFirstHalf.setTitle("First Half", for: .normal)
                self.tReason.text = "Reason Of Leave"
                self.tAddress.text = "Address During Leave (Optional)"
                self.titleContactNoDuringLeave.text = "Contact No. During Leave"
                self.ReportingMaNAGER.text = "Reporting Manager"
                self.btn_submit.setTitle("SUBMIT", for: .normal)
                self.AlertLeaveType = "Please Select Leave Type"
                self.AlertfromDate = "Please Select From Date"
                self.AlertTodate = "Please Select End Date"
                self.AlertReasion = "Please Enter Reason Of Leave"
                self.AlertAddress = "Please Enter Address During Leave"
                self.AlertNumber = "Please Enter Correct Mobile Number"
            }
            else
            {
                
                self.title = "छुट्टी के लिए अनुरोध करे"
                self.title_LeaveBalance.text = "अवकाश शेष विवरण"
                self.txt_LeaveType.placeholder = "छुट्टी का प्रकार चुनें"
                self.txt_startDate.placeholder = "प्रारंभ दिनांक"
                self.txt_EndDate.placeholder = "अंतिम दिनांक"
                self.btnFirstHalf.setTitle("पहला आधा दिन", for: .normal)
                self.btnSecondHalf.setTitle("दूसरा आधा दिन", for: .normal)
                self.titleLeaveApplyFor.text = " छुट्टी के लिए आवेदन दिन"
                self.btnSecondHalf.setTitle("द्वितीय सत्र", for: .normal)
                self.btnFirstHalf.setTitle("प्रथम सत्र", for: .normal)
                self.tReason.text = "छुट्टी का कारण"
                self.tAddress.text = "छुट्टी के दौरान पता"
                self.titleContactNoDuringLeave.text = "छुट्टी के दौरान संपर्क नंबर"
                self.ReportingMaNAGER.text = "रिपोर्टिंग प्रबंधक"
                self.btn_submit.setTitle("छुट्टी फॉर्म जमा करें", for: .normal)
                self.txt_mobonumber.text = "नंबर डालें"
                self.AlertLeaveType = "कृपया छुट्टी का प्रकार चुनें"
                self.AlertfromDate = "कृपया प्रारंभ दिनांक चुनें"
                self.AlertTodate = "कृपया अंतिम दिनांक चुनें"
                self.AlertReasion =  "कृपया छुट्टी का कारण दर्ज करें"
                self.AlertAddress = "कृपया छुट्टी के दौरान पता दर्ज करें"
                self.AlertNumber = "कृपया सही मोबाइल नंबर दर्ज करें"

            }
        }

    }
}

extension NewRequestVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UsersCompOff.count == 0
        {
            self.Hieght_Tbl.constant = CGFloat(UsersCompOff.count * 40)
        }
        else
        {
            self.Hieght_Tbl.constant = CGFloat((UsersCompOff.count * 40) + 60)
        }
        print("nbvdksbvbsfvbdskbvkdjsbvkbfskvbdsfkxvbskbvkfsdbfvkdfbfvkbskfbdkfb\(CGFloat((UsersCompOff.count * 20) + 50))")
        return self.UsersCompOff.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vc  = comOffTableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        let index = indexPath.row
        vc.lblComOffDate.text = UsersCompOff[index]["CompOffDate"].stringValue
        vc.lblRequestDate.text = UsersCompOff[index]["ReqDate"].stringValue
        vc.lblDaysEared.text = UsersCompOff[index]["NoOfDays"].stringValue
        vc.lblDaysApplied.text = UsersCompOff[index]["AvailedDays"].stringValue
        vc.lblBalanceDays.text = UsersCompOff[index]["Balance"].stringValue
        vc.selectBtn.tag = index
        vc.selectBtn.addTarget(self, action: #selector(btnTaped), for: .touchUpInside)
        return vc
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    @objc func btnTaped(_sender:UIButton)
    {
        if _sender.isSelected == false
        {
            _sender.isSelected = true
            let dic =  [  "NoOfDays" : UsersCompOff[_sender.tag]["NoOfDays"].stringValue,
                          "Balance" : UsersCompOff[_sender.tag]["Balance"].stringValue,
                          "CompOffDate" : UsersCompOff[_sender.tag]["CompOffDate"].stringValue,
                          "AvailedDays" : UsersCompOff[_sender.tag]["AvailedDays"].stringValue,
                          "ReqDate" : UsersCompOff[_sender.tag]["ReqDate"].stringValue,
                          "CompOffID" : UsersCompOff[_sender.tag]["CompOffID"].stringValue,
                          "isChecked":true
            ] as [String : Any]
            self.LeaveCompOffReq.append(dic)
             
        }
        else
        {
            _sender.isSelected = false
            
            for i in 0...self.LeaveCompOffReq.count
            {
               let Id =  self.LeaveCompOffReq[i]["CompOffID"] as! String
                if Id == UsersCompOff[_sender.tag]["CompOffID"].stringValue
                {
                    self.LeaveCompOffReq.remove(at: i)
                    break
                }
            }
        }
        
        print(self.LeaveCompOffReq)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the cell immediately to prevent the default selection color from showing.
        comOffTableView.deselectRow(at: indexPath, animated: true)
        // Access the selected cell and set its selectedBackgroundView to a clear view.
        if let cell = comOffTableView.cellForRow(at: indexPath) {
            cell.selectedBackgroundView = UIView()
            cell.selectedBackgroundView?.backgroundColor = UIColor.clear
        }
        
    }
}
