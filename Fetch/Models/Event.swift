//
//  Event.swift
//  Fetch
//
//  Created by scott harris on 2/27/21.
//

import Foundation

struct Event: Decodable {
    let id: Int
    let title: String
    let dateTime: Date
    let eventType: String
    let venue: Venue
    let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case dateTime = "datetime_local"
        case eventType = "type"
        case venue
        case performers
        case imageURL
        
        enum PerformerCodingKeys: String, CodingKey {
            case image
        }
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        dateTime = try container.decode(Date.self, forKey: .dateTime)
        eventType = try container.decode(String.self, forKey: .eventType)
        venue = try container.decode(Venue.self, forKey: .venue)
        
        var performersContainerArray = try container.nestedUnkeyedContainer(forKey: .performers)
        var performersImageArray: [String] = []
        while !performersContainerArray.isAtEnd {
            let performerContainer = try performersContainerArray.nestedContainer(keyedBy: CodingKeys.PerformerCodingKeys.self)
            let imageURL = try performerContainer.decode(String.self, forKey: .image)
            performersImageArray.append(imageURL)
        }
        guard let imageURLString = performersImageArray.first else {
            throw DecodingError.dataCorruptedError(in: performersContainerArray, debugDescription: "Performers cannot be empty")
        }
        
        imageURL = URL(string: imageURLString)!
        
    }
    
}

struct EventWrapper: Decodable {
    let events: [Event]
}
