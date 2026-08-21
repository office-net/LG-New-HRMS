//
//  LeaveVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 05/10/21.
//

import UIKit
import SnapKit
import LZViewPager
class LeaveVC: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource  {
 
    
  
    @IBOutlet weak var pagerView: LZViewPager!
    private var subControllers:[UIViewController] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   
        
        
      
        self.title = "Leave Management"
        let vc1 = UIViewController.createFromNib_For_Leave(storyBoardId: "RequestDetailsVC")
        vc1!.title = "Request Details"
        
        let vc2 = UIViewController.createFromNib_For_Leave(storyBoardId: "PendingDetailVC")
        vc2!.title = "Approval Pending Details"
        
        let vc3 = UIViewController.createFromNib_For_Leave(storyBoardId: "ArchiveDetailsVC")
        vc3!.title = "Archive Details"
        
        let vc4 = UIViewController.createFromNib_For_Leave(storyBoardId: "CancellationDetailsVC")
        vc4!.title = "Cancellation Details"
        subControllers = [vc1!, vc2!,vc3!, vc4!]
        pagerView.hostController = self
        pagerView.reload()
        
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                self.title = "Leave Management"
                vc1!.title = "Request Details"
                vc2!.title = "Approval Pending Details"
                vc3!.title = "Archive Details"
                vc4!.title = "Cancellation Details"
            }
            else
            {
                self.title = "छुट्टी प्रबंधन"
                vc1!.title = "अनुरोध विवरण"
                vc2!.title = "लंबित विवरण"
                vc3!.title = "पुरालेख विवरण"
                vc4!.title = "रद्दीकरण विवरण"
            }
        }
        
        
        
        subControllers = [vc1!, vc2!,vc3!, vc4!]
        pagerView.hostController = self
        pagerView.reload()
        
    }
    

    
    

    
    @IBAction func btn_NewRequest(_ sender: Any) {
      
        let storyboard = UIStoryboard(name: "Leave", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "NewRequestVC")as! NewRequestVC
        self.navigationController?.pushViewController(secondVC, animated: true)

        
    }
    
   
    
    
    
    
    
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
    
    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }
    
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(base.firstcolor, for: .selected)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)

        return button
    }
    func colorForIndicator(at index: Int) -> UIColor {
        return base.firstcolor
    }
    func widthForButton(at index: Int) -> CGFloat {
        
        if index == 0{
            return 150
        }
        return 150
    }
    
    func buttonsAligment() -> ButtonsAlignment {
        return .left
    }
    
    func widthForIndicator(at index: Int) -> CGFloat {
        if index == 0{
            return 110
        }
        return 110
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
            
            super.viewWillAppear(animated)
            // CALL API
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.navigationBar.barStyle = .default
            self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = base.firstcolor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
        }
    
    
    
}
extension UIViewController {
    static func createFromNib<T: UIViewController>(storyBoardId: String) -> T?{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyBoardId) as? T
    }
    
    static func createFromNib_For_Leave<T: UIViewController>(storyBoardId: String) -> T?{
        return UIStoryboard(name: "Leave", bundle: nil).instantiateViewController(withIdentifier: storyBoardId) as? T
    }
}
