//
//  AddNoteView.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    
    @Binding var showAddPage: Bool
    
    @State private var message: String = ""
    @State private var date: Date = Date.now
    @State private var color: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    showAddPage.toggle()
                } label: {
                    Text("Cancel")
                }
                Spacer(minLength: 0)
                
                Text("Add note")
                
                Spacer(minLength: 0)
                
                Button {
                    DataController().addNote(message: message, date: date, color: Constants.colors[color], context: managedObjContext)
                    withAnimation(.spring()) { showAddPage.toggle() }
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
        }
        .interactiveDismissDisabled()
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView(showAddPage: .constant(true))
    }
}
