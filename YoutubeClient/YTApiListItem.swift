//
//  YTApiResult.swift
//  YoutubeClient
//
//  Created by Chen Zerui on 17/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

public struct YTApiListItem: Decodable {
    
    public struct ContentDetails: Decodable {
        public var itemCount: Int?
        private var duration: String?
        
        public enum CodingKeys: CodingKey{
            case itemCount, duration
        }
        
        public lazy var durationDouble = parseISO8601Duration(fromString: duration!)
        public lazy var durationDescription = formatDuration(fromDouble: durationDouble)
    }
    
    public struct Snippet: Decodable {
        
        public let publishedDate: Date
        public let title: String
        public let channelTitle: String
        
        public enum CodingKeys: String, CodingKey {
            case publishedDate = "publishedAt", title, channelTitle
        }
        
    }
    
    public var youtubeURL: URL{
        switch type{
        case .video:
            return URL(string: "https://www.youtube.com/watch?v=\(id)")!
        case .playlist:
            return URL(string: "https://www.youtube.com/playlist?list=\(id)")!
        }
    }

    public let id: String
    public let type: YTApiResultType
    
    public var contentDetails: ContentDetails
    public let snippet: Snippet
    
    public enum CodingKeys: String, CodingKey {
        case id, type="kind", snippet, contentDetails
    }
    
}
