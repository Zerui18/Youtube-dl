//
//  VideosDataSource.swift
//  Youtube-dl
//
//  Created by Chen Zerui on 19/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation
import YoutubeClient

class VideoLibraryManager{
    
    static let shared = VideoLibraryManager()
    
    var allVideos: [Video]
    
    init(){
        allVideos = CoreDataHelper.shared.fetchAll()
    }
    
    var numberOfVideos: Int {
        return allVideos.count
    }
    
    func addVideo(fromItem item: YTApiListItem, downloadURL: URL)-> Video{
        let video = Video(fromItem: item, downloadURL: downloadURL)
        CoreDataHelper.shared.tryToSave()
        
        allVideos.append(video)
        NotificationCenter.default.post(name: .videoAdded, object: nil)
        return video
    }
    
    func removeVideo(atIndex index: Int){
        let video = allVideos.remove(at: index)
        
        if video.isDownloaded{
            do{
                try FileManager.default.removeItem(at: video.localAddress)
            }
            catch{
                AppDelegate.shared.topViewControler!.alert(title: "Delete Failed", message: error.localizedDescription)
                return
            }
        }
        else{
            video.downloader.cancelDownloading()
        }
        
        CoreDataHelper.shared.context.delete(video)
        CoreDataHelper.shared.tryToSave()
        
        NotificationCenter.default.post(name: .videoRemoved, object: video, userInfo: ["index":index])
    }
    
}
