//
//  YTApiRequestConstructor.swift
//  YoutubeClient
//
//  Created by Chen Zerui on 17/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

fileprivate func getKey()-> String{
    return "AIzaSyD04fjTvzLPo1fM-GGstwgssrmwtFf8rok"
}

struct YTApiRequestConstructor{
    
    static func searchRequest(forQuery query: String, pageToken: String?=nil)-> URLRequest{
        let url = URL(string: "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=25&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&fields=items(id(kind%2CplaylistId%2CvideoId)%2Csnippet(channelTitle%2Cdescription%2CpublishedAt%2Cthumbnails%2Fhigh%2Furl%2Ctitle))%2CnextPageToken%2CpageInfo%2CprevPageToken&key=\(getKey())\(pageToken != nil ? "&pageToken=\(pageToken!)":"")")!
        return URLRequest(url: url)
    }
    
    static func videoListRequest(forId id: String)-> URLRequest{
        let url = URL(string: "https://www.googleapis.com/youtube/v3/videos?part=snippet&id=\(id)&fields=items(snippet(channelTitle%2Cdescription%2CpublishedAt%2Ctitle))%2CpageInfo&key=\(getKey())")!
        return URLRequest(url: url)
    }
    
    static func playlistListRequest(forId id: String)-> URLRequest{
        let url = URL(string: "https://www.googleapis.com/youtube/v3/playlists?part=snippet&id=\(id)&fields=items(snippet(channelTitle%2Cdescription%2CpublishedAt%2Cthumbnails%2Fhigh%2Furl%2Ctitle))&key=\(getKey())")!
        return URLRequest(url: url)
    }
    
}
