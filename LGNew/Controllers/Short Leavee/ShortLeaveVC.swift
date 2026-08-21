//
//  ShortLeaveVC.swift
//  Prince_Pipes_Newls
//
//  Created by Netcommlabs on 25/08/23.
//

import UIKit
import SnapKit
import LZViewPager
class ShortLeaveVC: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource {
    
    @IBOutlet weak var pagerView: LZViewPager!
    private var subControllers:[UIViewController] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Short Leave"
      
        let vc1 = UIViewController.createFromNib_For_SL(storyBoardId: "SL_MyRequest")
        vc1!.title = "Request Details"
        
        let vc2 = UIViewController.createFromNib_For_SL(storyBoardId: "SL_Pending")
        
        
        let vc3 = UIViewController.createFromNib_For_SL(storyBoardId: "SL_Archive")

        self.title = "Short Leave"
        vc1!.title = "Request Details"
        vc2!.title = "Approval Pending Details"
        vc3!.title = "Archive Details"
        let defaults = UserDefaults.standard

     
        subControllers = [vc1!, vc2!,vc3!]
        pagerView.hostController = self
        pagerView.reload()
   
    }

    @IBAction func btn_NewRequest(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SL", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "SL_NewRequest")as! SL_NewRequest
        self.navigationController?.pushViewController(vc, animated: true)
        
   }
    
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
    
    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }
    
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(#colorLiteral(red: 0.01568627 , green: 0.2745098, blue: 0.45490196, alpha: 1), for: .selected)
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

extension UIViewController
{
    static func createFromNib_For_SL<T: UIViewController>(storyBoardId: String) -> T?{
        return UIStoryboard(name: "SL", bundle: nil).instantiateViewController(withIdentifier: storyBoardId) as? T
    }
}
