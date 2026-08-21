


import UIKit

class TabVC: UITabBarController {
    let gradientlayer = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.layer.backgroundColor = base.secondcolor.cgColor
        self.selectedIndex = 0
      
        setGradientBackground(colorOne: base.secondcolor, colorTwo: base.firstcolor)
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
        if Language == "English"
            {
            self.tabBar.items![1].title = "Home"
            self.tabBar.items![1].title = "Alerts"
            self.tabBar.items![2].title = "Notification"
            self.tabBar.items![3].title = "Log Out"
           
        }
            else
            {
                self.tabBar.items![1].title = "होम"
                self.tabBar.items![1].title = "अलर्ट"
                self.tabBar.items![2].title = "सूचनाएं"
                self.tabBar.items![3].title = "लॉग आउट"
                
               
            }
        }
      
    }
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor)  {
                gradientlayer.frame = tabBar.bounds
                gradientlayer.colors = [colorOne.cgColor, colorTwo.cgColor]
                gradientlayer.locations = [0, 1]
                gradientlayer.startPoint = CGPoint(x: 1.0, y: 0.0)
                gradientlayer.endPoint = CGPoint(x: 0.0, y: 0.0)
                self.tabBar.layer.insertSublayer(gradientlayer, at: 0)
            }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setGradientBackground(colorOne: base.secondcolor, colorTwo: base.firstcolor)
        tabBar.frame.size.height = 40
        tabBar.frame.origin.y = view.frame.height - 40
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       //
    }

}
class background: UITabBar {
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
