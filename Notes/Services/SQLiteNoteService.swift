//
//  SQLiteNoteService.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import Foundation
import SQLite

class SQLiteNoteService: ObservableObject {
    private let notes = Table("notes")

    private var db: Connection?

    private let id = Expression<UUID>("id")
    private let message = Expression<String>("message")
    private let color = Expression<String>("color")
    private let date = Expression<Date>("date")
    
    static var shared = SQLiteNoteService()
    
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
                notes.append(NoteModel(message: note[message], date: note[date], color: note[color]))
            }
        } catch {
            print(error)
        }
        return notes
    }
    
    func updateNote(oldNote: NoteModel, message: String, date: Date, color: String) {
        guard let database = db else { return }
        let note = notes.filter(self.id == id)
        do {
            let update = note.update([
                self.message <- message,
                self.date <- date,
                self.color <- color
            ])
            try database.run(update)
        } catch {
            print(error)
        }
    }
    
    func deleteNote(note: NoteModel) {
        guard let database = db else {
            return
        }
        do {
            let filter = notes.filter(self.message == note.message)
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
