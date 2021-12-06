//
//  PostCoreData.swift
//  Scoot911_AdityaNew
//
//  Created by A1502 on 06/12/21.
//

import Foundation
import CoreData
import UIKit

class PostCoreData{
    
    static func deleteAllData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    static func createData(pList:[PostList]){
        debugPrint(pList)
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "Post", in: managedContext)!
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        for i in 0...pList.count-1 {
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(pList[i].title, forKey: "title")
            user.setValue(pList[i].body, forKey: "body")
            user.setValue(pList[i].userID, forKey: "userId")
            user.setValue(pList[i].postId, forKey: "postId")
        }
        //Now we have set all the values. The next step is to save them inside the Core Data
        do {
            try managedContext.save()
            print("save in core data")
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static  func retrieveData() -> [PostList] {
        pList.removeAll()
        var pList_local = [PostList]()
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //We need to create a context from this container
        let managedContext = appDelegate!.persistentContainer.viewContext
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        let sortDescriptor = NSSortDescriptor(key: "postId", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let postData = PostList.init(userID: data.value(forKey: "userId") as! Int, postId: data.value(forKey: "postId") as! Int, title: data.value(forKey: "title") as! String, body: data.value(forKey: "body") as! String)
                
                pList_local.append(postData)
            }
            pList = pList_local
            
            
        } catch {
            
            print("Failed")
        }
        return pList_local
        
    }
    
    
    
    
}
