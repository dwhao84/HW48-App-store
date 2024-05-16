//
//  iTunesModel.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2024/5/17.
//

import UIKit

struct iTunes: Codable {
    let resultCount: Int
    let results: [Results]
}

struct Results: Codable {
    let screenshotUrls: [String]
    let ipadScreenshotUrls: [String]
    let artworkUrl60: String
    let artworkUrl512: String
    let supportedDevices: [String]
    let releaseNotes: String
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case price              = "price"
        case screenshotUrls     = "screenshotUrls"
        case ipadScreenshotUrls = "ipadScreenshotUrls"
        case artworkUrl60       = "artworkUrl60"
        case artworkUrl512      = "artworkUrl512"
        case supportedDevices   = "supportedDevices"
        case releaseNotes       = "releaseNotes"
    }
}
