//
//  Con_AR.swift
//  LGNew
//
//  Created by Ankit Rana on 10/08/26.
//

import UIKit
import LZViewPager
import SnapKit
class Con_AR: UIViewController , LZViewPagerDelegate, LZViewPagerDataSource{
    
    @IBOutlet weak var btn_newRequest: UIButton!
    @IBOutlet weak var pagerView: LZViewPager!
    private var subControllers:[UIViewController] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Attendance Regularization"
      
        let vc2 = UIViewController.createFromNib_For_AR(storyBoardId: "ODPendingRequestVC")
        vc2!.title = "Approval Pending Details"
        
        let vc3 = UIViewController.createFromNib_For_AR(storyBoardId: "ODArchiveVC")
        vc3!.title = "Archive Details"
     
        subControllers = [vc2!,vc3!]
        pagerView.hostController = self
        pagerView.reload()

   
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
        return .center
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

