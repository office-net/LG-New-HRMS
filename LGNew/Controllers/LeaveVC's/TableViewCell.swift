//
//  TableViewCell.swift

//
//  Created by Netcomm Labs on 06/10/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var tblStackView: UIStackView!
    @IBOutlet weak var uiView1: UIView!
    @IBOutlet weak var lblComOffDate: UILabel!
    @IBOutlet weak var lblRequestDate: UILabel!
    @IBOutlet weak var lblDaysEared: UILabel!
    @IBOutlet weak var lblDaysApplied: UILabel!
    @IBOutlet weak var lblBalanceDays: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var uiView2: UIView!
    @IBOutlet weak var uiView3: UIView!
    @IBOutlet weak var uiView4: UIView!
    @IBOutlet weak var uiView5: UIView!
    @IBOutlet weak var uiView6: UIView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
