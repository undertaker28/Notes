//
//  FileSystemService.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import SwiftUI

final class FileSystemService: ObservableObject {
    static let shared = FileSystemService()
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
    
    func updateNote(changedNote: NoteModel) {
        if let index = allNotes.firstIndex(where: { $0.id == changedNote.id }) {
            allNotes[index] = changedNote
        }
        saveNotes()
    }
    
    func deleteNote(id: String) {
        if let index = allNotes.firstIndex(where: { $0.id == id }) {
            allNotes.remove(at: index)
        }
        saveNotes()
    }
}
