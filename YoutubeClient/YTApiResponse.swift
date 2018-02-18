//
//  YTApiResponse.swift
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

public struct YTApiResponse: Decodable{
    
    static func decode(from data: Data) throws -> YTApiResponse{
        return try decoder.decode(YTApiResponse.self, from: data)
    }
    
    public var nextPageToken: String?
//    var prevPageToken: String?
    
//    public var hasPrevPage: Bool{
//        return prevPageToken != nil
//    }
    
    public let pageInfo: PageInfo
    
    public struct PageInfo: Codable{
        public let totalResults: Int
        public let resultsPerPage: Int
        
        public var pageCount: Int{
            let (quo, rem) = totalResults.quotientAndRemainder(dividingBy: resultsPerPage)
            return quo + min(rem, 1)
        }
    }
    
    public let items: [YTApiResult]
    
    enum CodingKeys: String, CodingKey{
        case nextPageToken, pageInfo, items
    }
    
}
