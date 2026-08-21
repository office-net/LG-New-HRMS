//
//  ChatBoatVC.swift
//  IOS
//
//  Created by Netcommlabs on 25/07/23.
//

import UIKit
import SwiftyJSON
import Alamofire

class ChatBoatVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var txt: UITextField!
    @IBOutlet weak var tbl: UITableView!
    var IsHoliday = true
    var HolidayName = ""
    var previousMonthStr = ""
    var nextMonthStr = ""
    var QAArray = ["Hello and welcome to the Officenet HRMS system.\n I am OfficeNet Bot. \n How can I help you? 😀"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date())
       let PreviousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
       
       let formatter = DateFormatter()
       // initially set the format based on your datepicker date / server String
       formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       let myString = formatter.string(from: nextMonth!) // string purpose I add here
       let yourDate = formatter.date(from: myString)
       formatter.dateFormat = "dd/MM/yyyy"
       let strNextMonth = formatter.string(from: yourDate!)
       
       
       let myStringPrevious = formatter.string(from: PreviousMonth!) // string purpose I add here
       let yourDatePrevious = formatter.date(from: myStringPrevious)
       formatter.dateFormat = "dd/MM/yyyy"
       let strPreviousMonth = formatter.string(from: yourDatePrevious!)
        previousMonthStr = strPreviousMonth
        nextMonthStr = strNextMonth
        UiSetup()
    }
    
    
    
    @IBAction func btn(_ sender: Any) {
        SendMessage()
    }
    
    
}
extension ChatBoatVC
{
    
    
    
    func SendMessage()
    {
        if txt.text != ""
        {
            self.QAArray.append(txt.text!)
            
            
            if  txt.text!.contains("hello") || txt.text!.contains("hii") || txt.text!.contains("hey") || txt.text!.contains("hi")
            {    QAArray.append("Hi there! How can I assist you today?😀")
                
            }
            else if txt.text!.contains("OK") || txt.text!.contains("ok") || txt.text!.contains("Ok")
            {
                QAArray.append("You're welcome! Glad to be of help. Have a great day!")
            }
            else if txt.text!.contains("thanks") || txt.text!.contains("Thanks") || txt.text!.contains("Thank you") || txt.text!.contains("thank you")
            {
                QAArray.append("You're welcome! Glad to be of help. Have a great day!")
                
            }
          //  Is today a holiday?
            else if txt.text!.contains("today is a holiday") ||  txt.text!.contains("today is off") || txt.text!.contains("holiday today") || txt.text!.contains("today is holiday")  || txt.text!.contains("Is today a holiday?") || txt.text!.contains("is today a holiday") || txt.text!.contains("today holiday")
            {
                self.CheckTodayHolida(HolidayList: "2")
                
            }
            
            else if txt.text!.contains("Upcoming holiday") ||  txt.text!.contains("upcoming holiday") || txt.text!.contains("Upcoming holidays") || txt.text!.contains("upcoming holidays")  || txt.text!.contains("Next Holiday") || txt.text!.contains("next holiday")
            {
                self.CheckTodayHolida(HolidayList: "3")
                
            }
            
            
            
            else if txt.text!.contains("Holiday List") ||  txt.text!.contains("holiday list") || txt.text!.contains("Holiday list") || txt.text!.contains("holiday List") || txt.text!.contains("list of holiday")
            
            {
                self.CheckTodayHolida(HolidayList: "1")
            }
            
            else if txt.text!.contains("approval dashboard") ||  txt.text!.contains("Approval Dashboard ") || txt.text!.contains("Approval dasboard ")
            
            {
                self.GetPandingLeave()
            }
            
            else if txt.text!.contains("tell me about officenet") || txt.text!.contains("officenet") || txt.text!.contains("Officenet") || txt.text!.contains("OfficeNet")
            {
                QAArray.append("Officenet HR Solution Software delivers world class Cloud and On Premise HR cum Payroll Solutions to leading Organizations on a PAN India basis. With 10 Years of a rich experience we assist HR teams to bring about both transactional and transformational change within their Companies.")
            }
            
            else if txt.text!.contains("Leave Balance") ||  txt.text!.contains("leave balance") ||  txt.text!.contains("leaves balance")
            {
                self.LeaveBalance()
            }
            
            else if txt.text!.contains(" My Pending Leaves") ||  txt.text!.contains("my pending leaves") || txt.text!.contains(" my leaves") ||  txt.text!.contains("My Leave Status") || txt.text!.contains("my leave status") ||  txt.text!.contains("my last leave status")
            
            {
                self.MyLeaveStatus()
            }
            
            else if txt.text!.contains("about myself") ||  txt.text!.contains("Tell me about myself") ||  txt.text!.contains("show my details") ||  txt.text!.contains("show me about my self") ||   txt.text!.contains("my details") ||   txt.text!.contains("my self") ||   txt.text!.contains("My Self")
            
            {
                self.GetMyDetails(IsRm: "1")
            }
            
            else if txt.text!.contains("RM") ||  txt.text!.contains("reporting manager") ||  txt.text!.contains("Reporting Manager") ||  txt.text!.contains("Manager") ||  txt.text!.contains("HOD") ||  txt.text!.contains("Head Of Department") ||  txt.text!.contains("head of department")
            
            {
                self.GetMyDetails(IsRm: "2")
            }
            
            else if txt.text!.contains("Designation") ||  txt.text!.contains("designation")
            
            {
                self.GetMyDetails(IsRm: "3")
            }
            
            else if txt.text!.contains("Weeks Off") || txt.text!.contains("week off") || txt.text!.contains("weeks off")
            
            {
                let date = Date()
                let calendar = Calendar.current
                let range = calendar.range(of: .day, in: .month, for: date)!
                let numDays = range.count
                let firstWeekday = calendar.component(.weekday, from: date)
                let daysInFirstWeek = (7 + firstWeekday - calendar.firstWeekday) % 7
                let numSundays = (numDays - daysInFirstWeek) / 7 + (daysInFirstWeek != 0 ? 1 : 0)
                self.QAArray.append("There are \(numSundays) Sundays in this month")
                
            }
            else if txt.text!.contains("Attendance") || txt.text!.contains("attendance")
            {
                self.GetAttendance()
            }
            
            
            else
            {
                QAArray.append("Kindly ask about the Only Officenet Leave Management System, Like your holiday list, pending leave, whether today is off or not, etc.")
            }
            
            self.tbl.reloadData()
            self.scrollToBottom()
            self.txt.text = ""
        }
        else
        {
            self.showAlert(message: "Please Enter the Question First! ")
        }
    }
}






//===========================================================API"S==========================================================

extension ChatBoatVC
{
    
    
    func GetAttendance()
    
    {
        var parameters:[String:Any]
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserId":UserID!,"Date":Date.getCurrentDate2()]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"GetMyAttendance", parameters: parameters) { (response,data) in
            
            print(response)
            let status = response["Status"].intValue
            if status == 1
            {   var list = "Your Attendance is given below. \n\n"
                for i in 0...response["MyAttendanceAbbreviationRes"].count - 1
                
                {
                    let datalist = response["MyAttendanceAbbreviationRes"][i]
                    list = list + " Your have \(datalist["AbbreviationDayCount"].stringValue) \(datalist["CalenderStatus"].stringValue) Till Date .\n\n"
                }
                list = list + "\n\n For more details, please go to My Attendance Module, which is located on the home page."
                self.QAArray.append(list)
                self.tbl.reloadData()
                self.scrollToBottom()
               
            }
            else
            {
                self.QAArray.append("No data found on your details")
                self.tbl.reloadData()
                self.scrollToBottom()
            }
        }
        
        
    }
    func GetMyDetails( IsRm:String)
    {
        var parameters:[String:Any]
         let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        parameters = ["UID": UserID!, "TokenNo": "abcHkl7900@8Uyhkj"]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"UpdateEmpProfile", parameters: parameters) { (response,data) in
            
            print(response)
            let status = response["Status"].intValue
            if status == 1
            {
                if IsRm == "1"
                {
                    let list  = "Your Name is \(response["UserName"].stringValue). \n Your Employee Code is \(response["EmpCode"].stringValue). \n Your DOB is \(response["DateOfBirth"].stringValue). \n Your Date Of joining is \(response["DateOfJoining"].stringValue) \n \nfor more details Kindly go to the profile Module"
                    self.QAArray.append(list)
                }
                
                else if IsRm == "2"
                {
                    let list  = "Your Reporting Manager is \(response["ReportingManager"].stringValue). \n Your HOD is \(response["HeadOfDepartment"].stringValue). \n \n for more details Kindly go to the profile Module"
                    self.QAArray.append(list)
                }
                else if IsRm == "3"
                {
                    let list  = "Your Designation is \(response["Designation"].stringValue). \n Your Location is \(response["Location"].stringValue). \n \n for more details Kindly go to the profile Module"
                    self.QAArray.append(list)
                }
                
                self.tbl.reloadData()
                self.scrollToBottom()
                
            }
            else
            {
                self.QAArray.append("No data fount in you profile details")
                self.tbl.reloadData()
                self.scrollToBottom()
            }
        }
    }
    
    
    func MyLeaveStatus()
    {       var parameters:[String:Any]
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID!,"FromDate":previousMonthStr,"ToDate":nextMonthStr,"ReqTypeID":"1","ReqNo":""]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"LeaveHistoryList", parameters: parameters) { (response,data) in
            
            print(response)
            let status = response["Status"].intValue
            if status == 1
            {
                var list  = "Kindly check below your last leave statuses. \n"
                
                for i in 0...response["objleaveGetDetailsRes"].count - 1
                {
                    let datalist = response["objleaveGetDetailsRes"][i]
                    
                    list = list + " \n Request Number : \(datalist["ReqNo"].stringValue) \n Your RM Status : \(datalist["Rm_Status"].stringValue) \n Your HOD Status : \(datalist["HODStatus"].stringValue) \n\n"
                }
                self.QAArray.append(list)
                self.tbl.reloadData()
                self.scrollToBottom()
                
            }
            else
            {
                self.QAArray.append("You don't have any pending leave for approval.")
                self.tbl.reloadData()
                self.scrollToBottom()
            }
        }
        
    }
    
    
    
    
    
    
    
    func GetPandingLeave()
    {
        
        var parameters:[String:Any]
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID!,"FromDate":previousMonthStr,"ToDate":nextMonthStr,"ReqTypeID":"1","ReqNo":""]
        
        Networkmanager.postRequest(vv: self.view, remainingUrl:"LeavePendingList", parameters: parameters) { (response,data) in
            
            print(response)
            let status = response["Status"].intValue
            
            if status == 1
            {
                var list = "There are total \(response["TotalNoOfRecord"].stringValue) pending leaves for your approval. \n\n"
                for i in 0...response["objleaveGetDetailsRes"].count - 1
                {
                    let datalist = response["objleaveGetDetailsRes"][i]
                    list = list + " EmpName : \(datalist["EmpName"].stringValue) \n Request Number : \(datalist["ReqNo"].stringValue) \n  Leave Period : \(datalist["Period"].stringValue) \n\n"
                }
                self.QAArray.append(list)
                self.tbl.reloadData()
                self.scrollToBottom()

            }
            else
            {
                self.QAArray.append("You dont have any pending leave for approval")
                self.tbl.reloadData()
                self.scrollToBottom()
            }
        }
        
      
    }
    
    
    
    
    
    
    
    
    
    
    func CheckTodayHolida(HolidayList:String)  {
        
        let parameters:[String:Any]
       // let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        parameters = ["TokenNo": "abcHkl7900@8Uyhkj", "LocationID": "2", "HolidayYear": "2024"]
        
        AF.request("https://suvidha.khannapaper.com/MobileAPI/AppServices.svc/GetHolidayList", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable (of:JSON.self) { response in
                print(response.request!)
                print(parameters)
                switch response.result
                {
                    
                
                case .success(let Ankit):
                    var response:JSON = []
                    response = JSON(Ankit)
                    let status = response["Status"].intValue
                  
                    if status == 1
                    {   var isMatch = false
                        if HolidayList == "1"
                        {    var holidayList = ""
                            for i in 0...response["HolidayCalList"].count - 1
                            {
                                let data = response["HolidayCalList"][i]
                                let List = " Date of Holiday is -> \(data["Date"].stringValue) \n Day -> \(data["Day"].stringValue) \n Occation -> \(data["Occation"].stringValue) \n \n"
                                holidayList = holidayList + List
                                
                            }
                            self.QAArray.append(holidayList)
                        }
                        else if HolidayList == "2"
                        {
                            
                            for i in 0...response["HolidayCalList"].count - 1
                            {
                                if self.compareDates(date1: Date.getCurrentDate(), date2: response["HolidayCalList"][i]["Date"].stringValue)
                                {
                                    self.QAArray.append("Yea today is holiday due to \(response["HolidayCalList"][i]["Occation"].stringValue)")
                                    isMatch = true
                                    break
                                }
                                
                            }
                            if isMatch == false
                            {
                                self.QAArray.append("There is no holiday Today")
                            }
                        }
                        else
                        {    var holidayList = ""
                            for i in 0...response["HolidayCalList"].count - 1
                            {
                                let dateString = response["HolidayCalList"][i]["Date"].stringValue
                                if self.compareDates2(date1: Date.getCurrentDate(), date2:dateString)
                                {
                                    
                                    let data = response["HolidayCalList"][i]
                                    let List = " Date of Holiday is -> \(data["Date"].stringValue) \n Day -> \(data["Day"].stringValue) \n Occation -> \(data["Occation"].stringValue) \n \n"
                                    holidayList = holidayList + List
                                }
                            }
                            self.QAArray.append(holidayList)
                            
                        }
                        
                        self.tbl.reloadData()
                        self.scrollToBottom()
                    }
                    
                    else
                    {
                        self.QAArray.append("There is no holiday list data found on you location")
                        self.tbl.reloadData()
                        self.scrollToBottom()
                    }
                case .failure(let rana):
                    print(rana.localizedDescription)
                }
            }
        
    
        
        
        
    }
    
    func compareDates(date1: String, date2: String) -> Bool {
        let date1Formatter = DateFormatter()
        date1Formatter.dateFormat = "dd-MM-yyyy"
        let date2Formatter = DateFormatter()
        date2Formatter.dateFormat = "dd-MM-yyyy"
        
        guard let date1Obj = date1Formatter.date(from: date1),
              let date2Obj = date2Formatter.date(from: date2)
        else {
            return false
        }
        
        return date1Obj == date2Obj
    }
    
    func compareDates2(date1: String, date2: String) -> Bool {
        let date1Formatter = DateFormatter()
        date1Formatter.dateFormat = "dd-MM-yyyy"
        let date2Formatter = DateFormatter()
        date2Formatter.dateFormat = "dd-MM-yyyy"
        
        guard let date1Obj = date1Formatter.date(from: date1),
              let date2Obj = date2Formatter.date(from: date2)
        else {
            return false
        }
        
        return date1Obj <= date2Obj
    }
    
    
    
    
    
    
    func LeaveBalance()
    {  let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let currentYear = formatter.string(from: date)
        let parameters:[String:Any]
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int ,
           let PlantID = UserDefaults.standard.object(forKey: "PlantID") as? String{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"PlantID":PlantID,"Year":currentYear]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserId":"0","PlantID":"0","Year": "2021"]
        }
        
        
        Networkmanager.postRequest(vv: self.view, remainingUrl:"Leave_GetBalance", parameters: parameters) { (response,data) in
            let status = response["Status"].intValue
          
            if status == 1
            {    var list = ""
                for  i in 0...response["objLeaveBalanceType"].count - 1
                {
                    let datalist = response["objLeaveBalanceType"][i]
                    list = list + " You have \(datalist["Balance"].stringValue) \(datalist["LeaveType"].stringValue) Leave . \n\n "
                }
                self.QAArray.append(list)
                self.tbl.reloadData()
                self.scrollToBottom()

            }
            else
            {
                self.QAArray.append("No data was found on your leave details.")
                self.tbl.reloadData()
                self.scrollToBottom()
            }
            
        }
    }
    
    
}














extension ChatBoatVC
{
    func UiSetup()
    {
        self.title = "OfficeNet Bot"
        tbl.delegate = self
        tbl.dataSource = self
        tbl.separatorStyle = .none
        tbl.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        txt.delegate = self
        updateTableContentInset()
        scrollToBottom()
        
    }
    
    func updateTableContentInset() {
        let numRows = self.tbl.numberOfRows(inSection: 0)
        var contentInsetTop = self.tbl.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tbl.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        self.tbl.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.QAArray.count-1, section: 0)
            self.tbl.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if txt.text?.isEmpty == false
        {
            self.SendMessage()
            
        }
        
        return false
    }
}



extension ChatBoatVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QAArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! chatCell
        cell.lbl.text = QAArray[indexPath.row]
        if indexPath.row % 2 == 0 {
            
            cell.lbl.textAlignment = .left
            cell.lbl.textColor = base.firstcolor
            cell.img.image = UIImage(named: "robot")
            cell.lbl_Outer.layer.borderWidth = 1
            cell.lbl_Outer.layer.borderColor = base.firstcolor.cgColor
        } else {
            cell.lbl.textAlignment = .right
            cell.lbl.textColor = base.secondcolor
            cell.img.image = nil
            
        }
        
        
        cell.lbl.numberOfLines = 100
        
        cell.lbl.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        
        
        
        
        return cell
    }
   
}















class chatCell:UITableViewCell
{
    @IBOutlet weak var lbl:UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lbl_Outer: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
