//
//  SQLiteService.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import Foundation
import SQLite

final class SQLiteService: ObservableObject {
    private var db: Connection?
    
    private let notes = Table("notes")
    private let id = Expression<String>("id")
    private let message = Expression<String>("message")
    private let color = Expression<String>("color")
    private let date = Expression<Date>("date")
    
    static var shared = SQLiteService()
    
    @Published var allNotes = [NoteModel]()
    
    private init() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        db = try? Connection("\(path)/notes.sqlite3")
        create()
    }
    
    func create() {
        do {
            try db?.run(notes.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(message)
                t.column(color)
                t.column(date)
            })
        } catch {
            print(error)
        }
    }
    
    func addNote(note: NoteModel) {
        let insert = notes.insert(or: .replace, id <- note.id,
                                  message <- note.message,
                                  color <- note.color,
                                  date <- note.date)
        do {
            try db?.run(insert)
        } catch {
            print(error)
        }
        getNotesList()
    }
    
    func getAllNotes() -> [NoteModel] {
        var notes: [NoteModel] = []
        guard let database = db else { return [] }
        
        do {
            for note in try database.prepare(self.notes) {
                let noteModel = NoteModel(id: note[id], message: note[message], date: note[date], color: note[color])
                notes.append(noteModel)
            }
        } catch {
            print(error)
        }
        return notes
    }
    
    func updateNote(changedNote: NoteModel) {
        guard let database = db else { return }
        let note = notes.filter(self.id == changedNote.id)
        do {
            let update = note.update([
                self.message <- changedNote.message,
                self.date <- changedNote.date,
                self.color <- changedNote.color
            ])
            try database.run(update)
        } catch {
            print(error)
        }
    }
    
    func deleteNote(id: String) {
        guard let database = db else {
            return
        }
        do {
            let filter = notes.filter(self.id == id)
            try database.run(filter.delete())
            getNotesList()
        } catch {
            print(error)
        }
    }
    
    func getNotesList() {
        allNotes = self.getAllNotes()
    }
}
