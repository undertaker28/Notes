//
//  CardView.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import SwiftUI

struct CardView: View {
    @State var noteDate: Date = Date.now
    @State var noteMessage: String = "Muchas gracias aficiónados esto para vosotros. Síííííuuuuuuu!!!"
    @State var noteColor: String = "Blue"
    
    var body: some View {
        VStack {
            Text(noteMessage)
                .font(.title3)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text(noteDate, style: .date)
                    .foregroundColor(.secondary)
                    .opacity(0.8)
                Spacer(minLength: 0)
                Button {
                    
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
        .background(Color(noteColor))
        .cornerRadius(18)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
