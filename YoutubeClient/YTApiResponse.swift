//
//  YTApiResponse.swift
//  YoutubeClient
//
//  Created by Chen Zerui on 17/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

public struct YTApiResponse<ItemType: Decodable>: Decodable{
    
    private var nextPageToken: String?
    public var hasNextPage: Bool{
        return nextPageToken != nil
    }
    
    public let pageInfo: PageInfo
    
    public struct PageInfo: Codable{
        public let totalResults: Int
        public let resultsPerPage: Int
        
        public var pageCount: Int{
            let (quo, rem) = totalResults.quotientAndRemainder(dividingBy: resultsPerPage)
            return quo + min(rem, 1)
        }
    }
    
    public let items: [ItemType]
    
    enum CodingKeys: String, CodingKey{
        case nextPageToken, pageInfo, items
    }
    
    public func getNextPage(forQuery query: String, onComplete handler2: @escaping YTListResponseHandler){
        YTClient.search(forQuery: query, pageToken: nextPageToken, onComplete: handler2)
    }
    
}
