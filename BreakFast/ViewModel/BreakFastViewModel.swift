//
//  BreakFastViewModel.swift
//  BreakFast
//
//  Created by tarikul shawon on 6/9/22.
//

import Foundation

struct UserInfo {
    var name: String
    var cost: Int
    var accessTime: Int
}

struct CellData {
    var user: UserInfo
    var delegate: CellTapDelegate?
}

protocol BreakFastViewModelManager {
    var numberOfItems: Int { get }
    func getCellData(at: Int) -> CellData
    func updateCost(at: Int, cost: Int)
}

protocol EventDelegate {
    func reloadViews()
}

final class BreakFastViewModel {
    
    var delegate: EventDelegate!
    
    var dataset: [UserInfo] = []
    
    init(delegate: EventDelegate) {
        self.delegate = delegate
        loadData()
    }
    
    func loadData() {
        let nameSet = ["Samin", "Tarikul", "Rayhan", "Yasin", "Mazed", "Sabbir", "Kasem"]
        
        for name in nameSet {
            let value = getValue(forKey: name)
            
            dataset.append(
                UserInfo(
                    name: name,
                    cost: value[0],
                    accessTime: value[1]
                )
            )
        }
        
        dataset = dataset.sorted { $0.accessTime < $1.accessTime }
    }
}

extension BreakFastViewModel: BreakFastViewModelManager {
    var numberOfItems: Int {
        dataset.count
    }
    
    func getCellData(at: Int) -> CellData {
        CellData(
            user: dataset[at],
            delegate: self
        )
    }
    
    func updateCost(at: Int, cost: Int) {
        dataset[at].cost += cost
        dataset[at].accessTime = Int(Date().timeIntervalSince1970)
        setValue([dataset[at].cost, dataset[at].accessTime] , forKey: dataset[at].name)
        
        dataset = dataset.sorted { $0.accessTime < $1.accessTime }
    }
    
    
}

extension BreakFastViewModel {
    func setValue(_ content: [Int], forKey: String) {
        UserDefaults.standard.set(content, forKey: forKey)
    }
    
    func getValue(forKey: String) -> [Int] {
        UserDefaults.standard.array(forKey: forKey) as? [Int] ?? [0, 0]
    }
}

extension BreakFastViewModel: CellTapDelegate {
    func sendReset(key: String) {
        setValue([0, 0], forKey: key)
        
        dataset.removeAll()
        loadData()
        
        delegate.reloadViews()
    }
}
