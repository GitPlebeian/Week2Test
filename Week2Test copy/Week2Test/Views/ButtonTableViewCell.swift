//
//  ButtonTableViewCell.swift
//  Week2Test
//
//  Created by Jackson Tubbs on 8/9/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

protocol ItemTableViewCellDelegate {
    func itemButtonTapped(_ sender: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemButton: UIButton!
    
    // MARK: - Properties
    
    var delegate: ItemTableViewCellDelegate?
    
    // MARK: - Actions
    
    @IBAction func itemButtonTapped(_ sender: Any) {
        delegate?.itemButtonTapped(self)
    }

    // MARK: - Custom Functions
    
    // Will update image depending on if the item is complete
    func updateImage(item: Item) {
        if item.isComplete {
            itemButton.setImage(UIImage(named: "complete"), for: .normal)
        } else {
            itemButton.setImage(UIImage(named: "incomplete"), for: .normal)
        }
    }
}

// Updates the items view
extension ButtonTableViewCell {
    func update(item: Item) {
        itemNameLabel.text = item.name
        updateImage(item: item)
    }
}
