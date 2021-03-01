//
//  EventTableViewCell.swift
//  Fetch
//
//  Created by scott harris on 2/28/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var dateFormatter: DateFormatter?
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    
    private func updateViews() {
        guard let event = event else { return }
        downloadImageForEvent()
        eventImageView.layer.cornerRadius = 8
        
        titleLabel.text = event.title
        locationLabel.text = "\(event.venue.city), \(event.venue.state)"
        if let dateFormatter = dateFormatter {
            dateLabel.text = dateFormatter.string(from: event.dateTime)
        }
        
    }
    
    private func downloadImageForEvent() {
        guard let url = event?.imageURL else { return }
        
        APIController.fetchImage(from: url) { (data, error) in
            if let _ = error {
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    self.updateImageView(data: data)
                }
            }
        }
    }
    
    
    private func updateImageView(data: Data) {
        let image = UIImage(data: data)
        eventImageView.image = image
    }
    
}
