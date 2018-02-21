//
//  GlobalFunctions.swift
//  Youtube-dl
//
//  Created by Chen Zerui on 19/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import UIKit

func formatDuration(fromDouble timeInterval: Double) -> String {
    
    var seconds = timeInterval
    let hours = floor(seconds / 3600)
    seconds -= hours * 3600
    let minutes = floor(seconds / 60)
    seconds -= minutes * 60
    
    return String(format: "%d:%02d:%02d", Int(hours), Int(minutes), Int(minutes))
}

func parseISO8601Duration(fromString string: String)-> Double {
    let nsISO8601 = NSString(string: string)
    
    var hours = 0, minutes = 0, seconds = 0
    var i = 0
    
    while i < nsISO8601.length  {
        
        var str = nsISO8601.substring(with: NSRange(location: i, length: nsISO8601.length - i))
        
        i += 1
        
        if str.hasPrefix("P") || str.hasPrefix("T") { continue }
        
        let scanner = Scanner(string: str)
        var value = 0
        
        if scanner.scanInt(&value) {
            
            i += scanner.scanLocation - 1
            
            str = nsISO8601.substring(with: NSRange(location: i, length: nsISO8601.length - i))
            
            i += 1
            
            if str.hasPrefix("H") {
                hours = value
            } else if str.hasPrefix("M") {
                minutes = value
            } else if str.hasPrefix("S") {
                seconds = value
            }
        }
    }
    
    let secondsTotal = Double(hours * 3600 + minutes * 60 + seconds)
    
    return secondsTotal
}

