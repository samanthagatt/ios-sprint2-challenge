//
//  ShoppingItemController.swift
//  Shopping List
//
//  Created by Samantha Gatt on 8/3/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import Photos

class ShoppingItemController {
    
    // Loads the shoppingItems array from the url whenever an instance of ShoppingItemController is initialized
    init() {
        loadFromPersistentStore()
    }
    
    
    // MARK: - Properties
    
    var shoppingItems: [ShoppingItem] = []
    
    
    // MARK: - Functions
    
    func updateIsAdded(item: ShoppingItem) {
        guard let index = shoppingItems.index(of: item) else { return }
        shoppingItems[index].isAdded = !item.isAdded
        
    }
    
    
    // MARK: - Persistence
    
    // Set up the url where shoppingItems are being saved
    var shoppingItemsURL: URL? {
        let fm = FileManager.default
        let fileName = "ShoppingItems.plist"
        guard let docDir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let shoppingListDir = docDir.appendingPathComponent(fileName)
        return shoppingListDir
    }
    
    
    func saveToPersistentStore() {
        guard let url = shoppingItemsURL else { return }
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(shoppingItems)
            try data.write(to: url)
        } catch {
            NSLog("Error saving data: \(error)")
        }
    }
    
    func loadFromPersistentStore() {
        guard let url = shoppingItemsURL else { return }
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: url)
            let decoded = try decoder.decode([ShoppingItem].self, from: data)
            shoppingItems = decoded
        } catch {
            NSLog("Error loading Data: \(error)")
        }
    }
    
    func saveGivenItemsToPersistentStore() {
        let itemNames = ["apple", "grapes", "milk", "muffin", "popcorn", "soda", "strawberries"]
        for item in itemNames {
            guard let image = UIImage(named: item),
                let imageData = UIImagePNGRepresentation(image) else {
                    return
            }
            let shoppingItem = ShoppingItem(name: item, imageData: imageData, isAdded: false)
            shoppingItems.append(shoppingItem)
        }
        saveToPersistentStore()
    }
}
