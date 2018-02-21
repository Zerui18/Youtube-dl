//
//  Constants.swift
//  Youtube-dl
//
//  Created by Chen Zerui on 19/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation
import Nuke

class Constants{
    
    static let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!

}

func loadYTThumbnail(forId videoId: String, into imageView: UIImageView){
    let request = Request(url: URL(string: "https://i.ytimg.com/vi/\(videoId)/hqdefault.jpg")!).processed(key: "", { image in
        let cgImage = image.cgImage!
        let cropped = cgImage.cropping(to: CGRect(x: 0, y: 45, width: 480, height: 270))!
        return UIImage(cgImage: cropped)
    })
    Manager.shared.loadImage(with: request, into: imageView)
}
