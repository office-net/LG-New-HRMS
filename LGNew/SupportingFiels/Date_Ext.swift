//
//  Date_Ext.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 16/09/23.
//

import Foundation
import UIKit

extension UITextField
{

    enum Direction {
        case Left
        case Right
    }
    func withImage(direction: Direction, image: UIImage, colorBorder: UIColor){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        mainView.layer.cornerRadius = 5

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = CGFloat(0.5)
        view.layer.borderColor = colorBorder.cgColor
        mainView.addSubview(view)

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
        view.addSubview(imageView)
        if(Direction.Left == direction){ // image left

            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right

            self.rightViewMode = .always
            self.rightView = mainView
        }

        self.layer.borderColor = colorBorder.cgColor
        self.layer.borderWidth = CGFloat(0.5)
        self.layer.cornerRadius = 5
    }
    func setInputViewDatePicker(target: Any, selector: Selector) {
          // Create a UIDatePicker object and assign to inputView
          let screenWidth = UIScreen.main.bounds.width
          let datePicker = UIDatePicker()
          if #available(iOS 13.4, *) {
              datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
          } else {
              // Fallback on earlier versions
          }
          datePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 200, width: self.frame.size.width, height: 200)//1
          datePicker.datePickerMode = .date //2
          self.inputView = datePicker //3

          let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 45.0)) //4
          let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
          let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
          let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
          toolBar.setItems([cancel, flexible, barButton], animated: false) //8
          self.inputAccessoryView = toolBar //9
      }
    func setInputViewDatePicker2(target: Any, selector: Selector) {
          // Create a UIDatePicker object and assign to inputView
          let screenWidth = UIScreen.main.bounds.width
          let datePicker = UIDatePicker()
          if #available(iOS 13.4, *) {
              datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
          } else {
              // Fallback on earlier versions
          }
          datePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 200, width: self.frame.size.width, height: 200)//1
          datePicker.datePickerMode = .date //2
          self.inputView = datePicker //3

        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
            var components = DateComponents()
            components.calendar = calendar
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        datePicker.minimumDate = minDate

          let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 45.0)) //4
          let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
          let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
          let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
          toolBar.setItems([cancel, flexible, barButton], animated: false) //8
          self.inputAccessoryView = toolBar //9
      }
      
      
      
      func setInputViewDateTimePicker(target: Any, selector: Selector) {
          // Create a UIDatePicker object and assign to inputView
          let screenWidth = UIScreen.main.bounds.width
          let datePicker = UIDatePicker()//1
          
          if #available(iOS 13.4, *) {
              datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
          }
          else {
            
               }
          
          datePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 200, width: self.frame.size.width, height: 200)
          datePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
          datePicker.datePickerMode = .time //2
          self.inputView = datePicker //3
          let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
          
          let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
          let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
          let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
          toolBar.setItems([cancel, flexible, barButton], animated: false) //8
          self.inputAccessoryView = toolBar //9
          
      }
      
      @objc func tapCancel() {
          self.resignFirstResponder()
      }
  
}
extension Date {
    
    static func datee (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
}

extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd/MM/yyyy"

        return dateFormatter.string(from: Date())

    }
   
    static func getCurrentDate2() -> String {

           let dateFormatter = DateFormatter()

           dateFormatter.dateFormat = "yyyy-MM-dd"

           return dateFormatter.string(from: Date())

       }
    static func getCurrentDate3() -> String {

           let dateFormatter = DateFormatter()

           dateFormatter.dateFormat = "yyyyMM"

           return dateFormatter.string(from: Date())

       }
    static func getCurrentYear() -> String {

           let dateFormatter = DateFormatter()

           dateFormatter.dateFormat = "yyyy"

           return dateFormatter.string(from: Date())

       }
    
    static func getCurrentDate4() -> String {

           let dateFormatter = DateFormatter()

           dateFormatter.dateFormat = "MM/dd/yyyy"

           return dateFormatter.string(from: Date())

       }
}
extension Date {


    static func getCurrentTime() -> String {

           let dateFormatter = DateFormatter()

           dateFormatter.dateFormat = "HH:mm:ss"

           return dateFormatter.string(from: Date())

       }
    static func getCurrentTime_HH_mm_a() -> String {

           let dateFormatter = DateFormatter()

           dateFormatter.dateFormat = "hh:mm a"

           return dateFormatter.string(from: Date())

       }
    
    
    static func getCurrentTime_HH_mm() -> String {

           let dateFormatter = DateFormatter()

           dateFormatter.dateFormat = "HH:mm"

           return dateFormatter.string(from: Date())

       }

}




extension UITextField
{
    func Set_DatePicker_With_Range(target: Any, selector: Selector,FromDate:String,Todate:String) {
          // Create a UIDatePicker object and assign to inputView
          let screenWidth = UIScreen.main.bounds.width
          let datePicker = UIDatePicker()
          if #available(iOS 13.4, *) {
              datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
          } else {
              // Fallback on earlier versions
          }
          datePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 200, width: self.frame.size.width, height: 200)//1
          datePicker.datePickerMode = .date //2
          self.inputView = datePicker //3
         let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let FromDateString = FromDate
        let ToDateString = Todate
        let minimumDate = dateFormatter.date(from: FromDateString)
        let maximumDate = dateFormatter.date(from: ToDateString)
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate  =  maximumDate

          let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 45.0)) //4
          let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
          let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
          let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
          toolBar.setItems([cancel, flexible, barButton], animated: false) //8
          self.inputAccessoryView = toolBar //9
      }
    
    func Set_DatePicker_With_From_date(target: Any, selector: Selector,FromDate:String) {
          // Create a UIDatePicker object and assign to inputView
          let screenWidth = UIScreen.main.bounds.width
          let datePicker = UIDatePicker()
          if #available(iOS 13.4, *) {
              datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
          } else {
              // Fallback on earlier versions
          }
          datePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 200, width: self.frame.size.width, height: 200)//1
          datePicker.datePickerMode = .date //2
          self.inputView = datePicker //3
         let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let FromDateString = FromDate
    
        let minimumDate = dateFormatter.date(from: FromDateString)
      //  print(minimumDate!)
        datePicker.minimumDate = minimumDate
        
      

          let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 45.0)) //4
          let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
          let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
          let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
          toolBar.setItems([cancel, flexible, barButton], animated: false) //8
          self.inputAccessoryView = toolBar //9
      }
    
    
    func set_TimePicker_With_TimeRange(target: Any, selector: Selector, startTime: String, endTime: String) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker()
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Handle older iOS versions here if needed
            datePicker.datePickerMode = .time
        }
        
        datePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 200, width: self.frame.size.width, height: 200)
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.datePickerMode = .time
        
        //let dateFormatter = DateFormatter()
        Formatter.time.defaultDate = Calendar.current.startOfDay(for: Date())
        let minimumDate = Formatter.time.date(from: startTime)!
            let maximumDate = Formatter.time.date(from: endTime)!
        datePicker.date = minimumDate
        datePicker.datePickerMode = .time
       
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let done = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        
        toolBar.setItems([cancel, flexible, done], animated: false)
        self.inputAccessoryView = toolBar
    }

}

extension Formatter {
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "em_US_POSIX")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
