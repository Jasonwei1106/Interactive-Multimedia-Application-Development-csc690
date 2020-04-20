//
//  ViewController.swift
//  TodoList
//
//  Created by Rob on 4/11/20.
//  Copyright © 2020 Jason. All rights reserved.
//

import UIKit
import CoreData
struct todo {
    var check = false
    let name: String
    
    init(name:String){
        self.name = name
    }
    init?(managedObject: NSManagedObject){
        guard let name = managedObject.value(forKey: "name") as? String else {
            return nil
        }
        self.name = name
    }
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,addText,updateText,Change {
        

    @IBOutlet weak var myTable: UITableView!
    var index: Int?
    var store = CoreData()
    var lists:[todo] = []
    var objectcontext: NSManagedObjectContext?
    

    @IBAction func SelectBox(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }

    }
    
    func updatetext(name: String, index: Int){
        var dup = false
        if(name != ""){
            let todoCell = todo(name:name)
            for list in lists{
                if (list.name == name){
                    alterdup()
                    dup = true
                }
            }
            if(!dup){
                store.update(name: lists[index],updatename:todoCell)
                lists[index] = todoCell
            
                myTable.reloadData()
            }
         }else{
             let alertController = UIAlertController(title: "Warning", message:
                 "Please do not leave  it empty", preferredStyle: .alert)
             alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

             self.present(alertController, animated: true, completion: nil)
             }
        }
    
    func addtext(name: String) {
        var dup = false
        if(name != ""){
            let todoCell = todo(name:name)
            for list in lists{
                if (list.name == name){
                    alterdup()
                    dup = true
                }
            }
            if(!dup){
                lists.append(todoCell)
                store.store(name: todoCell)
                myTable.reloadData()
            }
        }else{
            let alertController = UIAlertController(title: "Warning", message:
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
        if lists[indexPath.row].check{
            cell.Checkbox.setImage(UIImage(named: "check"), for: UIControl.State.normal)
        }else{
            cell.Checkbox.setImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
        }
        print("some ",lists[indexPath.row].check)
        
        cell.delegate = self
        cell.lists = lists
        cell.index = indexPath.row
        
        cell.labelName.text = lists[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObjTemp = lists[sourceIndexPath.item]
        lists.remove(at: sourceIndexPath.item)
        lists.insert(movedObjTemp, at: destinationIndexPath.item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "UpdateText", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            let deleteitem = lists[indexPath.row]
            store.remove(name: deleteitem)
            lists.remove(at: indexPath.item)
            tableView.deleteRows(at:[indexPath], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource = self
        myTable.delegate = self
        lists = store.getAllstore()
        myTable.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddText"){
            let displayvc = segue.destination as! AddViewController
            displayvc.delegate = self
        }
        else if (segue.identifier == "UpdateText"){
            let displayvc = segue.destination as! UpdateViewController
            guard let index = index else {
                return
            }
            displayvc.todotext = lists[index].name
            displayvc.rowindex = index
            displayvc.delegate = self
        }
    }
    

}
