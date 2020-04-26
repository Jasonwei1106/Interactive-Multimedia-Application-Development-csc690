//
//  AddViewController.swift
//  TodoList
//
//  Created by Rob on 4/12/20.
//  Copyright © 2020 Jason. All rights reserved.
//

import UIKit
protocol addText {
    func addtext(name: String, isComplete: Bool)
}

class AddViewController: UIViewController {

    @IBOutlet weak var AddTodo: UIButton!
    @IBOutlet weak var TodoText: UITextField!
    var addtext = ""
    
    
    
    @IBAction func Add(_ sender: Any) {
        delegate?.addtext(name: TodoText.text!, isComplete: false)
        navigationController?.popViewController(animated: true)
     }
    var delegate: addText?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    

}
