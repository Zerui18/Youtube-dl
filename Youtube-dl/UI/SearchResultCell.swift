//
//  SearchResultCell.swift
//  Youtube-dl
//
//  Created by Chen Zerui on 19/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import UIKit
import Nuke
import YoutubeClient

class SearchResultCell: UITableViewCell {
    
    var result: YTApiListItem! {
        didSet{
            titleLabel.text = result.snippet.title
            
            switch result.type {
            case .video:
                durationLabel.text = result.contentDetails.durationDescription
                
                loadYTThumbnail(forId: result.id, into: thumbnailView)
                
            case .playlist:
                durationLabel.text = String(describing: result.contentDetails.itemCount!) + " videos"
            }
        }
    }
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    

}
