//
//  FreeAppViewModel.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2025/1/19.
//

import UIKit

class FreeAppViewModel {
    var freeAppStore: AppStore?
    var index = 0
    
    var iconImage: String {
        return freeAppStore?.feed.results[0].artworkUrl100 ?? ""
    }
    
    var numberLabel: String {
        return String(index + 1)
    }
    
    var appNameLabel: String {
        return freeAppStore?.feed.results[0].name ?? ""
    }
    
    var appDescripionLabel: String {
        return freeAppStore?.feed.results[0].artistName ?? ""
    }
    
    init(freeAppStore: AppStore) {
        self.freeAppStore = freeAppStore
    }
}
