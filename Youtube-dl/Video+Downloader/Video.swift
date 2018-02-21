//
//  Video.swift
//  Youtube-dl
//
//  Created by Chen Zerui on 19/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import CoreData
import YoutubeClient

@objc(Video)
class Video: NSManagedObject {
    
    lazy var localAddress = Constants.downloadsURL.appendingPathComponent(uniqueId!.uuidString+".mp4")
    
    var isDownloaded: Bool {
        return FileManager.default.fileExists(atPath: localAddress.path)
    }
    
    lazy var downloader = Downloader(forVideo: self)
    lazy var sizeFormatted: String? = {
        guard  let size = fileSize(forURL: self.localAddress) else {
            return nil
        }
        return formatByte(count: Int64(size))
    }()
    
    convenience init(fromItem item: YTApiListItem, downloadURL: URL) {
        self.init(context: CoreDataHelper.shared.context)
        
        var itemCopy = item
        
        self.downloadURL = downloadURL
        self.duration = itemCopy.contentDetails.durationDouble
        self.title = itemCopy.snippet.title
        self.uniqueId = UUID()
        self.youtubeId = itemCopy.id
        self.channelTitle = itemCopy.snippet.channelTitle
        
    }
    
    lazy var durationFormatted = formatDuration(fromDouble: duration)
    
}

fileprivate var downloaderKey = 0

fileprivate func fileSize(forURL url: URL)-> UInt64? {
    guard let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) as NSDictionary else {
        return nil
    }
    
    return attributes.fileSize()
}

fileprivate var sizeStrKey = 0
fileprivate let byteFormatter = ByteCountFormatter()

func formatByte(count: Int64)-> String {
    return byteFormatter.string(fromByteCount: count)
}
