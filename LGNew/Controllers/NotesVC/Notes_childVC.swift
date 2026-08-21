//
//  Notes_childVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 07/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SemiModalViewController
protocol SecondViewControllerDelegate: AnyObject {
    func didPopFromSecondViewController()
}
class Notes_childVC: UIViewController {
    
    
    @IBOutlet weak var txt_description: UITextField!
    @IBOutlet weak var addNoteLbl: UILabel!
    weak var delegate: SecondViewControllerDelegate?
    
    
    @IBOutlet weak var btn_save: UIButton!
    var json:JSON  = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.txt_description.layer.borderWidth = 1
        self.txt_description.layer.borderColor = #colorLiteral(red: 0, green: 0.6775407791, blue: 0.2961367369, alpha: 1)
        
        
        // text field placeholder color chnager
        
        let color = UIColor.orange
        
        
        let placeholder2 = txt_description.placeholder ?? "" //There should be a placeholder set in storyboard or elsewhere string or pass empty
        txt_description.attributedPlaceholder = NSAttributedString(string: placeholder2, attributes: [NSAttributedString.Key.foregroundColor : color])
        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.dismissSemiModalView()
            self.delegate?.didPopFromSecondViewController()
        }
        
        
        
        
    }
    func AddNoteAPI()
    {        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        
        var parameters:[String:Any]?
        
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"Notes":self.txt_description.text ?? ""]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","Notes":"Fufi"]
        }
        
        AF.request( base.url+"MyPage_DailyNotesSubmit", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self)  { response in
                print(response.request!)
                print(parameters!)
               
                switch response.result
                {
                   
                case .success(let value):
                    
                    self.json =  JSON(value)
                    print(self.json)
                    let status = self.json["Status"].intValue
                    if status == 1 {
                        
                        let Message = self.json["Message"].stringValue
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.dismissSemiModalView()
                            self.delegate?.didPopFromSecondViewController()
                            
                            
                        }
                        alertController.addAction(okAction)
                        DispatchQueue.main.async {
                            
                            self.present(alertController, animated: true)
                        }
                        
                    }else {
                        
                        let Message = self.json["Message"].stringValue
                        self.showAlertWithAction(message: Message)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
            }
       
        
        
        
        
    }
   
    
    @IBAction func btn_save(_ sender: Any) {
        if txt_description.text == "" {
            self.showAlert(message: "Please Enter Note")
        } else {
            AddNoteAPI()
            //self.delegate?.didPopFromSecondViewController()
        }
    }



}
