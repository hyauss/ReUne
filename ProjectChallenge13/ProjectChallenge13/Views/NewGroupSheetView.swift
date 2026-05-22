//
//  NewGroupSheetView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import SwiftUI

//TODO: Contacts Button Animation
var participante: [String] = ["person", "person", "person", "person", "person", "person", "person"]
struct NewGroupSheetView: View {
    @State var selectedCategory: Set<String> = []
    @State var contactButtonIsPressed: Bool = false
    
    var viewModel = NewGroupViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Adicione participante no seu grupo")
                    .padding(.leading, 29)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(participante, id: \.self) { invite in
                            Image(invite)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .frame(width: 70)
                                .padding(.trailing, 12)
                        }
                    }
                    .padding(.leading, 29)
                    
                }
                Button {
                } label: {
                    PlusButton()
                        .padding(.leading, 48)
                        .padding(.bottom, 10)
                }
                    

                Text("Quais categorias você gostaria de adicionar?")
                    .padding(.leading, 29)
                
               CategoriesMenu(selectedCategory: $selectedCategory)
                
                ForEach(Array(selectedCategory), id: \.self) { category in
                    Text(category)
                        .foregroundStyle(.newGroupCategoriesText)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 5)
                        .background(.newGroupCategoriesBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 90))
                        .padding(.leading, 48)
                }
                Spacer()
                
                NewGroupToolbar()
            }
        }
    }
}

#Preview {
    NewGroupSheetView(selectedCategory: [])
}
