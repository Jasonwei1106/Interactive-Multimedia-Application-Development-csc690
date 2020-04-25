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

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,addText,updateText,Change, UISearchBarDelegate{
    
    
    var filterdtodolist = [todo]()
    @IBOutlet weak var myTable: UITableView!
    var index: Int?
    var store = CoreData()
    var lists:[todo] = []
    var objectcontext: NSManagedObjectContext?




    
    
    func change(name: todo,index: Int){
        if(!name.check){
            let todoCell = name
            store.setCheck(name: todoCell)
            lists[index].check = true
            myTable.reloadData()
        }else{
            let todoCell = name
            store.setUnCheck(name: todoCell)
            lists[index].check = false
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
        for list in lists{
            if (list.name == name){
                alterdup()
                flag = false
            }
        }
        if(name != "" && flag){
            let cellcheck = lists[index].check
            let todoCell = todo(name:name, check:cellcheck)
            store.update(name: name,updatename:todoCell)
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
        for list in lists{
            if (list.name == name){
                alterdup()
                flag = false
            }
        }
        if(name != "" && flag){
            let todoCell = todo(name:name)
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
        return lists.count
    }

    //need to work on logic
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        cell.delegate = self
        cell.lists = lists
        cell.index = indexPath.row
        cell.labelName.text = lists[indexPath.row].name
        if lists[indexPath.row].check{
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
            let deleteitem = lists[indexPath.row]
            store.remove(name: deleteitem)
            lists.remove(at: indexPath.item)
            tableView.deleteRows(at:[indexPath], with: .automatic)
        }
    }
    /*
    var searchController: UISearchController {
        let s = UISearchController(searchResultsController: nil)
        s.searchResultsUpdater = self
        s.obscuresBackgroundDuringPresentation = false
        s.searchBar.placeholder = "Search todo lists"
        s.searchBar.sizeToFit()
        s.searchBar.searchBarStyle = .prominent
        s.searchBar.scopeButtonTitles = ["All","Complete","Incomplete"]
        s.searchBar.delegate = self
        return s
    }
    */
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
            displayvc.lists = lists
            displayvc.rowindex = index
            displayvc.delegate = self
        }
    }
}

    /*
    func filterContentsfromsearchContents(searchText:String,scope:String = "All"){
        filterdtodolist = lists.filter({ (name:todo) -> Bool in
            let isMatch = (scope == "All") || (name.name == scope)
            
            if isSearchBarEmpty(){
                return isMatch
            }else{
                return isMatch && name.name.lowercased().contains(searchText.lowercased())
            }
        })
        myTable.reloadData()
    }
    func isSearchBarEmpty() -> Bool{
        return searchController.searchBar.text?.isEmpty ?? true
    }
   
}


extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        //let searchBar = searchController.searchBar
        //let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        //filterContentsfromsearchContents(searchText: searchController.searchBar.text!, scope: scope)
    }
}

extension ViewController: UISearchControllerDelegate{
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonChange selectedScope:Int){
        filterContentsfromsearchContents(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
*/
