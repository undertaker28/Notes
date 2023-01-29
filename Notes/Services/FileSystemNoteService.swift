//
//  FileSystemNoteService.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import SwiftUI

final class FileSystemNoteService: ObservableObject {
    static let shared = FileSystemNoteService()
    private let dataSourceURL: URL
    @Published var allNotes = [NoteModel]()
    
    init() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let notesPath = documentsPath.appendingPathComponent("notes").appendingPathExtension("json")
        dataSourceURL = notesPath
        
        _allNotes = Published(wrappedValue: getAllNotes())
    }
    
    private func getAllNotes() -> [NoteModel] {
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: dataSourceURL)
            let decodeNotes = try! decoder.decode([NoteModel].self, from: data)
            
            return decodeNotes
        } catch {
            return []
        }
    }
    
    private func saveNotes() {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allNotes)
            try data.write(to: dataSourceURL)
        } catch {
            
        }
    }
    
    func addNote(note: NoteModel) {
        allNotes.insert(note, at: 0)
        saveNotes()
    }
    
    func updateNote(oldNote: NoteModel, newNote: NoteModel) {
        if let index = allNotes.firstIndex(of: oldNote) {
            allNotes[index] = newNote
        }
        saveNotes()
    }
    
    func deleteNote(note: NoteModel) {
        if let index = allNotes.firstIndex(of: note) {
            allNotes.remove(at: index)
        }
        saveNotes()
    }
}
