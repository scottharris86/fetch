//
//  EventsTableViewController.swift
//  Fetch
//
//  Created by scott harris on 2/27/21.
//

import UIKit

class EventsTableViewController: UIViewController {
    var events: [Event] = []
    @IBOutlet weak var tableView: UITableView!
    lazy var dateFormatter: DateFormatter = {
        // EEEE, d MMM yyyy h:mm a
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM yyyy h:mm a"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        let c = APIController()
        c.fetchAllEvents { (result) in
            switch result {
            case .success(let events):
                self.events = events
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
//                print(events)
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
        cell.eventImageView.image = UIImage(named: "basketball")
        cell.eventImageView.layer.cornerRadius = 8
        
        cell.titleLabel.text = event.title
        cell.locationLabel.text = "\(event.venue.city), \(event.venue.state)"
        cell.dateLabel.text = dateFormatter.string(from: event.dateTime)
        
        return cell
    }
}

