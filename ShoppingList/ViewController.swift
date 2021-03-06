//
//  ViewController.swift
//  ShoppingList
//
//  Created by Wenzhong Zheng on 2017-02-21.
//  StudentID 300909195
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate, MyTableDelegate {

    var ref:FIRDatabaseReference!
    let cellId = "cell"
    
    @IBOutlet weak var shoppingListName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference().child("Items")
        observeItems()
        
    }

    // MARK: LOAD DATA FROM FIREBASE
    func observeItems(){
        
        ref.observe(.value, with: { (snapshot) in
            var newItems:[Item] = []
            
            for child in snapshot.children {
                let newItem = Item(snapshot: child as! FIRDataSnapshot)
                newItems.append(newItem)
            }
            self.items = newItems
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }, withCancel: nil)
        
        
    }
    
    // MARK: ADD NEW ITEM TO LIST
    @IBAction func topAddButtonTouched(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Grocery Item",
                                      message: "Add an Item",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
                                        guard let textField = alert.textFields?.first,
                                            let text = textField.text else { return }
                                        
                                        let item = Item(name: text)
                                        
                                        self.items.append(item)
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

        
    }
    
    // MARK: CHANGE QUANTITY VALUE
    func stepperTaped(_ cell:ItemCell){
        guard let indexPath = tableView.indexPath(for: cell) else{return}
        items[indexPath.row].quantity = Int(cell.stepper.value)
        tableView.reloadData()
    }
    
    // MARK: UPLOAD DATA TO FIREBASE
    @IBAction func saveButtonTouched(_ sender: UIButton) {
        for item in items {
            if let name = item.name {
                let quantity = item.quantity
                let values = [name: quantity] as [String : Any]
                ref.updateChildValues(values)
            }
        }
        
    }
    
    // MARK: RESET LIST
    @IBAction func cancelButtonTouched(_ sender: UIButton) {
        items.removeAll()
        tableView.reloadData()
    }
    
    // MARK: Using delegate to handle swipe
    func myTableDelegate(_ cell: ItemCell) {
        
        let alert = UIAlertController(title: "Favourite", message: "Add favourite or cancel it ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
            cell.accessoryType = .none
            
        }))
        alert.addAction(UIAlertAction(title: "Favourite", style: .default, handler: { (action) in
            
            cell.accessoryType = .checkmark
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ItemCell
        
        if let name = items[indexPath.row].name {
            let quantity = items[indexPath.row].quantity
            cell.itemLabel.text = name
            cell.quantityLabel.text = "\(quantity)"
            cell.stepper.value = Double(quantity)
        }
        
        cell.swipeDelegate = self
        
        cell.tapStepper = {(cell) in
            self.stepperTaped(cell)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Delete", message: "Do you really want to delete it ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Pretty sure", style: .destructive, handler: { (action) in
                if let name = self.items[indexPath.row].name {
                    self.ref.child(name).removeValue()
                }
                self.items.remove(at: indexPath.row)
                self.tableView.reloadData()
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }

    }
    
}

