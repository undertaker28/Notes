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
                    NotesScrollView()
                }
                AddNoteButton()
            }
            .sheet(isPresented: $showAddPage) {
                AddNoteView(showAddPage: $showAddPage)
            }
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
        .onChange(of: searchText) { val in
            notes.nsPredicate = searchPredicate(query: val)
        }
    }
    
    private func searchPredicate(query: String) -> NSPredicate? {
        if query.isEmpty {
            return nil
        }
        return NSPredicate(format:
                            "%K BEGINSWITH[cd] %@ OR %K CONTAINS[cd] %@ OR %K BEGINSWITH[cd] %@",
                           #keyPath(Note.message), query, #keyPath(Note.date), query,
                           #keyPath(Note.color), query)
    }
    
    @ViewBuilder
    func AddNoteButton() -> some View {
        Button(action: {
            withAnimation(.spring()) { showAddPage = true }
        }) {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(.white)
                .padding(17)
                .background(.black)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding()
        .padding(.trailing, 20)
    }
    
    @ViewBuilder
    func NotesScrollView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 30) {
                ForEach(notes) { note in
                    NavigationLink {
                        //AddNoteView(showAddPage: <#Binding<Bool>#>)
                    } label: {
                        CardView(note: note)
                    }
                }
                .listRowBackground(Color.blue)
            }
            .padding(.top, 20)
            .padding(.horizontal)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
