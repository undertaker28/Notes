//
//  EditNoteView.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import SwiftUI

struct EditNoteView: View {
    @ObservedObject var notesSQLite = SQLiteNoteService.shared
    @ObservedObject var notesFileSystem = FileSystemNoteService.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var message: String = ""
    @State private var date: Date = Date.now
    @State private var color: Int = 0
    var note: NoteModel
    var mode: Int
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Spacer(minLength: 0)
                
                Text("Edit note")
                
                Spacer(minLength: 0)
                
                Button {
                    switch mode {
                    case 0:
                        notesSQLite.updateNote(oldNote: note, message: message, date: date, color: Constants.colors[color])
                    case 1:
                        notesFileSystem.updateNote(oldNote: note, newNote: NoteModel(message: message, date: date, color: Constants.colors[color]))
                    default:
                        notesFileSystem.updateNote(oldNote: note, newNote: NoteModel(message: message, date: date, color: Constants.colors[color]))
                    }
                    dismiss()
                } label: {
                    Text("Save")
                }
            }
            .padding()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 30) {
                TextEditor(text: $message)
                    .font(.title3)
                    .shadow(color: .primary, radius: 1)
                    .padding()
                    .frame(height: UIScreen.main.bounds.height/2 - 200)
                
                DatePicker("Date", selection: $date, in: ...Date.now,displayedComponents: .date)
                
                VStack(spacing: 10) {
                    Text("Color")
                    
                    Picker(selection: $color) {
                        Text("Blue")
                            .tag(0)
                        
                        Text("Green")
                            .tag(1)
                        
                        Text("Orange")
                            .tag(2)
                        
                        Text("Purple")
                            .tag(3)
                        
                        Text("Skin")
                            .tag(4)
                    } label: {
                        Text("")
                            .background(Color(Constants.colors[color]))
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onAppear {
                        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(Constants.colors[color]))
                    }
                    .id(color)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal)
            .onAppear {
                message = note.message
                date = note.date
                color = Constants.colors.firstIndex(of: note.color) ?? 0
            }
        }
        .navigationBarBackButtonHidden()
    }
}
