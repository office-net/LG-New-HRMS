//
//  FacseDedicationVC.swift
//  IOS
//
//  Created by Netcommlabs on 16/11/22.
//

import UIKit
import FaceSDK
class FacseDedicationVC: UIViewController {

    @IBOutlet weak var img1: UIImageView!
  
    
    @IBOutlet weak var similarityLabel: UILabel!
    @IBOutlet weak var img2: UIImageView!
    private enum Position {
        case first
        case second
    }
    
    
    private var firstImage: MatchFacesImage?
    private var secondImage: MatchFacesImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Face Detection"
     
        ankit(.first){ [weak self] (image) in
            self?.img1.image = image?.image
            self?.firstImage = image
        }
        createImageForPosition(.second) { [weak self] (image) in
            self?.img2.image = image?.image
            self?.secondImage = image
            self!.Matching()
        }
    }

    
    
    private func createImageForPosition(_ position: Position, completion: @escaping (MatchFacesImage?) -> Void) {
        
        FaceSDK.service.presentFaceCaptureViewController(
            from: self,
            animated: true,
            onCapture: { response in
                let image = response.image.map {
                    MatchFacesImage(
                        rfsImage: $0
                    )
                }
                completion(image)
            },
            completion: nil
        )
        
        
        
        let imageView: UIImageView
        switch position {
        case .first:
            imageView = img1
        case .second:
            imageView = img2
        }

        
    }
    
}
extension FacseDedicationVC
{
    func Matching()
    {
        guard let firstImage = firstImage, let secondImage = secondImage else {
            self.showAlertWithAction(message: "Having both images is required")
            return
        }

        let request = MatchFacesRequest(images: [firstImage, secondImage])
       

        self.similarityLabel.text = "Processing..."
 
        

        FaceSDK.service.matchFaces(request, completion: { (response: MatchFacesResponse) in
          
           

            if let error = response.error {
                self.similarityLabel.text = "Similarity: \(error.localizedDescription)"
                return
            }

            if let firstPair = response.results.first {
               
                let ab = (firstPair.similarity?.doubleValue ?? 0.0) * 100
                let cd = 80.0
                if ab - cd < 0.00
                {
                   let alertController = UIAlertController(title: base.alertname, message: "Face is Not Matching", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(okAction)
                    DispatchQueue.main.async {
                        
                        self.present(alertController, animated: true)
                    }
                }
                else
                {           let storyboard = UIStoryboard(name: "Attendance", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MarkAttendanceVC")as! MarkAttendanceVC
                    let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
                    vc.UserID = UserID!
                    let EmpCode = UserDefaults.standard.object(forKey: "EmpCode") as? String
                    vc.EmpCode = EmpCode!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                let similarity = String(format: "%.3f", firstPair.similarity?.doubleValue ?? 0.0)
                self.similarityLabel.text = "Similarity: \(similarity)"
                
            } else {
                self.similarityLabel.text = "Similarity: no matched pair found"
            }
        })
    }
}



extension FacseDedicationVC
{
    private func ankit(_ position: Position, completion: @escaping (MatchFacesImage?) -> Void) {
        let imageView: UIImageView
        switch position {
        case .first:
            imageView = img1
        case .second:
            imageView = img2
        }
        let ImageUrl = UserDefaults.standard.object(forKey: "FaceImage") as? String

              let image = UIImage(url: URL(string:ImageUrl!))
                            let result = image.map {
                                MatchFacesImage(
                                    image: $0,
                                    imageType: .live
                                )
                            }
                             completion(result)
            

       
       


  

    }
}



