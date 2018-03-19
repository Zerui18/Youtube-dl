//
//  String+Extension.swift
//  YoutubeClient
//
//  Created by Chen Zerui on 18/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

extension String{
    
    func queryDict()-> [String : String]?{
        let keyValuePairs: [(String, String)] = components(separatedBy: "&").compactMap{
            let parts = $0.components(separatedBy: "=")
            guard parts.count == 2 else{
                return nil
            }
            
            return (parts[0].removingPercentEncoding!, parts[1].removingPercentEncoding!)
        }
        return Dictionary(uniqueKeysWithValues: keyValuePairs)
    }
    
}
