//
//  FormView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 25/05/26.
//

import SwiftUI

struct FormView: View {
    @State var formVM = FormViewModel()
    
    let dateRange: ClosedRange<Date> = {
        let now = Date.now
        return now...Calendar.current.date(byAdding: .day, value: 2000, to: now)!
    }()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Complete com suas preferências sobre o evento")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom, 26)
                
                Text("Data e Horário")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.newGroupCategoriesText)
                
                ForEach(formVM.dateList.enumerated(), id: \.offset) { i, date in
                    DatePicker("", selection: $formVM.dateList[i], in: dateRange)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button {
                    formVM.dateList.append(Date())
                } label: {
                    PlusButton()
                        .padding(.bottom, 40)
                        .padding(.top)
                }
                .onChange(of: formVM.dateList) {
                    print(formVM.dateList)
                }

                Text("Atividades")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.newGroupCategoriesText)
                
                PlusButton()
                    .padding(.bottom, 40)

                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    FormView()
}
