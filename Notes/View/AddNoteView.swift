//
//  AddNoteView.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import SwiftUI

struct AddNoteView: View {
    @ObservedObject var notesSQLite = SQLiteNoteService.shared
    @ObservedObject var notesFileSystem = FileSystemNoteService.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var id: Int = 0
    @State private var message: String = ""
    @State private var date: Date = Date.now
    @State private var color: Int = 0
    
    var mode: Int
    
    var body: some View {
        VStack {            
            Divider()
            
            VStack(alignment: .center, spacing: 30) {
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
                HStack {
                    Button(action: {
                        switch mode {
                        case 0:
                            notesSQLite.addNote(note: NoteModel(message: message, date: date, color: Constants.colors[color]))
                        case 1:
                            notesFileSystem.addNote(note: NoteModel(message: message, date: date, color: Constants.colors[color]))
                        default:
                            notesFileSystem.addNote(note: NoteModel(message: message, date: date, color: Constants.colors[color]))
                        }
                        dismiss()
                    }) {
                        Text("Save")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 30)
                    }
                    .background(.black)
                    .cornerRadius(.infinity)
                    .padding()
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal)
            .navigationTitle(Text("Add note"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled()
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView(mode: 0)
    }
}
