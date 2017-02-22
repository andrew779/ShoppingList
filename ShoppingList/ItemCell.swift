//
//  ItemCell.swift
//  ShoppingList
//
//  Created by Wenzhong Zheng on 2017-02-21.
//  StudentID 300909195
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var tapStepper:((ItemCell) -> Void)?
    var swipeDelegate: MyTableDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let swipGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        swipGesture.direction = .right
        addGestureRecognizer(swipGesture)
        
    }

    // Mark: delegate to handle swipe to right
    func swiped(_ sender: UISwipeGestureRecognizer){
        swipeDelegate?.myTableDelegate(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Mark: using closure to handle stepper event
    @IBAction func stepperTouched(_ sender: UIStepper) {
        tapStepper?(self)
    }
    
   

}
// Mark: Custom protocol
protocol MyTableDelegate {
    func myTableDelegate(_ cell:ItemCell)
}
