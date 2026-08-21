//
//  SuggestionCell.swift
//  Kals
//
//  Created by Netcommlabs on 20/04/23.
//

import UIKit
import SDWebImage

class SuggestionCell: UITableViewCell {
    @IBOutlet weak var SuggestionBy:UILabel!
    @IBOutlet weak var Date:UILabel!
    @IBOutlet weak var Suggestion:UITextView!
    @IBOutlet weak var status:UILabel!
    @IBOutlet weak var adminRemark:UITextView!
    @IBOutlet weak var viewDoc : UIButton!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    @objc func viewImage() {
        print("avchjcvhcvdcvdhcvdh")
    
           // Handle image button tap here
           // You can display the image in a popup or navigate to a new view controller to show the image in detail.
           // Example: Create a popup or navigate to a new view controller to show the image
       }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
  

