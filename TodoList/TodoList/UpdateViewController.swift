//
//  UpdateViewController.swift
//  TodoList
//
//  Created by Rob on 4/18/20.
//  Copyright © 2020 Jason. All rights reserved.
//


import UIKit
protocol updateText{
    func updatetext(name: String, index: Int)
}
class UpdateViewController: UIViewController {
    
    var todotext : String?
    var rowindex: Int = 0
    
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var UpdateText: UITextField!
    
    @IBAction func Update(_ sender: Any) {
        delegate?.updatetext(name: UpdateText.text!, index: rowindex)
        navigationController?.popViewController(animated: true)
    }
    var delegate: updateText?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let text = todotext {
            UpdateText.text = text
        }
        
    }

}
