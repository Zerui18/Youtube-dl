//
//  URLRequest+Extension.swift
//  YoutubeClient
//
//  Created by Chen Zerui on 17/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

fileprivate let decoder: JSONDecoder = {
    
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
    
    let d = JSONDecoder()
    d.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.formatted(f)
    
    return d
}()

extension URLRequest{
    
    func loadAndSerialize<ResultType: Decodable>(onSession session: URLSession = .shared, completion:@escaping (ResultType?, Error?)->Void){
        session.dataTask(with: self) { (data, _, httpError) in
            guard httpError == nil else{
                completion(nil, httpError)
                return
            }
            
            do{
                completion(try decoder.decode(ResultType.self, from: data!), nil)
            }
            catch let decodeError{
                completion(nil, decodeError)
            }
        }.resume()
    }
    
    /**
     Synchronousely send the receiver on the specified session.
     - parameters:
        - session: a URLSession object on which to send the receiver, defaults to .shared
     - throws: an instance of Error if request send is unsuccessful
     - returns: the data read
     */
    public func send(onSession session: URLSession = .shared)throws -> Data{
        // initialize empty variables
        var error: Error?, data: Data?
        
        let g = DispatchGroup()
        g.enter()
        session.dataTask(with: self) { (_data, _, _error) in
            data = _data
            error = _error
            g.leave()
        }.resume()
        g.wait()
        if error != nil{
            throw error!
        }
        return data!
    }
    
}
