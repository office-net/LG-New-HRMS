//  NetworkManager.swift
//  OfficeNetTMS
//  Created by Netcommlabs on 31/08/22.


import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class Networkmanager {

    private static func makeTrustManager() -> ServerTrustManager {
        let evaluator = SSLPublicKeyTrustEvaluator(pinnedHashes: APIConstants.allowedSPKIHashes)
        return ServerTrustManager(
     
            allHostsMustBeEvaluated: true,
            evaluators: [APIConstants.pinnedHost: evaluator]
        )
    }

    private static let session: Session = {
        let trustManager = makeTrustManager()
        
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = APIConstants.requestTimeout
        
        return Session(configuration: configuration, serverTrustManager: trustManager)
    }()

    private static func injectToken(into parameters: [String: Any]) -> [String: Any] {
        var updatedParameters = parameters
        
        if let dynamicToken = UserDefaults.standard.string(forKey: APIConstants.tokenUserDefaultsKey) {
            updatedParameters[APIConstants.tokenParameterKey] = dynamicToken
            Logger.api("Dynamic Token Injected")
        } else {
            Logger.api("TokenNo not found in UserDefaults", level: .warning)
        }
        
        return updatedParameters
    }

    class func postRequest(vv: UIView,
                           remainingUrl: String,
                           parameters: [String: Any],
                           completion: @escaping ((_ data: JSON, _ responseData: Foundation.Data) -> Void)) {
        
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: vv)
        
        let finalParameters = injectToken(into: parameters)
        let completeURLString = APIConstants.baseURL + remainingUrl
        
        Logger.api("Parameters Posted: \(finalParameters)")
        Logger.api("Complete URL: \(completeURLString)")
 
        guard URL(string: completeURLString) != nil else {
            let error = NetworkError.invalidURL(completeURLString)
            Logger.api(error.localizedDescription, level: .error)
            CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: vv)
            return
        }
        
        session.request(completeURLString,
                        method: .post,
                        parameters: finalParameters,
                        encoding: JSONEncoding.default)
        .responseDecodable(of: JSON.self) { response in
            
            CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: vv)
            
            switch response.result {
            case .success(let value):
                Logger.api("Success Response", level: .success)
                
                guard let data = response.data else {
                    Logger.api(NetworkError.noData.localizedDescription, level: .error)
                    return
                }
                
                let swiftyJsonVar = JSON(value)
                completion(swiftyJsonVar, data)
                
            case .failure(let afError):
                let mappedError = NetworkError.from(afError)
                Logger.api("Request failed: \(mappedError.localizedDescription)", level: .error)
                if case .sslPinningFailed(let sslError) = mappedError {
                    Logger.ssl("Blocked insecure connection: \(sslError.localizedDescription)", level: .error)
                }
            }
        }
    }
}



















class Networkmanager2
{
    class func postRequest(remainingUrl:String, parameters: [String:Any], completion: @escaping ((_ data: JSON, _ responseData:Foundation.Data) -> Void)) {
        print("parameters posted : ",parameters)
        let completeUrl = base.url + remainingUrl
        print ("complete url : ", completeUrl)
        AF.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self) { response in
                guard let data = response.data else { return }
                switch response.result
                {
                case .success(let value):
                    let swiftyJsonVar = JSON(value)
                    completion(swiftyJsonVar, data)
                case.failure(let error):
                    print(error.localizedDescription)
                }
                
            }
    }
    
}

