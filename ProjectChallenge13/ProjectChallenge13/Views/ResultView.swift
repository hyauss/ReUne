//
//  ResultView.swift
//  ProjectChallenge13
//
//  Created by Carolina Sun on 22/05/26.
//

import SwiftUI
import CloudKit

struct ResultView: View {
    let group: ItemViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Resultados para o Grupo: \(group.recordId?.recordName ?? "Sem ID")")
                    .font(.headline)
                CalendarView()
                // outras coisas de resultado
            }
            .navigationTitle("Resultados do Grupo")
        }
    }
}

//#Preview {
//    ResultView()
//}
