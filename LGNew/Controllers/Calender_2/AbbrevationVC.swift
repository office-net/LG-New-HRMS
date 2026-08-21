//
//  AbbrevationVC.swift
//  Myomax officenet
//
//  Created by admin on 08/03/21.
//  Copyright © 2021 Mohit Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AbbrevationVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var resData:JSON = []
    let dateFormatter = DateFormatter()
    let dateFormatterForApi  = DateFormatter()
    var dataDate:Date? = nil
    let currentDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        print(resData)
       
    }
    
  

 
    

}


extension AbbrevationVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resData.arrayValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AberCell") as! AberCell
        

        cell.lbl.text = resData[indexPath.row]["ShortDesc"].stringValue + "( \(resData[indexPath.row]["AbbreviationDayCount"].stringValue) )"
         let color = hexStringToUIColor(hex: resData[indexPath.row]["Color"].stringValue)
        cell.vv.backgroundColor = color
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

//MARK:-MenuTableViewCell
class AberCell: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var vv: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
}


