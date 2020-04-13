//
//  ViewController.swift
//  TodoList
//
//  Created by Rob on 4/11/20.
//  Copyright © 2020 Jason. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,addText {
        

    @IBOutlet weak var myTable: UITableView!
    
    var lists = [todo]()
    
    func addtext(name: String) {
        if(name != ""){
            lists.append(todo(name: name))
            myTable.reloadData()
            
        }else{
            let alertController = UIAlertController(title: "iOScreator", message:
                "Please do not leave  it empty", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            }
       }
       
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        cell.labelName.text = lists[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObjTemp = lists[sourceIndexPath.item]
        lists.remove(at: sourceIndexPath.item)
        lists.insert(movedObjTemp, at: destinationIndexPath.item)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            lists.remove(at: indexPath.item)
            tableView.deleteRows(at:[indexPath], with: .automatic)
        }
    }
    
    
    
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        self.myTable.isEditing = !self.myTable.isEditing
        sender.title = (self.myTable.isEditing) ? "Done" : "Edit"


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource = self
        myTable.delegate = self
        lists.append(todo(name: "one"))
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddText"){
            let displayvc = segue.destination as! AddViewController
            displayvc.delegate = self
        
        }
    }
    
    class todo{
        var name = ""
        init(name:String){
            self.name = name
        }
    }
    

}

