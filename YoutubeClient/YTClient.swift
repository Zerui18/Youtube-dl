//
//  YTClient.swift
//  YoutubeClient
//
//  Created by Chen Zerui on 17/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

typealias YTSearchResponseHandler = (YTApiResponse<YTApiSearchItem>?, Error?)-> Void
public typealias YTListResponseHandler = (YTApiResponse<YTApiSearchItem>?, [YTApiListItem]?, Error?)-> Void

public struct YTClient{
    
    public static func search(forQuery query: String, pageToken: String? = nil, onComplete handler: @escaping YTListResponseHandler){
        let request = YTApiRequestConstructor.searchRequest(forQuery: query, pageToken: pageToken)
        
        request.loadAndSerialize{(response: YTApiResponse<YTApiSearchItem>!, error) in
            guard error == nil else{
                handler(nil, nil, error)
                return
            }
            
            let typeToItems = [YTApiResultType:[YTApiSearchItem]](grouping: response.items, by: {$0.id.type})
            
            var results1: [YTApiListItem]?, results2: [YTApiListItem]?
            var error: Error?
            
            var taskCount = 0
            var returnCount = 0
            
            let queue = DispatchQueue(label: "access_queue")
            
            func checkForCompletion(){
                guard taskCount == returnCount else{
                    return
                }
                
                if error != nil{
                    handler(nil, nil, error)
                }
                else{
                    handler(response, (results2 ?? [])+(results1 ?? []), nil)
                }
            }
            
            if let videos = typeToItems[.video]{
                taskCount += 1
                getVideo(forIds: videos.map{$0.id.videoId!}, completion: { (response, err) in
                    queue.async {
                        if err != nil{
                            error = err
                        }
                        else{
                            results1 = response?.items.filter{
                                $0.contentDetails.durationDouble > 0.0
                            }
                        }
                        returnCount += 1
                        checkForCompletion()
                    }
                })
            }
            if let playlists = typeToItems[.playlist]{
                taskCount += 1
                getPlaylist(forIds: playlists.map{$0.id.playlistId!}, completion: { (response, err) in
                    queue.async {
                        if err != nil{
                            error = err
                        }
                        else{
                            results2 = response?.items
                        }
                        returnCount += 1
                        checkForCompletion()
                    }
                })
            }
            
        }
    }
    
    public static func getVideo(forIds ids: [String], completion: @escaping (YTApiResponse<YTApiListItem>?, Error?)-> Void){
        let request = YTApiRequestConstructor.videoListRequest(forIds: ids)
        
        request.loadAndSerialize(completion: completion)
    }
    
    public static func getPlaylist(forIds ids: [String], completion: @escaping (YTApiResponse<YTApiListItem>?, Error?)-> Void){
        let request = YTApiRequestConstructor.playlistListRequest(forIds: ids)
        
        request.loadAndSerialize(completion: completion)
    }
    
}

