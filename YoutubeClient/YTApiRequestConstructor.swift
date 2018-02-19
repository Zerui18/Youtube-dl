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
        let url = URL(string: "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=25&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&type=video%2Cplaylist&fields=items(id(kind%2CplaylistId%2CvideoId))%2CnextPageToken%2CpageInfo%2CprevPageToken&key=\(getKey())\(pageToken != nil ? "&pageToken=\(pageToken!)":"")")!
        return URLRequest(url: url)
    }
    
    static func videoListRequest(forIds ids: [String])-> URLRequest{
        let url = URL(string: "https://www.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails&id=\(ids.joined(separator: "%2C"))&fields=items(contentDetails%2Fduration%2Cid%2Ckind%2Csnippet(channelTitle%2CpublishedAt%2Ctitle))%2CpageInfo&key=\(getKey())")!
        return URLRequest(url: url)
    }
    
    static func playlistListRequest(forIds ids: [String])-> URLRequest{
        let url = URL(string: "https://www.googleapis.com/youtube/v3/playlists?part=snippet%2CcontentDetails&id=\(ids.joined(separator: "%2C"))&fields=items(contentDetails%2Cid%2Ckind%2Csnippet(channelTitle%2CpublishedAt%2Ctitle))%2CpageInfo&key=\(getKey())")!
        return URLRequest(url: url)
    }
    
}
