//
//  FavoriteController.swift
//  Fetch
//
//  Created by scott harris on 3/5/21.
//

import Foundation

class FavoriteComtroller {
    private let favoritePersistenceFileName = "FavoriteLibrary.plist"
    private var favoriteLibraryURL: URL?{
        let fileManager = FileManager.default
        guard let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        let listURL = documentsDir.appendingPathComponent(favoritePersistenceFileName)
        return listURL
    }
    
    var favorites: [Int: Event] = [:]
    
    init() {
        loadFromPersistentStore()
    }
    
    func addToFavorites(event: Event) {
        let id = event.id
        favorites[id] = event
        saveToPersistentStore()
    }
    
    func removeFromFavorites(event: Event) {
        let id = event.id
        favorites.removeValue(forKey: id)
        saveToPersistentStore()
    }
    
    // Persistence
    private func saveToPersistentStore(){
        
        guard let favoriteLibraryURL = favoriteLibraryURL else { return }
        
        let encoder = PropertyListEncoder()
        do {
            
            let dictionaryData = try encoder.encode(favorites)
            try dictionaryData.write(to: favoriteLibraryURL)
            
        } catch {
            print("Error encoding favorites: \(error)")
        }
    }
    
    private func loadFromPersistentStore (){
        
        guard let favoriteLibraryURL = favoriteLibraryURL else { return }
        
        do {
            let decoder = PropertyListDecoder()
            let favoriteLibraryData = try Data(contentsOf: favoriteLibraryURL)
            let favoriteLibraryDictionary = try decoder.decode([Int: Event].self, from: favoriteLibraryData)
            favorites = favoriteLibraryDictionary
        } catch {
            print("Error decoding favorites dictionary: \(error)")
        }
    }
    
    
}
