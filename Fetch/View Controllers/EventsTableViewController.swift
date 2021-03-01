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
    var events: [Event] = []
    lazy var dateFormatter = DateFormatter.dayDateTime
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        fetchEvents()
    }
    
    private func fetchEvents() {
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
}

