//
//  ApiController.swift
//  Fetch
//
//  Created by scott harris on 2/27/21.
//

import Foundation

enum NetworkError: Error {
    case NoData
    case NotAuthorized
    case NotFound
    case NoEncode
    case NoDecode
    case NetworkRepsonseError
}

class APIController {
    let baseURL: URL = URL(string: "https://api.seatgeek.com/2/")!
    let clientId: String? = ""
    
    func fetchAllEvents(completion: @escaping (Result<[Event], NetworkError>) -> Void) {
        guard let token = clientId, !token.isEmpty else {
            NSLog("No Auth token in API Controller")
            completion(.failure(.NotAuthorized))
            return
        }
        
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent("events"), resolvingAgainstBaseURL: true)

        let queryParams = [URLQueryItem(name: "client_id", value: token)]
        urlComponents?.queryItems = queryParams
        
        guard let endPointURL = urlComponents?.url else {
            print("bad url")
            completion(.failure(.NetworkRepsonseError))
            return
        }
        
        let request = URLRequest(url: endPointURL)
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Network Response error: \(error)")
                completion(.failure(.NetworkRepsonseError))
                return
            }
            
            guard let data = data else {
                NSLog("No Data Returned")
                completion(.failure(.NoData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Use our own DateFormatter Extension
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let eventsWrapper = try decoder.decode(EventWrapper.self, from: data)
                let events = eventsWrapper.events
                completion(.success(events))
                return
                
            } catch {
                NSLog("Error decoding events: \(error)")
                completion(.failure(.NoDecode))
                return
            }
            
            
        }
        
        task.resume()        
        
    }
    
    static func fetchImage(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error)
                completion(nil, error)
                return
            }
            
            if let data = data {
                completion(data, nil)
                return
            }
        }.resume()
    }
    
}
