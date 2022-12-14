//
//  OpenSourceView.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/06/05.
//

import SwiftUI
import KuringCommons

struct OpenSourceView: View {
    
    var body: some View {
        
        List {
            ForEach(Opensource.list, id: \.self) { opensource in
                if let url = URL(string: opensource.link) {
                    Link(destination: url) {
                        HStack {
                            HStack {
                                Text("ð " + opensource.name)
                                
                                if !opensource.isUsed {
                                    Text("ðsay.. goodBye")
                                        .font(.caption2)
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 2)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                }
                            }
                            .foregroundColor(
                                opensource.isUsed
                                ? ColorSet.Label.primary.color
                                : ColorSet.Label.secondary.color
                            )
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                                .foregroundColor(ColorSet.Label.tertiary.color)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("ð¡ ìê°ëë¤ ð¡")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct OpenSourceView_Previews: PreviewProvider {
    static var previews: some View {
        OpenSourceView()
        OpenSourceView().preferredColorScheme(.dark)
        
    }
}
