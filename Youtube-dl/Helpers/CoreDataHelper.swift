//
//  CoreDataHelper.swift
//  Youtube-dl
//
//  Created by Chen Zerui on 19/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import CoreData

struct CoreDataHelper {
    
    static let shared = CoreDataHelper()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "Youtube_dl")
        
        container.loadPersistentStores(completionHandler: {_, err in
            if err != nil{
                fatalError("failed to init coredata : \(err!)")
            }
        })

        context = container.viewContext
    }
    
    func tryToSave() {
        do{
            try context.save()
        }
        catch{
            AppDelegate.shared.topViewControler?.alert(title: "Save Failed", message: error.localizedDescription)
        }
    }
    
    func fetchAll()-> [Video] {
        return try! context.fetch(Video.fetchRequest())
    }
}
