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

class TodoCell: UITableViewCell {

    @IBAction func Check(_ sender: Any) {
        let temp = delegate!.change(check: lists![index!].check)
        print(temp)
        lists![index!].check = temp
    }
    @IBOutlet weak var Checkbox: UIButton!
    
    @IBOutlet weak var labelName: UILabel!
    
    var delegate: Change?
    var lists: [todo]?
    var index : Int?

}
