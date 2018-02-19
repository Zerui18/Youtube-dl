//
//  YoutubeDecipherer.swift
//  App
//
//  Created by Chen Zerui on 17/1/18.
//

import JavaScriptCore

public class YTSignatureDecipherer{
    
    static public var shared = YTSignatureDecipherer()
    
    public init(){
        loadContext()
    }
    
    private let context = JSContext()!
    private var isContextLoaded = false
    
    private var getChipFunc: JSValue?
    private var runAlgoFunc: JSValue?
    
    private var urlToAlgoCache: [String:[[Any]]] = [:]
    
    private func loadContext(){
        guard !isContextLoaded else{
            return
        }
        
        let str = try! String(contentsOf: Bundle(for: YTSignatureDecipherer.self).url(forResource: "decipher", withExtension: "js")!)
        
        self.context.evaluateScript(str)
        self.getChipFunc = context.objectForKeyedSubscript("getActList")
        self.runAlgoFunc = context.objectForKeyedSubscript("applyActions")
        
        isContextLoaded = true
    }
    
    public func getAlgo(forPlayer url: URL)throws -> [[Any]]{
        // checks if algo exists in cache
        if let algo = urlToAlgoCache[url.absoluteString]{
            return algo
        }
        // load js code, extract algo and place it in cache
        if let player = try? String(contentsOf: url), let re = self.getChipFunc!.call(withArguments: [player]).toArray() as? [[Any]]{
            
            self.urlToAlgoCache[url.absoluteString] = re
            return re
        }
        else{
            // placeholder error
            throw NSError()
        }
    }
    
    public func decipher(sig: String, withPlayer url: URL)throws -> String{
        let algo = try getAlgo(forPlayer: url)
        return self.runAlgoFunc!.call(withArguments: [algo, sig]).toString()
    }
}


