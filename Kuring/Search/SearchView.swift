//
//  SearchView.swift
//  KuringLite
//
//  Created by Jaesung Lee on 2022/06/05.
//
import SwiftUI
import KuringSDK
import KuringCommons

struct SearchView: View {
    @StateObject private var engine = SearchEngine()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(ColorSet.green.color)
                    
                    TextField("검색어를 입력해주세요", text: $engine.searchText)
                }
                .padding(.horizontal, 20)
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(ColorSet.green.color, lineWidth: 1)
                )
                .padding([.horizontal, .top], 16)
                
                HStack(spacing: 10) {
                    ForEach(Searcher.SearchType.allCases, id: \.self) {
                        SearchTypeColumn(
                            engine: engine,
                            searchType: $0
                        )
                    }
                }
                ScrollView(showsIndicators: false) {
                    SearchedResultList(engine: engine)
                }
            }
            .onAppear { engine.start() }
            .onChange(of: engine.searchText) { newValue in
                engine.search()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("🔍 검색하기")
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
        SearchView().preferredColorScheme(.dark)
    }
}
