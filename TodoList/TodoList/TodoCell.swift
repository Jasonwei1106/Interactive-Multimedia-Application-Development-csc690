//
//  TodoCell.swift
//  TodoList
//
//  Created by Rob on 4/12/20.
//  Copyright © 2020 Jason. All rights reserved.
//

import UIKit



protocol Change {
    func change(name: todo, index: Int)
}

let core = CoreData()

class TodoCell: UITableViewCell {
    var viewContol = ViewController()
    
    
    @IBAction func checkBox(_ sender: UIButton) {
            delegate?.change(name: lists![index!],index: index!)
            //core.setInComplete(isComplete: sender.isSelected)
    }
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var Checkbox: UIButton!
    var delegate: Change?
    var lists: [todo]?
    var index : Int?

}
