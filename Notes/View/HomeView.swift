//
//  HomeView.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import SwiftUI

struct HomeView: View {
    @State var showAddPage: Bool = false
    @State var searchText: String = ""
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var notes: FetchedResults<Note>
    @Environment(\.managedObjectContext) var managedObjContext
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 15) {
                
                    //notesScrollView
                }
                //buttonAddNote
            }
//            .sheet(isPresented: $mainViewModel.isNewNote) {
//                NoteCreateAndEditView(viewModel:
//                                        NoteCreateAndEditViewModel(isNewNote:
//                                                                    mainViewModel.isNewNote),
//                                      editTextContent: "")
//            }
            .navigationTitle(Text("Notes"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {

                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .background(Color("Background").edgesIgnoringSafeArea(.all))
        }
        .searchable(text: $searchText, prompt: "Looking for something...")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
