//
//  YTClient.swift
//  YoutubeClient
//
//  Created by Chen Zerui on 17/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

public typealias YTResponseHandler = (YTApiResponse?, Error?)->Void

public struct YTClient{
    
    public static func search(forQuery query: String, pageToken: String? = nil, completion: @escaping YTResponseHandler){
        let request = YTApiRequestConstructor.searchRequest(forQuery: query, pageToken: pageToken)
        
        request.loadAndSerialize(completion: completion)
    }
    
    public static func getVideo(forId id: String, completion: @escaping YTResponseHandler){
        let request = YTApiRequestConstructor.videoListRequest(forId: id)
        
        request.loadAndSerialize(completion: completion)
    }
    
    public static func getPlaylist(forId id: String, completion: @escaping YTResponseHandler){
        let request = YTApiRequestConstructor.playlistListRequest(forId: id)
        
        request.loadAndSerialize(completion: completion)
    }
    
    
    
}

