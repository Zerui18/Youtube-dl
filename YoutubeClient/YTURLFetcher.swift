//
//  YTURLFetcher.swift
//  YoutubeClient
//
//  Created by Chen Zerui on 18/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

public struct YTURLFetcher{
    
    public enum LoadVideoError: Error{
        case noNetwork, providerError(String), decodingFailed(String), unknown
        
        var localizedDescription: String{
            switch self{
            case .noNetwork:
                return "The Internet connection appears to be offline."
            case .providerError(let description):
                return "Youtube returned an error \"\(description)\"."
            case .decodingFailed(let reason):
                return "Failed to decode response data with reason \"\(reason)\"."
            case .unknown:
                return "An unknown error occurred."
            }
        }
    }
    
    /**
     Fetch the raw html of the m.youtube video page for the given video-id.
     - parameters:
        - id: id of the video
     - throws: an Error object if fetch is unsuccessful
     - returns: the html of the video page fetched
     */
    static private func fetchMobileVideoPage(forId id: String)throws -> String{
        let url = URL(string: "https://m.youtube.com/watch?v="+id)!
        var request = URLRequest(url: url)
        request.setValue("User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 10_3 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.3 Mobile/14E277 Safari/603.1.30", forHTTPHeaderField: "User-Agent")
        do{
            let data = try request.send()
            return String(data: data, encoding: .utf8)!
        }
        catch{
            throw LoadVideoError.noNetwork
        }
    }
    
    /**
     Extracts the player info in JSON from the raw html of a m.youtube video page.
     - parameters:
        - html: raw html of the page
     - throws: an Error object if extraction fails
     - returns: the player info as a JSON
     */
    static private func extractPlayerInfo(fromHTML html: String)throws -> [String:Any]{
        // extract json literal
        var jsonExtract = html.components(separatedBy: "bootstrap_data = \")]}'")[1]
        jsonExtract = jsonExtract.components(separatedBy: "\";")[0]
        
        // remove extraneous escapes
        jsonExtract = jsonExtract.replacingOccurrences(of: "\\\"", with: "\"")
        jsonExtract = jsonExtract.replacingOccurrences(of: "\\\\\"", with: "\\\"")
        jsonExtract = jsonExtract.replacingOccurrences(of: "\\\\\\/", with: "/")
        
        do{
            return try JSONSerialization.jsonObject(with: jsonExtract.data(using: .utf8)!, options: []) as! [String:Any]
        }
        catch{
            throw LoadVideoError.decodingFailed("json decoding failed")
        }
    }
    
    /**
     Fetch and extract video direct stream urls for the given video-id.
     - parameters:
        - id: id of the video
     - throws: an Error object if the pipline fails
     - returns: dictionary of video quality to their url
     */
    static public func getVideoURLs(forId id: String)throws -> [Int:String]{
        
        let html = try fetchMobileVideoPage(forId: id)
        let playerInfoJSON = try extractPlayerInfo(fromHTML: html)
        
        // start extracting relevant information
        guard let args = playerInfoJSON.valAtPath("content.swfcfg.args") as? [String:Any],
            let streamMapRaw = args["url_encoded_fmt_stream_map"] as? String,
            let playerPath = playerInfoJSON.valAtPath("content.swfcfg.assets.js") as? String
            else{
                throw LoadVideoError.decodingFailed("property not found")
        }
        
        let playerURL = URL(string: "https://www.youtube.com" + playerPath)!
        
        let streamMap = streamMapRaw.replacingOccurrences(of: "\\u0026", with: "&").components(separatedBy: ",")
        
        // map streamMap into resultant format
        let qualityToURL: [(Int, String)] = try streamMap.flatMap{
            guard let dict = $0.queryDict(), let itag = Int(dict["itag"]!), let urlString = dict["url"], let quality = translation[itag] else{
                return nil
            }
            
            // check for cipher signature
            let url: String
            if let s = dict["s"]{
                url = urlString + "&signature=" + (try  YTSignatureDecipherer.shared.decipher(sig: s, withPlayer: playerURL))
            }
            else{
                url = urlString
            }
            return (quality, url)
        }
        
        return Dictionary(uniqueKeysWithValues: qualityToURL)
    }
    
}

fileprivate let translation = [
    22:720,
    18:480,
    17:240
]

fileprivate extension Dictionary where Key == String{
    
    fileprivate func valAtPath(_ path: String)-> Any?{
        var val: [String:Any]? = self
        let components = path.components(separatedBy: ".")
        
        if components.count == 0{
            return nil
        }
        
        for key in components[..<(components.count-1)]{
            val = (val?[key] as? [String:Any])
        }
        
        return val?[components.last!]
    }
    
}
