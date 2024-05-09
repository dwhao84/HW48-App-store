//
//  AppRankModel.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2024/5/10.
//

import UIKit

/*
 // Paid:
 https://rss.applemarketingtools.com/api/v2/tw/apps/top-paid/25/apps.json
 // Free:
 //https://rss.applemarketingtools.com/api/v2/tw/apps/top-free/25/apps.json
 
 因此若想在列表顯示價錢，必須用 App ID 搭配 iTunes Search API 查詢 App 的詳細資料。
 比方 App ID 是 1164801111，查詢詳細資料的網址如下:
 https://itunes.apple.com/lookup?id=1164801111&country=tw
 */

struct Feed: Codable {
    let title: String
    let id: String
    let author: Author
    let links: [Link]
    let copyright: String
    let country: String
    let icon: String
    let updated: String
    let results: [Result]
}

struct Author: Codable {
    let name: String
    let url: String
}

struct Link: Codable {
    let linksSelf: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

struct Result: Codable {
    let artistName: String
    let id: String
    let name: String
    let releaseDate: String
    let kind: String
    let artworkUrl100: String
    let url: String
}


