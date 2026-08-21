//
//  GalleryShowVC.swift
//  NewOffNet
//
//  Created by Ankit Rana on 22/11/21.
//

import UIKit
import SDWebImage

class GalleryShowVC: UIViewController {
    
    var rana:String!
    var indexpath = 0
    
    
    
    var getGalleryCategoryList = [String]() as? NSMutableArray
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.title = "Images"
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        
        scrollView.delegate = self
        
        
        if let dic =  self.getGalleryCategoryList?[indexpath] as? NSDictionary
        {
            self.imageView?.sd_setImage(with: URL(string:dic["ImagePath"] as! String), placeholderImage: UIImage())
            
            print(getGalleryCategoryList!.count)
        }
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))

        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeLeft)
        
        
        
        
        
    }
    
  
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                if indexpath == getGalleryCategoryList!.count-1
                {
                    print("No More Imnages")
                }
                else
                {
                
                if let dic =  self.getGalleryCategoryList?[indexpath+1] as? NSDictionary
                {
                  
                    
                    self.imageView?.sd_setImage(with: URL(string:dic["ImagePath"] as! String), placeholderImage: UIImage())
                   
                    
                    self.indexpath = indexpath+1
                       
                }
                    
                }
                
            case UISwipeGestureRecognizer.Direction.right:
                if indexpath == 0
                {
                    print(indexpath)
                }
                else
                {
                if let dic =  self.getGalleryCategoryList?[indexpath-1] as? NSDictionary
                {
                 self.imageView?.sd_setImage(with: URL(string:dic["ImagePath"] as! String), placeholderImage: UIImage())
                    self.indexpath = indexpath-1
                }
                }
                
            default:
                break
            }
        }
    }
    
    
    
}

extension GalleryShowVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > imageView.frame.height
                
                let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
                
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
