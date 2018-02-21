//
//  Video+Properties.swift
//  Youtube-dl
//
//  Created by Chen Zerui on 19/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import CoreData

extension Video {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Video> {
        return NSFetchRequest<Video>(entityName: "Video")
    }
    
    @NSManaged public var channelTitle: String?
    @NSManaged public var downloadURL: URL?
    @NSManaged public var duration: Double
    @NSManaged public var title: String?
    @NSManaged public var uniqueId: UUID?
    @NSManaged public var watchedDuration: Double
    @NSManaged public var youtubeId: String?
    
}
