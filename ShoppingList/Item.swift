//
//  Item.swift
//  ShoppingList
//
//  Created by Wenzhong Zheng on 2017-02-21.
//  StudentID 300909195
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Item{
    
    var name:String?
    var quantity: Int = 0
 
    init (name:String){
        self.name = name
    }
    
    init(name:String, quantity:Int){
        self.name = name
        self.quantity = quantity
    }
    
    init(snapshot: FIRDataSnapshot) {
        self.name = snapshot.key
        self.quantity = snapshot.value as! Int
    }
    
}
