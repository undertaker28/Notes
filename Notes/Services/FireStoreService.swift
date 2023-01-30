//
//  FireStoreService.swift
//  Notes
//
//  Created by Pavel on 31.01.23.
//

import FirebaseFirestore

final class FireStoreService: ObservableObject {
    private let collectionPath = "notes"
    private let db = Firestore.firestore()
    
    static var shared = FireStoreService()
    
    @Published var allNotes = [NoteModel]()
    
    func getNotesList() {
        db.collection(collectionPath).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents!")
                return
            }
            
            self.allNotes = documents.map { queryDocumentSnapshot -> NoteModel in
                let note = queryDocumentSnapshot.data()
                let id = note["id"] as! String
                let message = note["message"] as! String
                let stamp = note["date"] as! Timestamp
                let date = stamp.dateValue()
                let color = note["color"] as! String
                return NoteModel(id: id, message: message, date: date, color: color)
            }
        }
    }
    
    func addNote(note: NoteModel) {
        let data = ["id": note.id, "message": note.message, "date": note.date, "color": note.color] as [String : Any]
        db.collection(collectionPath).document(note.id).setData(data)
    }
    
    func updateNote(changedNote: NoteModel) {
        db.collection(collectionPath).document(changedNote.id).updateData(["id": changedNote.id, "message": changedNote.message, "date": changedNote.date, "color": changedNote.color])
    }
    
    func deleteNote(id: String) {
        db.collection(collectionPath).document(id).delete()
    }
}
