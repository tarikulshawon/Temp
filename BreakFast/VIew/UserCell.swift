//
//  UserCell.swift
//  BreakFast
//
//  Created by tarikul shawon on 6/9/22.
//

import UIKit

protocol CellTapDelegate {
    func sendReset(key: String)
}

class UserCell: UITableViewCell {
    var delegate: CellTapDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(tapEdit))
        gesture.minimumPressDuration = 3
        addGestureRecognizer(gesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(callNumber))
        imageView?.addGestureRecognizer(tapGesture)
        
    }

    func prepare(data: CellData) {
        delegate = data.delegate
        textLabel?.text = data.user.name
        detailTextLabel?.text = String(data.user.cost)
    }
    
    @objc
    func tapEdit(sender: UILongPressGestureRecognizer) {
        guard let value = textLabel?.text else { return }
        delegate?.sendReset(key: value)
    }
}

private extension UserCell {
    @objc func callNumber(sender: UITapGestureRecognizer) {
        let dic = [
            "Samin": "01962086383", "Tarikul": "01677243143",
            "Rayhan": "01965601244",
            "Yasin": "01557253121",
            "Mazed": "", "Sabbir": "01521206318",
            "Kasem": ""
        ]
        
        guard
            let name = textLabel?.text,
            let phoneNumber = dic[name]
        else { return }
        
        if phoneNumber.isEmpty { return }
        
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
