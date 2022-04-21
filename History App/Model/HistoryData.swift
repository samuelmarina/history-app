//
//  HistoryData.swift
//  History App
//
//  Created by Samuel Miller on 4/17/22.
//

import Foundation

struct HistoryData: Codable {
    let date: String
    let data: APIData
}

struct APIData: Codable {
    let Events: [ArticleData]
    let Births: [ArticleData]
    let Deaths: [ArticleData]
}

struct ArticleData: Codable {
    let year: String
    let text: String
}

