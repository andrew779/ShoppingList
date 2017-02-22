//
//  ItemCell.swift
//  ShoppingList
//
//  Created by Wenzhong Zheng on 2017-02-21.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var tapStepper:((ItemCell) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func stepperTouched(_ sender: UIStepper) {
        tapStepper?(self)
    }
    

}
