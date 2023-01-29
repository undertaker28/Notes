//
//  View+Modifier.swift
//  Notes
//
//  Created by Pavel on 29.01.23.
//

import SwiftUI

extension View {
    func swipeDeleteCustomModifier(action: @escaping () -> Void) -> some View {
        self.modifier(NoteCellDragGestureView(action: action))
    }
}

struct NoteCellDragGestureView: ViewModifier {
    @GestureState private var slideOffset: CGSize = CGSize.zero
    @State private var position: CGFloat = 0
    @State private var deleteButtonIsHidden = true
    
    var action: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .offset(x: slideOffset.width + position)
                .gesture(DragGesture()
                    .updating($slideOffset, body: { dragValue, slideOffset, transaction in
                        if dragValue.translation.width < 0 &&
                            dragValue.translation.width > -55 &&
                            self.position != -55 {
                            slideOffset = dragValue.translation
                        }
                    })
                    .onEnded({ dragValue in
                        if dragValue.translation.width < 0 {
                            withAnimation(.linear) {
                                self.position = -55
                                deleteButtonIsHidden = false
                            }
                        } else {
                            withAnimation(.linear) {
                                self.position = 0
                                deleteButtonIsHidden = true
                            }
                        }
                    })
                )
                .animation(.linear)
            
            if !deleteButtonIsHidden {
                HStack(spacing: 0) {
                    Spacer()
                    Button {
                        action()
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                    }
                    .frame(width: 55, height: UIScreen.main.bounds.height / 6)
                    .contentShape(RoundedRectangle(cornerRadius: 15))
                    .onTapGesture {
                        action()
                    }
                }
            }
        }
    }
}
