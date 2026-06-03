//
//  GrupResultView.swift
//  ProjectChallenge13
//
//  Created by anshu Li on 20/05/26.
//

import SwiftUI
import CloudKit

struct GroupResultView: View {
    @StateObject private var vm = GroupViewModel.shared
    @State var ckViewModel = LoginViewModel.shared
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) var dismiss
    let viewModelCalendar = CalendarViewModel()

    var group: ItemViewModel
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    VStack{
                        HStack{
                            Text("Melhor Data")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                        .frame(width: 345)
                        
                        if group.dates.isEmpty {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(width: 344)
                                    .shadow(color: .black.opacity(0.16), radius: 2, x: 2, y: 6)
                                
                                Text("Calendário sem nenhuma entrada")
                                    .padding()
                                    .foregroundStyle(.ultramarineBlue)
                            }
                        }
                        else {
                            CalendarView(dates: group.dates)
                        }
                    }
                    .padding(.top, 36)
                    
                    VStack(spacing:10){
                        HStack{
                            Text("Melhor Horário")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                        .frame(width: 345)
                        .padding(.bottom, 27)
                        
                        if group.dates.isEmpty {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(width: 344)
                                    .shadow(color: .black.opacity(0.16), radius: 2, x: 2, y: 6)
                                
                                Text("Horários sem nenhuma entrada")
                                    .padding()
                                    .foregroundStyle(.ultramarineBlue)
                            }
                        }
                        else {
                            TimeLineView(mostFrequncyDate: viewModelCalendar.mostFrequencyDate(dates: group.dates), secondFrequncyDate: viewModelCalendar.secondFrequencyDate(dates: group.dates), datefilterArray: viewModelCalendar.filterDate(dates: group.dates, day: viewModelCalendar.mostFrequencyDate(dates: group.dates)), dates: group.dates)
                        }
                    }
                    .padding(.top, 36)
                    
                    VStack{
                        HStack{
                            Text("Melhor Atividade")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.gray)
                            Spacer()
                        }.frame(width: 345)
                        WordCloudView(group: group)
                    }
                    .padding(.top, 36)
                    
                    Button{
                        ckViewModel.fetchAndDeletePreference()
                    }label: {
                        Text("deletar conta")
                    }
                    
                }
            }
        }
        .navigationTitle("Resultados do Grupo")
        .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
                .alert("Deseja deletar o grupo?", isPresented: $showDeleteAlert) {
                    Button("Apagar", role: .destructive) {
                        guard let record = vm.records.first(where: {
                            $0.recordID == group.recordId
                        }) else { return }

                        Task {
                            await vm.deleteGroup(record: record)
                            dismiss()
                        }
                    }
                    Button("Cancelar", role: .cancel) {}
                } message: {
                    Text("Os dados do seu grupo serão apagados.\nEssa ação não poderá ser desfeita.")
                }
    }
}

//#Preview {
//    GrupResultView()
//}
