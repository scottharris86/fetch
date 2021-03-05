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
        tableView.delegate = self
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
        
        if let imageData = event.imageData {
            cell.eventImageView.image = UIImage(data: imageData)
        } else {
            loadImage(forCell: cell, forItemAt: indexPath)
        }
        
        return cell
    }
    
    private func loadImage(forCell cell: EventTableViewCell, forItemAt indexPath: IndexPath) {
        var event = events[indexPath.row]
        
        APIController.fetchImage(from: event.imageURL) { (data, error) in
            if let _ = error {
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                        // Cell was reused
                        return
                    }
                    if let image = UIImage(data: data) {
                        // For now we'll just cache the image data on the model itself
                        event.setImageData(data: data)
                        // Then replace model in our local events array because we mutated it
                        self.events[indexPath.row] = event
                        // Update the image view with our image
                        cell.eventImageView.image = image
                        
                    }
                    
                }
            }
        }
    }
    
    
    private func search(text: String) {
        self.fetchEvents(searchText: text)
    }
}

extension EventsTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        let detailVC = EventDetailViewController()
        detailVC.event = event
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true)
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
        
        // Assign task to property
        self.searchTask = task
        
        // Execute task in 0.25 seconds (if not cancelled !)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: task)
    }
}
