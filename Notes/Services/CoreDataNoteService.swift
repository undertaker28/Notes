//
//  CoreDataNoteService.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import CoreData

final class CoreDataNoteService: ObservableObject {
    let container = NSPersistentContainer(name: "Note")
    
    init() {
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            context.rollback()
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func addNote(message: String, date: Date, color: String, context: NSManagedObjectContext) {
        let note = Note(context: context)
        
        note.id = UUID()
        note.message = message
        note.date = date
        note.color = color
        
        save(context: context)
    }
    
    func editNote(note: Note, message: String, date: Date, color: String, context: NSManagedObjectContext) {
        note.message = message
        note.date = date
        note.color = color
        
        save(context: context)
    }
    
    func deleteNote(note: Note, context: NSManagedObjectContext) {
        context.delete(note)
        
        save(context: context)
    }
}
