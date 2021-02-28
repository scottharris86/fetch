//
//  Event.swift
//  Fetch
//
//  Created by scott harris on 2/27/21.
//

import Foundation

struct Event: Codable {
    let id: Int
    let title: String
    let dateTime: Date
    let eventType: String
    let venue: Venue
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case dateTime = "datetime_local"
        case eventType = "type"
        case venue
    }
    
}

struct EventWrapper: Codable {
    let events: [Event]
}
