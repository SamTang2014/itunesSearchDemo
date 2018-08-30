//
//  API.swift
//  itunesSearchDemo
//
//  Created by Sam Tang on 30/8/2018.
//  Copyright © 2018年 digisalad. All rights reserved.
//

import UIKit

class API {
    
     typealias failHandler = (Error) -> Void
    
    static func searchMusic(
        keyword: String,
        onResponse: @escaping () -> Void,
        onSuccess: @escaping (ItunesResponse) -> Void, onFailure: @escaping failHandler){
    
        
        NetworkHelper.get(params:["term":keyword,"entity":"song"],
        
        onResponse: {
            onResponse()
        },
                          
        onSuccess: { (response) in
            
            print("*** API Level ***")
            print("*** searchMusic Method onSuccess ***")
         
            let itunesResponse = ItunesResponse.init(json: response)
            
            onSuccess(itunesResponse)
            
        },onFailure: { (error) in
            print("*** searchMusic Method onFailure ***")
            
            onFailure(error)
        }
        )
        
    }

}
