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
    @State private var selectedNote: NoteModel = NoteModel(message: "", date: Date.now, color: "Blue")
    @State private var copied = false {
        didSet {
            if copied == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        copied = false
                    }
                }
            }
        }
    }
    // @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var notesFromCoreData: FetchedResults<Note>
    
    @ObservedObject var notesSQLite = SQLiteNoteService.shared
    @ObservedObject var notesFileSystem = FileSystemNoteService.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                if copied {
                    copiedButton()
                }
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
                            selectedNote = note
                            showingAlert = true
                        }
                        .alert("Please select an option", isPresented: $showingAlert) {
                            Button("Copy", role: .none) {
                                copyMessage(message: selectedNote.message)
                            }
                            Button("Share", role: .none) {
                                shareMessage(message: selectedNote.message)
                            }
                            Button("Cancel", role: .cancel) { }
                            Button("Delete", role: .destructive) {
                                removeData(note: selectedNote)
                            }
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
    
    @ViewBuilder
    func copiedButton() -> some View {
        HStack {
            Image(systemName: "link")
            Text("Copied to clipboard")
        }
        .fontWeight(.semibold)
        .foregroundColor(.black)
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(Color.white.cornerRadius(15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 0.5)
        )
        .position(x: UIScreen.main.bounds.width / 2)
        .transition(.move(edge: .top))
        .padding(.top)
        .animation(.easeInOut(duration: 1))
        .zIndex(1)
    }
    
    private func copyMessage(message: String) {
        withAnimation {
            copied = true
        }
        UIPasteboard.general.string = message
    }
    
    private func shareMessage(message: String) {
        let shareActivity = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            shareActivity.popoverPresentationController?.sourceView = viewController.view
            // Setup share activity position on screen on bottom center
            shareActivity.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
            shareActivity.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            viewController.present(shareActivity, animated: true, completion: nil)
        }
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
