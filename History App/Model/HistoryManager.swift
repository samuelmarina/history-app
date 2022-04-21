//
//  HistoryManager.swift
//  History App
//
//  Created by Samuel Miller on 4/17/22.
//

import Foundation

protocol HistoryManagerDelegate {
    func didUpdateDate(_ historyManager: HistoryManager, history: [HistoryModel])
    func didFailWithError(error: Error)
}

struct HistoryManager {
    let historyURL = "https://history.muffinlabs.com/date/"
    var delegate: HistoryManagerDelegate?
    
    func fetchData(month: String, day: String){
        let urlString = "\(historyURL)\(month)/\(day)"
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let histories = parseJSON(safeData){
                        delegate?.didUpdateDate(self, history: histories)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ historyData: Data) -> [HistoryModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(HistoryData.self, from: historyData)
            return getHistories(decodedData)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    private func getHistories(_ articles: HistoryData) -> [HistoryModel] {
        let data = articles.data
        let events = data.Events.map { Article(title: $0.year, description: $0.text) }
        let births = data.Births.map { Article(title: $0.year, description: $0.text) }
        let deaths = data.Births.map { Article(title: $0.year, description: $0.text) }
        
        return [HistoryModel(type: "Events", articles: events), HistoryModel(type: "Births", articles: births), HistoryModel(type: "Deaths", articles: deaths)]
        
    }
}
