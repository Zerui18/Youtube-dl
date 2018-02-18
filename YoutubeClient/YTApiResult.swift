//
//  YTApiResult.swift
//  YoutubeClient
//
//  Created by Chen Zerui on 17/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

public struct YTApiResult: Decodable{
    
    public struct Snippet: Decodable{
        
        public let publishedDate: Date
        public let title: String
        public let description: String
        public let channelTitle: String
        
        public enum CodingKeys: String, CodingKey{
            case publishedDate = "publishedAt", title, description, channelTitle
        }
        
    }
    
    public enum ResultType: String, Decodable{
        case video="youtube#video", playlist="youtube#playlist", snippet
    }
    
    public let id: String
    public let type: ResultType
    
    public let snippet: Snippet
    
    public enum CodingKeys: String, CodingKey{
        case id, type="kind", snippet
    }
    
    public init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try? container.decode(String.self, forKey: .id){
            self.id = id
            self.type = try container.decode(ResultType.self, forKey: .type)
        }
        else{
            let idDict = try container.decode([String:String].self, forKey: .id)
            self.id = idDict["videoId"] ?? idDict["playlistId"]!
            self.type = ResultType(rawValue: idDict["kind"]!)!
        }
        
        self.snippet = try container.decode(Snippet.self, forKey: .snippet)
    }
    
}
