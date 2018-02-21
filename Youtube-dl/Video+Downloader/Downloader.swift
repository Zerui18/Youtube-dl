//
//  Downloader.swift
//  Youtube-dl
//
//  Created by Chen Zerui on 19/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import Foundation

fileprivate let progressUpdateInterval = 0.5

class Downloader: NSObject, URLSessionDownloadDelegate {
    
    private weak var video: Video!
    
    private var session: URLSession?
    private var task: URLSessionDownloadTask?
    private var timer: Timer?
    
    private var resumeData: Data?
    
    private var bytesWrittenInInterval: Int64 = 0
    
    var downloadSpeedBytes: Double = 0
    var downloadedBytes: Int64 = 0
    var downloadProgress: Double{
        return progress.fractionCompleted
    }
    
    private var progress: Progress{
        return task?.progress ?? Progress()
    }
    
    init(forVideo video: Video) {
        self.video = video
        super.init()
        
        self.session = URLSession(configuration: .background(withIdentifier: "bg_vd_\(video.uniqueId!.uuidString)"), delegate: self, delegateQueue: nil)
    }
    
    func startDownloading() {
        guard task == nil else {
            return
        }
    
        if let resumeData = self.resumeData {
            self.resumeData = nil
            task = session!.downloadTask(withResumeData: resumeData)
        }
        else {
            task = session!.downloadTask(with: video.downloadURL!)
        }
        task!.resume()
        
        timer = Timer.scheduledTimer(withTimeInterval: progressUpdateInterval, repeats: true, block: {_ in
            self.downloadSpeedBytes = Double(self.bytesWrittenInInterval) / progressUpdateInterval
            self.bytesWrittenInInterval = 0
            NotificationCenter.default.post(name: .videoDownloadProgress, object: self.video)
        })
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    func cancelDownloading(saveResumeData flag: Bool = false) {
        if flag{
            task!.cancel(byProducingResumeData: {self.resumeData = $0})
        }
        else{
            task!.cancel()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        bytesWrittenInInterval += bytesWritten
        downloadedBytes = totalBytesWritten
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do{
            try FileManager.default.moveItem(at: location, to: video.localAddress)
        }
        catch{
            self.timer?.invalidate()
            self.timer = nil
            self.task = nil
            
            NotificationCenter.default.post(name: .videoDownloadFailed, object: self.video, userInfo: ["error":error])
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        guard self.task != nil else{
            return
        }
        
        if error == nil{
            NotificationCenter.default.post(name: .videoDownloaded, object: self.video)
        }
        else{
            let err = error! as NSError
            if let data = err.userInfo[NSURLSessionDownloadTaskResumeData] as? NSData{
                self.resumeData = data as Data
            }
            NotificationCenter.default.post(name: .videoDownloadFailed, object: self.video, userInfo: ["error":error!])
        }
        
        self.timer?.invalidate()
        self.timer = nil
        self.task = nil
    }
    
}

extension Notification.Name{
    
    static let videoAdded = Notification.Name("VideoAddedNotiifcation")
    
    static let videoDownloadProgress = Notification.Name("VideoDownloadProgressNotification")
    static let videoDownloaded = Notification.Name("VideoDownloadedNotification")
    static let videoDownloadFailed = Notification.Name("VideoDownloadFailedNotification")
    
}
