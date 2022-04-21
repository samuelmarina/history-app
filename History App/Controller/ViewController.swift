//
//  ViewController.swift
//  History App
//
//  Created by Samuel Miller on 4/17/22.
//

import UIKit

class ViewController: UIViewController {
    var historyManager = HistoryManager()
    var histories: [HistoryModel] = []
    
    var date = Date()
    let calendar = Calendar.current

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "02/04/2022"
        label.font = .boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var dateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        return view
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Previous Day", for: .normal)
        button.tintColor = .blue
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next Day", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [previousButton, nextButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorColor = .gray
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyManager.delegate = self
        historyManager.fetchData(month: "04", day: "20")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(dateView)
        view.addSubview(buttonsStackView)
        view.addSubview(tableView)
        
        previousButton.addTarget(self, action: #selector(previousPressed), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        setConstraints()
        setDate()
    }
    
    func setDate(){
        let day = calendar.component(.day, from: date)
        let dayString = day >= 10 ? "\(day)" : "0\(day)"
        let month = calendar.component(.month, from: date)
        let monthString = month >= 10 ? "\(month)" : "0\(month)"
        let year = calendar.component(.year, from: date)
        dateLabel.text = "\(monthString)/\(dayString)/\(year)"
        historyManager.fetchData(month: monthString, day: dayString)
    }
    
    @objc func previousPressed() {
        date = calendar.date(byAdding: .day, value: -1, to: date)!
        setDate()
    }
    
    @objc func nextPressed() {
        date = calendar.date(byAdding: .day, value: 1, to: date)!
        setDate()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            dateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dateView.heightAnchor.constraint(equalToConstant: 50),
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 50),

            buttonsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 20),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
}

extension ViewController: HistoryManagerDelegate {
    func didUpdateDate(_ historyManager: HistoryManager, history: [HistoryModel]) {
        histories = history
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error, "damn")
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return histories.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories[section].articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryCell
        cell.titleLabel.text = histories[indexPath.section].articles?[indexPath.row].title
        cell.bodyLabel.text = histories[indexPath.section].articles?[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return histories[section].type
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HistoryCell
        cell.selectionStyle = .none
    }
}

