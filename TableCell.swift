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
    
    @IBOutlet weak var timestable: UIButton!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
