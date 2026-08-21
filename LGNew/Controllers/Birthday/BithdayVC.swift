//
//  BithdayVC.swift
//  Myomax officenet
//
//  Created by Mohit Shrama on 16/06/20.
//  Copyright © 2020 Mohit Sharma. All rights reserved.


import UIKit
import Alamofire
import SwiftyJSON
import SemiModalViewController
protocol YourCellDelegate : AnyObject {
    func didPressButton(_ tag: Int)
}
class BithdayVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var method = ""
    var isFrom = 0
    var getdata:JSON = []
    var selectedIndexPath: NSIndexPath? = nil
    var strType = ""
   override func viewDidLoad() {
        super.viewDidLoad()
        if isFrom == 1
        {
            self.navigationItem.title = "New Joiner"
            self.strType = "New Joiner"
        }
        else if isFrom == 0
        {  self.navigationItem.title = "Birthday"
            self.strType = "Birthday"
        }
       else
       {
           self.navigationItem.title = "Anniversary"
               self.strType = "WORK ANNIVERSARY"
       }
       
        
       
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView  = UIView()
        
        // Do any additional setup after loading the view.
        
        HRCorner_GetListAPI()
    }
    


    func SendToHome() {

        self.navigationController?.popViewController(animated: true)
        
    }
    

    func HRCorner_GetListAPI()
    {   CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj"]
        if isFrom == 1
        {
            self.method = "HRCorner_NewJoineeList"
        }
        else if isFrom == 0
        {
            self.method = "HRCorner_BirthdayList"
        }
        else
        {
            self.method = "AniversaryList"
        }
        AF.request( base.url+self.method, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self)  { response in
                switch response.result
                {
                case .success(let value):
                    let json:JSON = JSON(value)
                    print(json)
                    print(response.request!)
                    print(parameters!)
                    let status =  json["Status"].intValue
                    if status == 1
                    { CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.getdata = json["EmpBirthdayList"]
                        self.tableView.reloadData()
                   }
                    else
                    { CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let msg = json["Message"].stringValue
                        let alertController = UIAlertController(title: base.Title, message: msg, preferredStyle: .alert)
                        // Create the actions
                        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.SendToHome()
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
                } } }
    
    

}

extension BithdayVC:UITableViewDataSource,UITableViewDelegate,YourCellDelegate {
    func didPressButton(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
        
                let options: [SemiModalOption : Any] = [
                    SemiModalOption.pushParentBack: false
                ]
                let storyboard = UIStoryboard(name: "Birthday", bundle: nil)
                let pvc = storyboard.instantiateViewController(withIdentifier: "BirthdayWishVC") as! BirthdayWishVC
                pvc.txtname = getdata[tag]["EmpName"].stringValue
                pvc.imgpath = getdata[tag]["EmpImage"].stringValue
                pvc.empcode = getdata[tag]["EmpID"].stringValue
                pvc.strWishType = self.strType
        
                pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 520)
        
                pvc.modalPresentationStyle = .overCurrentContext
                presentSemiViewController(pvc, options: options, completion: {
                    print("Completed!")
                }, dismissBlock: {
                })
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "birthDayCell") as! birthDayCell
        cell.cellDelegate = self
        cell.btn.tag = indexPath.row
        cell.imgProfile.makeRounded()
        cell.lblName.text = getdata[indexPath.row]["EmpName"].stringValue
        if isFrom == 1
        {   cell.lbl_ChangeDOB_DOJ.text = "Date of Joining"
            cell.lblDOB.text = getdata[indexPath.row]["EmpDOJ"].stringValue
        }
        else
        { cell.lbl_ChangeDOB_DOJ.text = "Date of Birth"
            cell.lblDOB.text = getdata[indexPath.row]["EmpDOB"].stringValue }
        cell.lblDepartMent.text = getdata[indexPath.row]["EmpDepartment"].stringValue
        cell.lblLocation.text = getdata[indexPath.row]["EmpLocation"].stringValue
        cell.lblPosition.text = getdata[indexPath.row]["EmpDesignation"].stringValue
        let EmpImagePath = getdata[indexPath.row]["EmpImage"].stringValue
        cell.imgProfile?.sd_setImage(with: URL(string:EmpImagePath), placeholderImage: UIImage())

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView .cellForRow(at: indexPath) as? birthDayCell
        
               switch selectedIndexPath {
               case nil:
                selectedIndexPath = indexPath as NSIndexPath
                cell?.imgArrow.image  = UIImage(named: "down-chevron")
                


               default:
                if selectedIndexPath! as IndexPath == indexPath {
                       selectedIndexPath = nil
                    cell?.imgArrow.image  = UIImage(named: "prev")
                   


                   } else {
                    selectedIndexPath = indexPath as NSIndexPath
                   
               

                   }
               }
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        let smallHeight: CGFloat = 100
        let expandedHeight: CGFloat = 300.0
        
        let ip = indexPath
        if selectedIndexPath != nil {
            if ip == selectedIndexPath! as IndexPath {
                return expandedHeight
            } else {
                return smallHeight
            }
        } else {
            return smallHeight
        }

    }
    
}


//MARK:-MenuTableViewCell
class birthDayCell: UITableViewCell {
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDepartMent: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblPosition: UILabel!
  
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var lbl_ChangeDOB_DOJ: UILabel!
    @IBOutlet weak var stkView: UIStackView!
    
    var cellDelegate: YourCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.stkView.layer.cornerRadius = 10
        self.stkView.clipsToBounds = true
    }
    
    @IBAction func btn_SEndWishes(_ sender: Any) {
        cellDelegate?.didPressButton((sender as AnyObject).tag)
        

        
    }
    
    
}
class wishes: UIButton {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        let color1 = base.firstcolor
        let color2 = base.secondcolor
        gradientLayer.colors = [color1.cgColor,color2.cgColor]
    }
}
