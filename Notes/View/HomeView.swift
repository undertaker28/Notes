//
//  HomeView.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText: String = ""
    @State private var showingAlert = false
    @State private var mode: Int = 0
    
    // @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var notesFromCoreData: FetchedResults<Note>
    
    @ObservedObject var notesSQLite = SQLiteNoteService.shared
    @ObservedObject var notesFileSystem = FileSystemNoteService.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 15) {
                    switch mode {
                    case 0:
                        NotesScrollView(notes: notesSQLite.allNotes)
                    case 1:
                        NotesScrollView(notes: notesFileSystem.allNotes)
                    default:
                        NotesScrollView(notes: notesFileSystem.allNotes)
                    }
                }
                NavigationLink {
                    AddNoteView(mode: mode)
                } label: {
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
            .navigationTitle(Text("Notes"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker(selection: $mode, label: Text("Select the storage mode for notes")) {
                            Text("SQLite")
                                .tag(0)
                            Text("File system")
                                .tag(1)
                            Text("Firebase")
                                .tag(2)
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .background(Color("Background").edgesIgnoringSafeArea(.all))
        }
        .searchable(text: $searchText, prompt: "Looking for something...")
    }
    
    @ViewBuilder
    func NotesScrollView(notes: [NoteModel]) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 30) {
                ForEach(searchText == "" ? notes : notes.filter( {
                    $0.message.contains(searchText)
                })) { note in
                    CardView(note: note, mode: mode)
                        .swipeDeleteCustomModifier {
                            removeData(note: note)
                        }
                        .onLongPressGesture {
                            showingAlert = true
                        }
                        .actionSheet(isPresented: $showingAlert) {
                            ActionSheet(
                                title: Text("Select a color"),
                                buttons: [
                                    .default(Text("Red")) {
                                        print("test1")
                                    },

                                    .default(Text("Green")) {
                                        print("test2")
                                    },

                                    .default(Text("Blue")) {
                                        print("test3")
                                    },

                                    .cancel()
                                ]
                            )
                        }
                }
                .listRowBackground(Color.black)
            }
            .padding(.top, 20)
            .padding(.horizontal)
        }
        .onAppear(perform: {
            notesSQLite.getNotesList()
        })
    }
    
    private func removeData(note: NoteModel) {
        withAnimation {
            switch mode {
            case 0:
                notesSQLite.deleteNote(note: note)
            case 1:
                notesFileSystem.deleteNote(note: note)
            default:
                notesFileSystem.deleteNote(note: note)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
