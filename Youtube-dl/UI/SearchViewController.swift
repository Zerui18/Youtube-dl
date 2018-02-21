//
//  SearchViewController.swift
//  Youtube-dl
//
//  Created by Chen Zerui on 18/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import UIKit
import YoutubeClient

class SearchViewController: UITableViewController {
    
    var query = ""
    var responses: [YTApiResponse<YTApiSearchItem>] = []
    var results: [YTApiListItem] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    fileprivate var isLoading = false
    fileprivate var lastQuery = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        tableView.tableFooterView = UIView()
    }
    
    fileprivate lazy var resultUpdate: YTListResponseHandler = { (searchResponse, items, error) in
        self.isLoading = false
        
        if let error = error {
            self.searhFailed(withError: error)
            return
        }
        
        let originalCount = self.results.count
        
        self.responses.append(searchResponse!)
        self.results.append(contentsOf: items!)
        
        DispatchQueue.main.async {
            self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
            self.tableView.insertRows(at: (originalCount...self.results.count-1).map{IndexPath(row: $0, section: 0)}, with: .none)
        }
    }

}

extension SearchViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell") as! SearchResultCell
        cell.result = results[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (results.count-(indexPath.row + 1)) < 20 {
            preloadNextBatch()
        }
    }
    
    private func preloadNextBatch(){
        guard !isLoading, responses.last?.hasNextPage ?? false else {
            return
        }
        
        isLoading = true
        responses.last!.getNextPage(forQuery: lastQuery, onComplete: resultUpdate)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let openYoutubeAction = UIContextualAction(style: .normal, title: "Open in Youtube") { (_, _, completion) in
            let item = self.results[indexPath.row]
            UIApplication.shared.open(item.youtubeURL, options: [:], completionHandler: nil)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [openYoutubeAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let downloadAction = UIContextualAction(style: .normal, title: "Download") { (_, _, completion) in
            let item = self.results[indexPath.row]
            completion(true)
            
            guard item.type == .video else {
                return
            }
            
            let alert = UIAlertController(title: "Retrieving URLs", message: "", preferredStyle: .alert)
            alert.present(in: self)
            DispatchQueue.global(qos: .userInitiated).async {
                do{
                    let qualityToURL = try YTURLFetcher.getVideoURLs(forId: item.id)
                    DispatchQueue.main.async {
                        alert.title = "Success"
                        for (quality, url) in qualityToURL {
                            alert.addAction(UIAlertAction(title: "\(quality)p", style: .default, handler: {_ in
                                VideoLibraryManager.shared.addVideo(fromItem: item, downloadURL: URL(string: url)!).downloader.resumeDownloading()
                            }))
                        }
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        alert.title = "Failed"
                        alert.message = error.localizedDescription
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    }
                }
            }
        }
        downloadAction.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [downloadAction])
    }
    
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else{
            return
        }
        
        responses.removeAll()
        results.removeAll()
        tableView.reloadData()
        
        lastQuery = text
        isLoading = true
        YTClient.search(forQuery: text, onComplete: resultUpdate)
    }
    
    private func searhFailed(withError error: Error){
        DispatchQueue.main.async {
            self.alert(title: "Search Failed", message: error.localizedDescription)
        }
    }
    
}
