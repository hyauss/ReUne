//
//  ResultView.swift
//  ProjectChallenge13
//
//  Created by Carolina Sun on 22/05/26.
//

import SwiftUI

struct ResultView: View {
    let group: EventGroup
    
    var body: some View {
        NavigationStack{
            VStack{
                CalendarView()
                //TimeView()
                //WordCloudView()
            }
            .navigationTitle("Resultados do Grupo")
        }
    }
}

#Preview {
    ResultView()
}
