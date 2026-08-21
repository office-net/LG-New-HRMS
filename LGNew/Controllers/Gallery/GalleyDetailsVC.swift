//
//  GalleyDetailsVC.swift
//  Myomax officenet
//
//  Created by Mohit Shrama on 21/06/20.
//  Copyright © 2020 Mohit Sharma. All rights reserved.
//

import UIKit



class GalleyDetailsVC: UIViewController {
 
    @IBOutlet weak var collectionView: UICollectionView!
    var strCategoryId = ""
    var strName = ""

    var arrGalleryCategoryList = [String]() as? NSMutableArray

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = strName
        collectionView.delegate = self
        collectionView.dataSource = self
        Gallery_GalleryListAPI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
           
           super.viewWillAppear(animated)
           // CALL API
         self.navigationController?.setNavigationBarHidden(false, animated: true)
           
           self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
           self.navigationController?.navigationBar.shadowImage = UIImage()
           self.navigationController?.navigationBar.isTranslucent = true
           self.navigationController?.navigationBar.tintColor = UIColor.white
           self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = base.firstcolor
           self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
       }
    
    
    // Service Call
    func Gallery_GalleryListAPI()  {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)

        var parameters:[String:Any]?
        
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj","CategoryID":strCategoryId]
       
        let url = URL(string: base.url+"Gallery_GalleryList")! //change the url
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJlbmRlciI6Im5hbmRhbiIsImlhdCI6MTU4MDIwNTI5OH0.ATXxNeOUdiCmqQlCFf0ZxHoNA7g9NrCwqRDET6mVP7k", forHTTPHeaderField:"x-access-token" )
        
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            
            do {
                
               DispatchQueue.main.async {
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                }

                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    let status = json["Status"] as? Int
                    if status == 1 {
                        
                        self.arrGalleryCategoryList = (json["GalleryCategoryList"] as? NSMutableArray)!
                        print("self.GalleryCategoryList",self.arrGalleryCategoryList!)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }else{
                        
                        let Message = json["Message"] as? String
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        // Create the actions
                        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: true)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            
                            self.present(alertController, animated: true)
                        }
                        
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        
    }
}



//###################################
//MARK:-  Collection View Deleagete and DataSource 
//###################################
extension GalleyDetailsVC : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrGalleryCategoryList?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryDetaillCell", for: indexPath) as! galleryDetaillCell
        
        if let dic =  self.arrGalleryCategoryList?[indexPath.row] as? NSDictionary {
            
            let EmpImagePath = dic.value(forKey: "ImagePath") as? String
            cell.imgView?.sd_setImage(with: URL(string:EmpImagePath!), placeholderImage: UIImage())
            
            
        }
        
        // imageView Gesture to view full image
//        cell.imgView.addTapGestureRecognizer {
//            let configuration = ImageViewerConfiguration { config in
//                config.imageView = cell.imgView
//            }
//            let imageViewerController = ImageViewerController(configuration: configuration)
//            self.present(imageViewerController, animated: true)
//        }
      
        return cell
    }
}
extension GalleyDetailsVC : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Gallery", bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "GalleryShowVC")as! GalleryShowVC

            
            vc.indexpath = indexPath.row
            vc.getGalleryCategoryList = self.arrGalleryCategoryList
            
            
        
       
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
}
    
}
extension GalleyDetailsVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 10
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
}

class galleryDetaillCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
   
}

extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
}
