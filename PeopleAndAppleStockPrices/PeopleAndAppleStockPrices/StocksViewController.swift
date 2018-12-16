//
//  StocksViewController.swift
//  PeopleAndAppleStockPrices
//
//  Created by Jeffrey Almonte on 12/7/18.
//  Copyright © 2018 Pursuit. All rights reserved.
//

import UIKit

class StocksViewController: UIViewController {
    
    var stocks = [[StockPrice]]()
    
    @IBOutlet weak var stockTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stocks = fillSection()
        
        stockTableView.dataSource = self
    }
    func loadData() -> [StockPrice]? {
        var results: [StockPrice]?
        if let path = Bundle.main.path(forResource: "applstockinfo", ofType: "json") {
            let myUrl = URL.init(fileURLWithPath: path)
            if let data = try? Data.init(contentsOf: myUrl) {
                do {
                    results = try JSONDecoder().decode([StockPrice].self, from: data).sorted{$0.date < $1.date}
                } catch {
                    print(error)
                }
            }
        }
        return results
    }
    
    func getDateMonth(dateString: String) -> (month: String, year: String) {
        let components = dateString.components(separatedBy: "-")
        return (components[1], components[0])
    }
    
    func fillSection() -> [[StockPrice]] {
        var sections = [[StockPrice]]()
        
        
        if let dailyStockData = loadData() {
            
            sections.append([StockPrice]())
            
            var startIndex = 0
            
            var date = (month: "12", year: "2016")
            
            
            
            for currentStockInfo in dailyStockData {
                
                
                if date != getDateMonth(dateString: currentStockInfo.date ) {
//
                    sections.append([StockPrice]())
                    startIndex += 1
                 
                }
                
                   date = getDateMonth(dateString: currentStockInfo.date)
                sections[startIndex].append(currentStockInfo)
            }
        }
        
        return sections
    }
    
//    func getSectionNames() {
//        for stock in stocks {
//          // if !stock
//        }
//    }
    
}
extension StocksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks[section].count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stockTableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath)
        let stockToSet = stocks[indexPath.section][indexPath.row]
        cell.textLabel?.text = stockToSet.date
        cell.detailTextLabel?.text = "$" + String(format: "%.2f", stockToSet.open)
        return cell
    }
    
    
}

// table delget and header in scetion

