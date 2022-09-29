//
//  ViewController.swift
//  BreakFast
//
//  Created by tarikul shawon on 6/9/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heading: UILabel!
    
    private var viewModel: BreakFastViewModelManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        
        viewModel = BreakFastViewModel(delegate: self)
        
        setupHeading()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:  return 1
        default: return viewModel.numberOfItems - 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
    
        if indexPath.section == 0 {
            let cellData = viewModel.getCellData(at: indexPath.row)
            cell.prepare(data: cellData)
        } else {
            let cellData = viewModel.getCellData(at: indexPath.row + 1)
            cell.prepare(data: cellData)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:  showInputpopup(at: indexPath.row)
        default: showInputpopup(at: indexPath.row + 1)
        }
        showInputpopup(at: indexPath.row)
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        "Press & Hold 2 seconds for reset Any Cell Content"
//    }
    
}

extension ViewController {
    func showInputpopup(at: Int) {
        let data = viewModel.getCellData(at: at)
        
        let alertController = UIAlertController(
            title: data.user.name,
            message: "Cost of Today's Meal",
            preferredStyle: .alert
        )

        alertController.addTextField { (textField) in
            textField.placeholder = "Cost"
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            let inputValue = alertController.textFields![0].text
            
            self?.viewModel.updateCost(at: at, cost: Int(inputValue ?? "0") ?? 0)
            self?.tableView.reloadData()

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func setupHeading() {
        // get the current date and time
        let currentDateTime = Date()

        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium

        // get the date time String from the date object
        let dateString = formatter.string(from: currentDateTime) // October 8, 2016 at 10:48:53 PM
        heading.text = dateString
    }
}

extension ViewController: EventDelegate {
    func reloadViews() {
        tableView.reloadData()
    }
}
