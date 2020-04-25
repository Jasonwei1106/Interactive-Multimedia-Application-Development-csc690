//
//  TodoCell.swift
//  TodoList
//
//  Created by Rob on 4/12/20.
//  Copyright © 2020 Jason. All rights reserved.
//

import UIKit



protocol Change {
    func change(check: Bool) ->Bool
}

let core = CoreData()

class TodoCell: UITableViewCell {
    var viewContol = ViewController()
    
    
    @IBAction func Check(_ sender: Any) {
        let temp = delegate!.change(check: lists![index!].check)
        print(temp)
        lists![index!].check = temp
    }
    
    @IBAction func checkBox(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            print(sender.isSelected)
            core.setInComplete(isComplete: sender.isSelected)

        }else{
            sender.isSelected = true
            print(sender.isSelected)
            core.setComplete(name: lists![index!])
        }
    }
    
    @IBOutlet weak var labelName: UILabel!
    
    var delegate: Change?
    var lists: [todo]?
    var index : Int?

}
