//
//  VideoPlaybackManager.swift
//  U_Downloader
//
//  Created by Chen Changheng on 2/7/17.
//  Copyright © 2017 Chen Zerui. All rights reserved.
//

import Nuke
import AVKit
import MediaPlayer

class VideoPlaybackManager{
    
    private init(){

        MPRemoteCommandCenter.shared().playCommand.addTarget {_ in
            self.player.play()
            return .success
        }
        MPRemoteCommandCenter.shared().pauseCommand.addTarget {_ in
            self.player.pause()
            return .success
        }
        MPRemoteCommandCenter.shared().skipForwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.player.seek(to: CMTimeMake(Int64(self.player.currentTime().seconds+(event as! MPSkipIntervalCommandEvent).interval), 1), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            return .success
        }
        MPRemoteCommandCenter.shared().skipBackwardCommand.addTarget  { (event) -> MPRemoteCommandHandlerStatus in
            self.player.seek(to: CMTimeMake(Int64(self.player.currentTime().seconds-(event as! MPSkipIntervalCommandEvent).interval), 1), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            return .success
        }
        MPRemoteCommandCenter.shared().changePlaybackPositionCommand.addTarget { (event) in
            self.player.seek(to: CMTimeMake(Int64((event as! MPChangePlaybackPositionCommandEvent).positionTime), 1), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            return .success
        }
        self.player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: DispatchQueue.main) { (time) in
            MPNowPlayingInfoCenter.default().nowPlayingInfo?.updateValue(time.seconds, forKey: MPNowPlayingInfoPropertyElapsedPlaybackTime)
        }
    }
    
    static let shared: VideoPlaybackManager = VideoPlaybackManager()
    
    weak private var currentPlayerController: AVPlayerViewController?
    
    private var currentPlayingVideo: Video?{
        didSet{
            if let video = self.currentPlayingVideo{
                MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                    MPMediaItemPropertyTitle: video.title!,
                    MPMediaItemPropertyArtist: video.channelTitle!,
                    MPMediaItemPropertyArtwork: MPMediaItemArtwork(boundsSize: CGSize(width: 480, height: 270), requestHandler:  {_ in
                        Manager.shared.cache![Request(url: URL(string: "https://i.ytimg.com/vi/\(video.youtubeId!)/hqdefault.jpg")!)] ?? UIImage()
                    }),
                    MPMediaItemPropertyPlaybackDuration: video.duration,
                    MPNowPlayingInfoPropertyElapsedPlaybackTime:  self.player.currentTime().seconds
                ]
            }
            else{
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            }
        }
    }
    
    private var player: AVPlayer = AVPlayer()
    
    
    private func _play(video: Video){
        self.currentPlayingVideo = video
        self.player.replaceCurrentItem(with: AVPlayerItem(url: video.localAddress))
        self.player.seek(to: CMTimeMake(Int64(video.watchedDuration), 1), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        let ctr = AVPlayerViewController()
        ctr.updatesNowPlayingInfoCenter = false
        ctr.player = self.player
        ctr.present(in: AppDelegate.shared.topViewControler!)
        self.currentPlayerController = ctr
        
    }
    
    func play(video: Video){
        if let current = self.currentPlayerController{
            current.dismiss(animated: false, completion: {
                self._play(video: video)
            })
        }
        else{
            self._play(video: video)
        }
    }
    
}
