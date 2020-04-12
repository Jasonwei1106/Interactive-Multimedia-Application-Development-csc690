//
//  ViewController.swift
//  TodoList
//
//  Created by Rob on 4/11/20.
//  Copyright © 2020 Jason. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var myTable: UITableView!
    
    let lists = ["one","two","three"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        cell.labelName.text = lists[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource = self
        myTable.delegate = self
        
    }
    
    class todo{
        var name = ""
        init(name:String){
            self.name = name
        }
    }
    

}

