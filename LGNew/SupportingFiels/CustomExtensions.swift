//
//  CustomExtensions.swift
//  Iclick
//
//  Created by Mayank on 21/01/20.
//  Copyright © 2020 Mayank. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
class LimitedWordCountTextField: UITextField {
    
    // Maximum allowed word count
    let maxWordCount = 10
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add a target to the text field to monitor text changes
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        // Check if the current text exceeds the maximum word count
        if numberOfWords(in: text) > maxWordCount {
            // If it exceeds, trim the text to the maximum allowed words
            let trimmedText = truncateText(text, to: maxWordCount)
            textField.text = trimmedText
        }
    }
    
    // Function to count the number of words in a string
    private func numberOfWords(in text: String) -> Int {
        let components = text.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.count
    }
    
    // Function to truncate the text to a specified word count
    private func truncateText(_ text: String, to wordCount: Int) -> String {
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        let truncatedWords = Array(words.prefix(wordCount))
        return truncatedWords.joined(separator: " ")
    }
}

class Amount_TextFielddd: UITextField {
    // Maximum length allowed for the text field
    let maxLengthAMT = 10
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Add target to monitor editing changed event
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    // This method is called when the text field's text changes
    @objc func editingChanged() {
        // Check if the text length exceeds the maximum length
        if let text = text, text.count > maxLengthAMT {
            // If so, trim the text to the maximum length
            let substring = text.prefix(maxLengthAMT)
            // Update the text field's text to the trimmed text
            self.text = String(substring)
        }
    }
}
extension UITextField
{   func addDownChevronImage() {
    // Create a UIImageView for the down-chevron image
    let imageView = UIImageView(image: UIImage(named: "dropDown")) // Replace "downChevronImage" with your image name

    // Set the image view's content mode for proper scaling (adjust as needed)
    imageView.contentMode = .scaleAspectFit
    
    // Set the frame size of the image view
    imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30) // Adjust the size as needed
    
    // Create a view to contain the image view with proper padding (adjust as needed)
    let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)) // Adjust the size as needed
    
    // Add the image view to the container view
    containerView.addSubview(imageView)
    
    // Set the rightView property of the text field to the container view
    self.rightView = containerView
    
    // Make sure the rightView mode is set to .always so the image is always visible
    self.rightViewMode = .always
}
   
  
}
 


extension UIViewController
{
    
   
    
    func showAlert(message: String) {
        
        if let Language = UserDefaults.standard.string(forKey: "Language") {
           
            if Language == "English"
            {
                let alertController = UIAlertController(title: "LG HRMS", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                // let cancelAction = UIAlertAction(title: "", style: .cancel)
                alertController.addAction(okAction)
                //alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
            else
            {
                let alertController = UIAlertController(title: "LG HRMS", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ठीक है", style: .default)
                // let cancelAction = UIAlertAction(title: "", style: .cancel)
                alertController.addAction(okAction)
                //alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
        }
    
    }
    
    func showAlertWithAction(message:String){
        
        let alertController = UIAlertController(title: base.Title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {_ in
            self.navigationController?.popViewController(animated: true)
            }
          alertController.addAction(okAction)
          self.present(alertController, animated: true, completion: nil)
      }
    
    
    func ShowAlertAutoDisable(message:String)
    {
        let alertController = UIAlertController(title: base.Title, message: message, preferredStyle: UIAlertController.Style.alert)

        present(alertController, animated: true, completion: nil)

        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
}
extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
        
    }
    
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
    
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}


extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

private var __maxLengths = [UITextField: Int]()




extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    
}







@IBDesignable
class CornerRadiusLabel: UILabel {
    
    @IBInspectable var topLeftRadius: CGFloat = 0 {
        didSet {
            updateCorners()
        }
    }
    
    @IBInspectable var topRightRadius: CGFloat = 0 {
        didSet {
            updateCorners()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateCorners()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateCorners()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCorners()
    }
    
    private func updateCorners() {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: topLeftRadius, height: topRightRadius)
        )
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
