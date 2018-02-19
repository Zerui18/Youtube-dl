//
//  YTApiSearchItem.swift
//  YoutubeClient
//
//  Created by Chen Zerui on 18/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

public struct YTApiSearchItem: Decodable{
    
    public struct Wrapper: Decodable{
        
        public var videoId: String?
        public var playlistId: String?
        public let type: YTApiResultType
        
        public enum CodingKeys: String, CodingKey{
            case videoId, playlistId, type="kind"
        }
    }
    
    public let id: Wrapper
        
}
