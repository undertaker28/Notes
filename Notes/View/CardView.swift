//
//  CardView.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import SwiftUI

struct CardView: View {
    @StateObject var note: FetchedResults<Note>.Element

    var body: some View {
        VStack {
            Text(note.message ?? "")
                .font(.title3)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text(note.date ?? Date.now, style: .date)
                    .foregroundColor(.secondary)
                    .opacity(0.8)
                Spacer(minLength: 0)
                NavigationLink {
                    EditNoteView(note: note)
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 15, weight: .bold))
                        .padding(8)
                        .foregroundColor(.white)
                        .background(.black)
                        .clipShape(Circle())
                }
            }
            .padding(.top, 35)
        }
        .padding()
        .background(Color(note.color ?? "Blue"))
        .cornerRadius(18)
    }
}
