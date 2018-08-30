//
//  NetworkHelper.swift
//  itunesSearchDemo
//
//  Created by Sam Tang on 30/8/2018.
//  Copyright © 2018年 digisalad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD

struct Domain
{
    static let appBaseURL = "https://itunes.apple.com/search?"
}


class NetworkHelper {
    
    typealias successHandler = (JSON) -> Void
    typealias failHandler = (Error) -> Void
    typealias responseHandler = () -> Void
    
//    final var hud = JGProgressHUD(style: .dark)
    
    
    class func get(params:Parameters? ,
                   onResponse:@escaping responseHandler,
                   onSuccess:@escaping successHandler,
                   onFailure:@escaping failHandler
                   ){
        
        
        Alamofire.request(Domain.appBaseURL, method: .get, parameters: params ).responseJSON { response in
            
            print("NetworkHelper Level")
            
            onResponse()
            
            switch response.result {
                
                case .success(let value):
                let json = JSON(value)
                print("*** NetworkHelper-API Call isSuccess ***")
                print("JSON: \(json)")
                onSuccess(json)
                
                case .failure(let error):
                print("*** NetworkHelper-API Call isFailure ***")
                print(error)
                onFailure(error)
                
            }
        
            
        }
    }

    
}
