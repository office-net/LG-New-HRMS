//
//  CalenderClass.swift
//  FSCalender
//
//  Created by Netcomm Labs on 12/12/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import FSCalendar
import SemiModalViewController


class CalenderClass: UIViewController {
    let currentDate = Date()
    var resData:JSON = []
    var dataDate:Date? = nil
    let dateFormatterForApi = DateFormatter()
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var fsCalender: FSCalendar!
    @IBOutlet weak var Hieght_Calander: NSLayoutConstraint!
    var GetData:JSON = []
    @IBOutlet weak var Hieght_Tbl: NSLayoutConstraint!
    @IBOutlet weak var btn_Change: UIButton!
    var UserIDD = ""
    
    
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Attendance"
        self.fsCalender.dataSource = self
        self.fsCalender.delegate = self
        fsCalender.allowsSelection = false

        self.ApiCalling(DAte: Date.getCurrentDate2())
        dateFormatterForApi.dateFormat = "dd/MM/yy"
       
        tbl.delegate = self
        tbl.dataSource = self
        tbl.separatorStyle = .none
        Hieght_Tbl.constant = 0
        
        
        
    }
    //menu  grid
    
    @IBAction func btn_Change(_ sender: Any) {
        if Hieght_Tbl.constant == 0
        {
            fsCalender.isHidden = true
            Hieght_Calander.constant = 0
            btn_Change.setImage(UIImage(named: "grid"), for: .normal)
            Hieght_Tbl.constant = 500
        }
        else
        {
            fsCalender.isHidden = false
            Hieght_Calander.constant = 430
            Hieght_Tbl.constant = 0
            btn_Change.setImage(UIImage(named: "list"), for: .normal)
            
        }
    }
    
    
    @IBAction func Abb(_ sender: Any) {
        
           let options: [SemiModalOption : Any] = [
                SemiModalOption.pushParentBack: false
            ]
            let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "AbbrevationVC") as! AbbrevationVC
            pvc.resData = GetData["MyAttendanceAbbreviationRes"]
            pvc.view.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: 50 * GetData["MyAttendanceAbbreviationRes"].count + 100 )
            pvc.modalPresentationStyle = .overCurrentContext
            presentSemiViewController(pvc, options: options, completion: {
                print("Completed!")
            }, dismissBlock: {
            })
            
        
    }
    
    
  }

extension CalenderClass:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // self.Hieght_Tbl.constant = CGFloat(resData.count *  130)
        return resData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clanderCell", for: indexPath) as! clanderCell
        let dateString = resData[indexPath.row]["DateOffice2"].stringValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM dd"
            let finalDate = dateFormatter.string(from: date)
           // print(finalDate)
            let arrDate = finalDate.components(separatedBy: " ")
            let strDate = arrDate[1]
            let strDateMonth = arrDate[0]

            cell.Day.text = strDate
            cell.Month.text = strDateMonth
        }
        cell.Status.text = resData[indexPath.row]["Status"].stringValue
        cell.Punch_In.text = resData[indexPath.row]["InTime"].stringValue
        cell.Punch_Out.text = resData[indexPath.row]["OutTime"].stringValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}







extension CalenderClass {
 
    func ApiCalling(DAte:String){

        var parameters:[String:Any]?
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserId":self.UserIDD,"Date":DAte]
        
        Networkmanager.postRequest(vv: self.view, remainingUrl:"GetMyAttendance", parameters: parameters!) { (response,data) in
            print(response)
            print(parameters!)
            
            let status =  response["Status"].intValue
            if status == 1
            {
                print("enter the True state ")
                self.GetData = response
                self.resData = response["objMyAttendanceRes"]
                DispatchQueue.main.async {
                 self.fsCalender.reloadData()
                    self.tbl.reloadData()
                 }
            }
            else
            {
                print("enter the False state ")
                let Message = response["Message"].stringValue
                self.showAlert(message: Message)
                self.resData = response["objMyAttendanceRes"]
                self.GetData = response
                self.tbl.reloadData()
            }
            
            
        }
      
    }
    }

extension CalenderClass: FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance {

    func minimumInteritemSpacingForSection(at section: Int) -> CGFloat {
           return 1 // Adjust the spacing between dates within a row
       }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
          let currentPage = calendar.currentPage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateeee = dateFormatter.string(from: currentPage)
        ApiCalling(DAte: dateeee)
          // Your code to handle month change
      }


    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
         // Check if the date meets certain conditions
        let dateString = dateFormatterForApi.string(from: date)
        if let index = resData.arrayValue.firstIndex(where: { $0["DateOffice2"].stringValue == dateString }) {
            
           
                let color = UIColor(hex: resData[index]["Color"].stringValue)
                return color
            }
         
          else {
             return nil // Keep the default background color
         }
     }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        
        return UIColor.black
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return UIColor.black
    }
   
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let dateString = dateFormatterForApi.string(from: date)
        // Use array index to access elements
        if let index = resData.arrayValue.firstIndex(where: { $0["DateOffice2"].stringValue == dateString }) {
            return resData[index]["Status"].stringValue
        }
        return nil
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
      
            return 0.0
      
    }
}






extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}





class clanderCell:UITableViewCell
{
    @IBOutlet weak var Day: UILabel!
    @IBOutlet weak var Month: UILabel!
    @IBOutlet weak var Punch_In: UILabel!
    @IBOutlet weak var Punch_Out: UILabel!
    @IBOutlet weak var Status: UILabel!
    
}
