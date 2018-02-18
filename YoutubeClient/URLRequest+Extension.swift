//
//  URLRequest+Extension.swift
//  YoutubeClient
//
//  Created by Chen Zerui on 17/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

extension URLRequest{
    
    func loadAndSerialize(onSession session: URLSession = .shared, completion:@escaping YTResponseHandler){
        session.dataTask(with: self) { (data, _, httpError) in
            guard httpError == nil else{
                completion(nil, httpError)
                return
            }
            
            do{
                completion(try YTApiResponse.decode(from: data!), nil)
            }
            catch let decodeError{
                completion(nil, decodeError)
            }
        }.resume()
    }
    
}
