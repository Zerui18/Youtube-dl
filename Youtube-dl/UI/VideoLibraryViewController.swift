//
//  LibraryViewController.swift
//  Youtube-dl
//
//  Created by Chen Zerui on 19/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import UIKit

class VideoLibraryViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        collectionView!.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:))))
    }
    
    private func setupObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(_:)), name: .videoDownloaded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(_:)), name: .videoDownloadFailed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(_:)), name: .videoDownloadProgress, object: nil)
        
        NotificationCenter.default.addObserver(forName: .videoAdded, object: nil, queue: OperationQueue.main) { (notification) in
            self.collectionView!.insertItems(at: [IndexPath(item: VideoLibraryManager.shared.numberOfVideos-1, section: 0)])
        }
        
        NotificationCenter.default.addObserver(forName: .videoRemoved, object: nil, queue: OperationQueue.main) { (notification) in
            let index = notification.userInfo!["index"]! as! Int
            
            self.collectionView!.deleteItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    @objc private func didReceiveNotification(_ notification: Notification) {
        let video = notification.object as! Video
        
        DispatchQueue.main.async {
            guard let cell = self.collectionView!.visibleCells.first(where: {($0 as! SavedVideoCell).video == video}) as? SavedVideoCell else {
                return
            }
            
            cell.video = video
        }
    }
    
    @objc private func longPress(_ sender: UILongPressGestureRecognizer){
        guard sender.state == .began,
            let indexPath = collectionView!.indexPathForItem(at: sender.location(in: collectionView!)) else {
            return
        }
        
        let video = VideoLibraryManager.shared.allVideos[indexPath.item]
        
        let ctr = UIAlertController(title: video.title, message: "", preferredStyle: .alert)
        
        if !video.isDownloaded{
            if video.downloader.isDownloading{
                ctr.message = "downloading"
                ctr.addAction(UIAlertAction(title: "Pause", style: .destructive, handler: {_ in
                    video.downloader.cancelDownloading()
                }))
            }
            else{
                ctr.message = "paused"
                ctr.addAction(UIAlertAction(title: "Resume", style: .default, handler: {_ in
                    video.downloader.resumeDownloading()
                }))
            }
        }
        
        ctr.message = "downloaded"
        ctr.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            VideoLibraryManager.shared.removeVideo(atIndex: indexPath.item)
        }))
        
        ctr.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ctr.present(in: self)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return VideoLibraryManager.shared.numberOfVideos
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedVideoCell", for: indexPath) as! SavedVideoCell
        cell.video = VideoLibraryManager.shared.allVideos[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let video = VideoLibraryManager.shared.allVideos[indexPath.item]
        
        guard video.isDownloaded else {
            return
        }
        
        VideoPlaybackManager.shared.play(video: video)
        
    }

}
