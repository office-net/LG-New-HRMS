//
//  GalleryVC.swift
//  Myomax officenet
//
//  Created by Mohit Shrama on 21/06/20.
//  Copyright © 2020 Mohit Sharma. All rights reserved.
//

import UIKit


class GalleryVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var arrGalleryCategoryList = [String]() as? NSMutableArray

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Gallery"
        collectionView.delegate = self
        collectionView.dataSource = self
        Gallery_PhotoCategoryListAPI()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(selectorMethod))
        
    }
    @objc func selectorMethod() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        
    }
    
 

    // Service Call
    func Gallery_PhotoCategoryListAPI()  {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)

        var parameters:[String:Any]?
        
        if let PlantID = UserDefaults.standard.object(forKey: "PlantID") as? String {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","PlantID":"0"]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","PlantID":"0"]
        }
        
        print(parameters!)
        let url = URL(string: base.url+"Gallery_PhotoCategoryList")! //change the url
        //create the session object
        print(url)
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
extension GalleryVC : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrGalleryCategoryList?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as! galleryCell
      
        
        if let dic =  self.arrGalleryCategoryList?[indexPath.row] as? NSDictionary {
            cell.lblName.text = dic.value(forKey: "GalleryCategoryTitleName") as? String
            
            let EmpImagePath = dic.value(forKey: "ImagePath") as? String
            cell.imgView?.sd_setImage(with: URL(string:EmpImagePath!), placeholderImage: UIImage())
        }
        return cell
    }
}
extension GalleryVC : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let dic =  self.arrGalleryCategoryList?[indexPath.row] as? NSDictionary
        let storyboard = UIStoryboard(name: "Gallery", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GalleyDetailsVC") as! GalleyDetailsVC
        vc.strCategoryId = (dic?.value(forKey: "GalleryCategoryID") as? String)!
        vc.strName = (dic?.value(forKey: "GalleryCategoryTitleName") as? String)!

        self.navigationController?.pushViewController(vc, animated: true)
       
    }
}

extension GalleryVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 2
        let hardCodedPadding:CGFloat = 20
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 10)
    }
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


class galleryCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
   
}
