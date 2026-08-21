//
//  NotesVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 06/10/21.
//

import UIKit
import SemiModalViewController
import Alamofire
import SwiftyJSON

class NotesVC: UIViewController , UITableViewDelegate,UITableViewDataSource{

    
   
    
    
    
    @IBOutlet weak var btn_home: UIButton!
    @IBOutlet weak var view_home: UIView!
    @IBOutlet weak var tableView: UITableView!
   
    var responseJson:JSON = []
    
    var senderTag = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_home.isHidden = true
        view_home.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
       
       
    }

   

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Call the API to fetch data when the view is about to appear
        NotesAPI()
    }
    func reloadData() {
        // Reload the table view data here
        self.tableView.reloadData()
    }
    
    @IBAction func btn_Home(_ sender: Any) {
  
    }
    
    
    
    
    
    
    func NotesAPI()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        
        
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        AF.request( base.url+"MyPage_GetNotesList", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self) { response in
                print(response.request!)
                print(parameters!)
                switch response.result
                {
                    
                case .success(let value):
                    
                    self.responseJson =  JSON(value)
                    print(self.responseJson)
                    let status = self.responseJson["Status"].intValue
                    if status == 1
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.reloadData()
                                            }
                    else{
                        self.reloadData()
                                               CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let msg  =  self.responseJson["Message"].stringValue
                        self.showAlert(message: msg)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
    }
//    func MyPage_DailyNotesDeleteAPI(notesID:String)
//    {
//
//        var parameters:[String:Any]?
//
//            parameters =  ["TokenNo":"abcHkl7900@8Uyhkj","NotesID":notesID]
//
//        AF.request( base.url+"MyPage_DailyNotesDelete", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//            .responseDecodable(of:JSON.self)  { response in
//                print(response.request!)
//                print(parameters!)
//                switch response.result
//                {
//
//                case .success(let value):
//
//                    self.responseJson =  JSON(value)
//                    print(self.responseJson)
//
//                    let status = self.responseJson["Status"].intValue
//                    if status == 1 {
//
//                        let Message = self.responseJson["Message"].stringValue
//                        // Create the alert controller
//                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
//
//
//                        // Create the actions
//                        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
//                            UIAlertAction in
//                            self.reloadData()
//
//                            self.responseJson.dictionaryObject?.removeValue(forKey: "\(self.senderTag)")
//
//                        }
//                        // Add the actions
//                        alertController.addAction(okAction)
//                        // Present the controller
//                        DispatchQueue.main.async {
//
//                            self.present(alertController, animated: true)
//                        }
//
//                    }else {
//
//                        let Message = self.responseJson["Message"].stringValue
//                        // Create the alert controller
//                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
//
//                        // Create the actions
//                        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
//                            UIAlertAction in
//                            self.reloadData()
//                        }
//                        // Add the actions
//                        alertController.addAction(okAction)
//                        // Present the controller
//                        DispatchQueue.main.async {
//                            self.present(alertController, animated: true)
//                        }
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//
//            }
//
//    }
    func MyPage_DailyNotesDeleteAPI(notesID: String) {
        let parameters: [String: Any] = ["TokenNo": "abcHkl7900@8Uyhkj", "NotesID": notesID]

        AF.request(base.url + "MyPage_DailyNotesDelete", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: JSON.self) { [weak self] response in
                guard let self = self else { return }
                print(response.request!)
                print(parameters)
                switch response.result {
                case .success(let value):
                    let responseJson = JSON(value)
                    print(responseJson)
                    let status = responseJson["Status"].intValue
                    if status == 1 {
                        let Message = responseJson["Message"].stringValue

                        // Update the local data source
                        self.responseJson["DailyNotesList"].arrayObject?.remove(at: self.senderTag)

                        // Reload the table view to reflect the deleted note
                        self.tableView.reloadData()

                        // Create the alert controller
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)

                        // Create the actions
                        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default, handler: nil)
                        
                        // Add the actions
                        alertController.addAction(okAction)
                        
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true)
                        }
                    } else {
                        let Message = responseJson["Message"].stringValue
                        self.showAlert(message: Message)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return  self.responseJson["DailyNotesList"].arrayValue.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notetblcell")as! notetblcell
        let index = indexPath.row
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Delete.addTarget(self, action: #selector(btn_Delete(sender:)), for: .touchUpInside)
     
            cell.txt_note.text = responseJson["DailyNotesList"][index]["ShortNotes"].stringValue + responseJson["DailyNotesList"][index]["FullNotes"].stringValue
            cell.lbl_Date.text = responseJson["DailyNotesList"][index]["Date"].stringValue
            cell.lbl_title.text = responseJson["DailyNotesList"][index]["ShortNotes"].stringValue
        
     
        
        return cell
    }
    @objc func btn_Delete(sender: UIButton) {
        print(sender.tag)
        senderTag = sender.tag

        let notesId = self.responseJson["DailyNotesList"][senderTag]["NotesID"].stringValue

        // Call the API to delete the note
        MyPage_DailyNotesDeleteAPI(notesID: notesId)
    }

  





    
    @IBAction func btn_addChild(_ sender: Any) {
        
        
        
        let options: [SemiModalOption : Any] = [
            SemiModalOption.pushParentBack: false
        ]
        let storyboard = UIStoryboard(name: "Note", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "Notes_childVC") as! Notes_childVC
        pvc.delegate = self
        
        pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 520)
        
        pvc.modalPresentationStyle = .overCurrentContext
      
        presentSemiViewController(pvc, options: options, completion: {
            print("Completed!")
        }, dismissBlock: {
        })
        
    }
    
    
}







class notetblcell : UITableViewCell
{
    
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_Delete: UIButton!
    
    
    @IBOutlet weak var txt_note: UITextView!
    @IBAction func btn_delete(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        txt_note.layer.borderWidth = 0.5
        txt_note.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        txt_note.layer.cornerRadius = 5
        txt_note.isEditable = false
    }
    
}
extension NotesVC: SecondViewControllerDelegate {
    func didPopFromSecondViewController() {
        // This method will be called when the child view controller is dismissed
        // Reload the table view data here
   
        self.NotesAPI()
        print("add ho raha ha kya ")
    }
}
