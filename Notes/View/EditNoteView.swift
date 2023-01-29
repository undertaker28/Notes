//
//  EditNoteView.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import SwiftUI

struct EditNoteView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var message: String = ""
    @State private var date: Date = Date.now
    @State private var color: Int = 0
    var note: FetchedResults<Note>.Element
    
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
                    CoreDataController().editNote(note: note, message: message, date: date, color: Constants.colors[color], context: managedObjContext)
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
                message = note.message!
                date = note.date!
                color = Constants.colors.firstIndex(of: note.color!) ?? 0
            }
        }
        .navigationBarBackButtonHidden()
    }
}
