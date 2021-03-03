//
//  EventsTableViewController.swift
//  Fetch
//
//  Created by scott harris on 2/27/21.
//

import UIKit

class EventsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let apiController = APIController()
    let searchController = UISearchController(searchResultsController: nil)
    var events: [Event] = []
    lazy var dateFormatter = DateFormatter.dayDateTime
    var searchTask: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if #available(iOS 13, *) {
            configureNavbarAppearance()
        }
        tableView.dataSource = self
        configureSearchController()
        fetchEvents()
    }
    
    private func fetchEvents(searchText: String? = nil) {
        if let searchText = searchText, !searchText.isEmpty {
            apiController.fetchAllEvents(search: searchText) { (result) in
                switch result {
                case .success(let events):
                    self.events = events
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print("There was an error")
                    print(error)
                }
            }
            
        } else {
            apiController.fetchAllEvents { (result) in
                switch result {
                case .success(let events):
                    self.events = events
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print("There was an error")
                    print(error)
                }
            }
        }
    }
    
    @available(iOS 13, *)
    private func configureNavbarAppearance() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(red: 40/255, green: 53/255, blue: 67/255, alpha: 1)
        
        navBarAppearance.shadowImage = nil
        navBarAppearance.shadowColor = nil
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
    }
    
    private func configureSearchController() {
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Events"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        // 6
        searchController.searchBar.delegate = self
        searchController.searchBar.barStyle = .black
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.isTranslucent = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        
    }
}


extension EventsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventTableViewCell else { return UITableViewCell() }
        
        let event = events[indexPath.row]
        cell.dateFormatter = dateFormatter
        cell.event = event
        
        return cell
    }
    
    private func search(text: String) {
        self.fetchEvents(searchText: text)
    }
}

extension EventsTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        searchBarSearchButtonClicked(searchController.searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Check for non empty text
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        
        // Cancel previous task if any
        self.searchTask?.cancel()
        
        // Replace previous task with a new one
        let task = DispatchWorkItem { [weak self] in
            self?.search(text: searchText)
        }
        self.searchTask = task
        
        // Execute task in 0.25 seconds (if not cancelled !)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: task)
    }
}

