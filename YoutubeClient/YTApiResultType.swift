//
//  YTApiResultType.swift
//  YoutubeClient
//
//  Created by Chen Zerui on 19/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

public enum YTApiResultType: String, Decodable{
    case video="youtube#video", playlist="youtube#playlist"
}
