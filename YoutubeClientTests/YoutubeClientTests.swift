//
//  YoutubeClientTests.swift
//  YoutubeClientTests
//
//  Created by Chen Zerui on 17/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import XCTest
@testable import YoutubeClient

class YoutubeClientTests: XCTestCase {

    func testSearch(){
        let query = "abc"
        let g = DispatchGroup()
        g.enter()
        YTClient.search(forQuery: query) { (response, items, error)  in
            print(error)
            print(response)
            print(items)
            g.leave()
        }
        g.wait()
    }
    
    func testGetVideo(){
        let id = "7KPcfdbVTic"
        let g = DispatchGroup()
        g.enter()
        YTClient.getVideo(forIds: [id]) { (response, error) in
            print(error)
            print(response)
            g.leave()
        }
        g.wait()
    }
    
}
