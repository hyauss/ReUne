//
//  Onboarding.swift
//  NotADiary
//
//  Created by Francisco Losada on 08/10/25.
//

import SwiftUI

struct OnboardingView: View {
    @State var name: String = ""
    @Binding var state: Int
    @Binding var isLoading: Bool
    
    @Environment(LoginViewModel.self) var ckViewModel: LoginViewModel
    
    var body: some View {
        GeometryReader { g in
            NavigationStack {
                VStack {
                    Text("Como você gostaria de ser chamado?")
                        .font(.title3)
                        
                        .bold()
                        .padding(.top, 50)
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: g.size.width * 0.95, height: 56)
                            .overlay(
                                TextField("Nome..", text: $name)
                                    .padding(.leading, 16)
                            )
                    }
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Cadastro")
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                                if name != "" {
                                    ckViewModel.createPreference(name: name)
                                    state = 1
                                    isLoading = true
                                }
                                else if name != "" {
                                    state = 1
                                    isLoading = true
                                }
                            } label: {
                            Text("Salvar")
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    @Previewable @State var ckViewModel = LoginViewModel()
    @Previewable @State var isLoading = false
    @Previewable @State var state = 0
    OnboardingView(name: "", state: $state, isLoading: $isLoading)
        .environment(ckViewModel)
}
