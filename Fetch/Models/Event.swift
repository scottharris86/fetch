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
    let imageURL: URL
    var imageData: Data?
    
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(dateTime, forKey: .dateTime)
        try container.encode(eventType, forKey: .eventType)
        try container.encode(venue, forKey: .venue)
        var performersContainerArray = container.nestedUnkeyedContainer(forKey: .performers)
        var performerContainer = performersContainerArray.nestedContainer(keyedBy: CodingKeys.PerformerCodingKeys.self)
        try performerContainer.encode(imageURL.absoluteString, forKey: .image)
    }
    
    mutating func setImageData(data: Data) {
        self.imageData = data
    }
    
}

struct EventWrapper: Decodable {
    let events: [Event]
}
