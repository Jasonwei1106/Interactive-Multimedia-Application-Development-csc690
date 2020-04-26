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
    init(name:String, check:Bool){
        self.name = name
        self.check = check
    }
    init?(managedObject: NSManagedObject){
        guard let name = managedObject.value(forKey: "name") as? String else {
            return nil
        }
        guard let check = managedObject.value(forKey: "check") as? Bool else{
            return nil
        }
        self.name = name
        self.check = check
    }
}

enum Iscomplete: String{
    case Complete = "Complete"
    case Incomplete = "Incomplete"
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,addText,updateText,Change,UISearchBarDelegate{
    

    @IBOutlet weak var myTable: UITableView!
    var currentlist: [todo] = []
    var index: Int?
    var store = CoreData()
    var lists:[todo] = []
    var objectcontext: NSManagedObjectContext?
    let checkmap = ["Complete": true,"Incomplete": false]


    @IBOutlet weak var Scope: UISearchBar!
    
    private func setUpSearchBar(){
        Scope.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int){
        switch selectedScope{
            case 0:
                currentlist = lists
            case 1:
                currentlist = lists.filter({ name -> Bool in name.check == checkmap[Iscomplete.Complete.rawValue]})
            case 2:
                currentlist = lists.filter({ name -> Bool in name.check == checkmap[Iscomplete.Incomplete.rawValue]})
        default:
            break
        }
        myTable.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard !searchText.isEmpty else{
            currentlist = lists
            return
        }
        currentlist = lists.filter({ name -> Bool in
            guard let text = Scope.text else {return false}
            return  name.name.lowercased().contains(text)
            
        })
        myTable.reloadData()
        
        
    }
    
    func change(name: todo,index: Int){
        if(!name.check){
            let todoCell = name
            store.setCheck(name: todoCell)
            lists[index].check = true
            currentlist[index].check = true
            myTable.reloadData()
        }else{
            let todoCell = name
            store.setUnCheck(name: todoCell)
            lists[index].check = false
            currentlist[index].check = false
            myTable.reloadData()
        }
    }
    
    func alterdup(){
        let alertController = UIAlertController(title: "Duplicate warning", message:
            "Please don't enter duplicate item", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
    func updatetext(name: String, index: Int){
        var flag: Bool = true
        for list in currentlist{
            if (list.name == name){
                alterdup()
                flag = false
            }
        }
        if(name != "" && flag){
            let cellcheck = lists[index].check
            let todoCell = todo(name:name, check:cellcheck)
            store.update(name: lists[index].name,updatename:todoCell)
            currentlist[index] = todoCell
            lists[index] = todoCell
            myTable.reloadData()
         }else{
             let alertController = UIAlertController(title: "Warning", message:
                 "Please do not leave  it empty", preferredStyle: .alert)
             alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

             self.present(alertController, animated: true, completion: nil)
             }
        }
    
    func addtext(name: String, isComplete: Bool) {
        var flag: Bool = true
        for list in currentlist{
            if (list.name == name){
                alterdup()
                flag = false
            }
        }
        if(name != "" && flag){
            let todoCell = todo(name:name)
            currentlist.append(todoCell)
            lists.append(todoCell)
            store.store(name: todoCell, isComplete: todoCell.check)
            myTable.reloadData()
            
        }else{
            let alertController = UIAlertController(title: "Warning", message:
                "Please do not leave  it empty", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            }
       }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentlist.count
    }

    //need to work on logic
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        cell.delegate = self
        cell.lists = currentlist
        cell.index = indexPath.row
        cell.labelName.text = currentlist[indexPath.row].name
        
        if currentlist[indexPath.row].check{
            cell.Checkbox.setImage(UIImage(named:"check"), for: UIControl.State.normal)
        }else{
            cell.Checkbox.setImage(UIImage(named:"uncheck"), for: UIControl.State.normal)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "UpdateText", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            let deleteitem = currentlist[indexPath.row]
            store.remove(name: deleteitem)
            lists.remove(at: indexPath.item)
            currentlist.remove(at: indexPath.item)
            tableView.deleteRows(at:[indexPath], with: .automatic)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource = self
        myTable.delegate = self
        lists = store.getAllstore()
        currentlist = lists
        setUpSearchBar()
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
            displayvc.lists = currentlist
            displayvc.rowindex = index
            displayvc.delegate = self
        }
    }


}



