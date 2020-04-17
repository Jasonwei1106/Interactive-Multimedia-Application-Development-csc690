//  Created by Thomas Yu on 4/17/20.
//  Copyright © 2020 Jason. All rights reserved.
//
import CoreData
struct Keys {
    static let myTodo = "Todo"
}

class CoreData {

    lazy var persistentContainer: NSPersistentContainer = {

           let container = NSPersistentContainer(name: "todo")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()
    
    func store(name: todo){
        print("in store func")
        let context = persistentContainer.newBackgroundContext()
        guard let entity = NSEntityDescription.entity(forEntityName: Keys.myTodo, in: context)else{
            print("cannot add entity")
            return
        }
        let manageObject = NSManagedObject(entity: entity, insertInto: context)
        manageObject.setValue(name.name, forKey: "name")
        do{
           try context.save()
        }catch{
            print("cannot save OBJ")
        }
   
    }
    
    func getAllstore()->[todo]{
        print("in the getAllstore func.")
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: Keys.myTodo)
        do{
            let manageTodo : [NSManagedObject] = try context.fetch(request)
            let name: [todo] = manageTodo.compactMap{ managedtodoInstance in
                return todo(managedObject: managedtodoInstance)
            }
            return name
        }catch{
            print("cannot fetch")
            return []
        }
    }
}

