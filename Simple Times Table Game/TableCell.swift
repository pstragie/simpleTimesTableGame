//
//  TableCell.swift
//  Simple Times Table Game
//
//  Created by Pieter Stragier on 07/03/2018.
//  Copyright © 2018 PWS-apps. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "TableCell"
    
    // MARK: -
    
    @IBOutlet weak var timesTable: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var BGView: UIView!
    
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        BGView.layer.cornerRadius = 10
        BGView.layer.borderWidth = 1
        BGView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
}
