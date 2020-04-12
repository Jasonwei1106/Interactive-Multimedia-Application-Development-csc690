//
//  AddViewController.swift
//  TodoList
//
//  Created by Rob on 4/12/20.
//  Copyright © 2020 Jason. All rights reserved.
//

import UIKit
protocol addText {
    func addtext(name: String)
}

class AddViewController: UIViewController {

    @IBOutlet weak var AddTodo: UIButton!
    @IBOutlet weak var TodoText: UITextField!
    var addtext = ""
    
    @IBAction func Add(_ sender: Any) {
        delegate?.addtext(name: TodoText.text!)
     }
    var delegate: addText?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    

}
