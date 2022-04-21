//
//  HistoryModel.swift
//  History App
//
//  Created by Samuel Miller on 4/17/22.
//

import Foundation

struct HistoryModel {
    let type: String
    let articles: [Article]?
}

struct Article {
    let title: String
    let description: String
}
