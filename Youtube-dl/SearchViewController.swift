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
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

}

extension SearchViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{
            return
        }
        
        YTClient.search(forQuery: text){ (searchResponse, items, error) in
            if let error = error {
                self.searhFailed(withError: error)
                return
            }
            
            self.responses.append(searchResponse!)
            self.results.append(contentsOf: items!)
        }
    }
    
    private func searhFailed(withError error: Error){
        DispatchQueue.main.async {
            self.alert(title: "Search Failed", message: error.localizedDescription)
        }
    }
    
}
