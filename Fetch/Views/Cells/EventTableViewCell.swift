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
    @IBOutlet weak var isFavoriteImageView: UIImageView!
    
    var dateFormatter: DateFormatter?
    var isFavorite: Bool?
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let event = event else { return }
        eventImageView.layer.cornerRadius = 8
        
        titleLabel.text = event.title
        locationLabel.text = "\(event.venue.city), \(event.venue.state)"
        if let dateFormatter = dateFormatter {
            dateLabel.text = dateFormatter.string(from: event.dateTime)
        }
        if let isFavorite = isFavorite {
            // Because its defaulted to hidden we need to negate value
            isFavoriteImageView.isHidden = !isFavorite
        }
        
    }
}
