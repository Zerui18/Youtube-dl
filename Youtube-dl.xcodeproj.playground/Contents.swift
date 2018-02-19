//: Playground - noun: a place where people can play

import UIKit
import Foundation
import PlaygroundSupport
import YoutubeClient

PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Hello, playground"

YTClient.search(forQuery: "Music", onResults: { (response, error) in
    print(response)
    print(error)
}) { (videos, playlists, error) in
    print(videos)
    print(playlists)
    print(error)
}

