

//  Created by Ankit Rana 8368302473



import Foundation
import UIKit
class base
{
    
    static var Token = ""
    static var Title = "LG HRMS"
    static var ok = "OK"
    static var cancel = "Cancel"
    static var yes = "YES"
    static var alertname = Title
    static let url = "https://www.lge-india.com/AppServices.svc/"
    //MARK: LIVE URL --> "https://hrms.adlindia.in/MobileAPI/AppServices.svc/"
    //MARK: UAT URL --> "https://lg.officenet.in/mobileAPI/AppServices.svc"
     
    // pass : 1
    // user : IL193018

    static var APP_ID = "6798118458"
    static var Url_Name = "LG-MYHR"
    
    static let firstcolor = #colorLiteral(red: 0.8392156863, green: 0, blue: 0.05490196078, alpha: 1)
    static let secondcolor = #colorLiteral(red: 0.2666666667, green: 0.1098039216, blue: 0.08235294118, alpha: 1)
    
    
    static func saveDoubleValue(_ value: Double, forKey key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }

    static func getDoubleValue(forKey key: String) -> Double {
        let defaults = UserDefaults.standard
        return defaults.double(forKey: key)
    }
    static func changeImageCalender(textField:UITextField)
    {
        if let myImage = UIImage(named: "calendar")
        {
            
            textField.withImage(direction: .Left, image: myImage, colorBorder: UIColor.clear)
        }
    }
    static func changeImageClock(textField:UITextField)
    {
        if let myImage = UIImage(named: "wallclock")
        {
            
            textField.withImage(direction: .Left, image: myImage, colorBorder: UIColor.clear)
        }
    }
    
    
    static func openURLInSafari(urlString: String)
    {
      guard let url = URL(string: urlString) else { return }
       UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static func getCurrentTime() -> String
    {
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let time = "\(hour):\(minutes):\(seconds)"
        return time
        
    }
    static func getCurrentTimestamp() -> Int
    {
        let currentDate = Date()
        let timestamp = Int(currentDate.timeIntervalSince1970)
        return timestamp
    }
    
}
class CustomActivityIndicator {
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    static let sharedInstance = CustomActivityIndicator()
    private init() {}
    
    
    func showActivityIndicator(uiView: UIView) {
        
        container.frame = uiView.frame
        container.center = uiView.center
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.clear
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width:40.0, height: 40.0)
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.color = base.firstcolor
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
        }

    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
}


class Gradientbutton: UIButton {
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
class statusView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        let color1 = base.firstcolor
        let color2 =  base.secondcolor
        gradientLayer.colors = [color1.cgColor,color2.cgColor]
    }
}

class Validation {
    static func validateName(name: String) ->Bool {
        
        let nameRegex = "^\\w{3,18}$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    static func validaPhoneNumber(phoneNumber: String) -> Bool {
        let PHONE_REGEX = "^[7-9][0-9]{9}$";
        let trimmedString = phoneNumber.trimmingCharacters(in: .whitespaces)
        let validatePhone = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let isValidPhone = validatePhone.evaluate(with: trimmedString)
        return isValidPhone
    }
    static func validateEmailId(emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        return isValidateEmail
    }
    static func validatePassword(password: String) -> Bool {
        //Minimum 8 characters at least 1 Alphabet and 1 Number:
        let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
    static func validateAnyOtherTextField(otherField: String) -> Bool {
        let otherRegexString = "^[a-z]{1,10}$+^[a-z]$+^[a-z'\\-]{2,20}$+^[a-z0-9'.\\-\\s]{2,20}$+^(?=\\P{Ll}*\\p{Ll})(?=\\P{Lu}*\\p{Lu})(?=\\P{N}*\\p{N})(?=[\\p{L}\\p{N}]*[^\\p{L}\\p{N}])[\\s\\S]{8,}$"
        let trimmedString = otherField.trimmingCharacters(in: .whitespaces)
        let validateOtherString = NSPredicate(format: "SELF MATCHES %@", otherRegexString)
        let isValidateOtherString = validateOtherString.evaluate(with: trimmedString)
        return isValidateOtherString
    }
}




class FileDownloader {

    static func loadFileSync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else if let dataFromURL = NSData(contentsOf: url)
        {
            if dataFromURL.write(to: destinationUrl, atomically: true)
            {
                print("file saved [\(destinationUrl.path)]")
                completion(destinationUrl.path, nil)
            }
            else
            {
                print("error saving file")
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(destinationUrl.path, error)
            }
        }
        else
        {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(destinationUrl.path, error)
        }
    }

    static func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl.path, error)
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
}





