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
        public var duration: String?
    }
    
    public struct Snippet: Decodable {
        
        public let publishedDate: Date
        public let title: String
        public let channelTitle: String
        
        public enum CodingKeys: String, CodingKey {
            case publishedDate = "publishedAt", title, channelTitle
        }
        
    }

    public let id: String
    public let type: YTApiResultType
    
    public let contentDetails: ContentDetails
    public let snippet: Snippet
    
    public enum CodingKeys: String, CodingKey {
        case id, type="kind", snippet, contentDetails
    }
    
}

public func parseISO8601Time(iso8601: String) -> String {
    
    let nsISO8601 = NSString(string: iso8601)
    
    var hours = 0, minutes = 0, seconds = 0
    var i = 0
    
    while i < nsISO8601.length {
        
        var str = nsISO8601.substring(with: NSRange(location: i, length: nsISO8601.length - i))
        
        i += 1
        
        if str.hasPrefix("P") || str.hasPrefix("T") { continue }
        
        let scanner = Scanner(string: str)
        var value = 0
        
        if scanner.scanInt(&value) {
            
            i += scanner.scanLocation - 1
            
            str = nsISO8601.substring(with: NSRange(location: i, length: nsISO8601.length - i))
            
            i += 1
            
            if str.hasPrefix("H") {
                hours = value
            } else if str.hasPrefix("M") {
                minutes = value
            } else if str.hasPrefix("S") {
                seconds = value
            }
        }
    }
    
    if hours > 0 {
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }
    
    return String(format: "%d:%02d", minutes, seconds)
    
}
