//
//  SavedVideoCell.swift
//  Youtube-dl
//
//  Created by Chen Zerui on 19/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import UIKit

class SavedVideoCell: UICollectionViewCell {
    
    var video: Video! {
        didSet {
            if video != oldValue{
                loadYTThumbnail(forId: video.youtubeId!, into: thumbnailView)
                titleLabel.text = video.title!
                durationLabel.text = video.durationFormatted
            }
            
            speedLabel.isHidden = video.isDownloaded
            progressView.isHidden = video.isDownloaded
            
            if video.isDownloaded{
                sizeLabel.text = video.sizeFormatted ?? ""
            }
            else{
                sizeLabel.text = formatByte(count: video.downloader.downloadedBytes)
                speedLabel.text = formatByte(count: Int64(video.downloader.downloadSpeedBytes*2)) + "/s"
                progressView.setProgress(Float(video.downloader.downloadProgress), animated: false)
            }
        }
    }
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    
}
