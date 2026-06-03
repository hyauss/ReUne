//
//  EntryView.swift
//  NotADiary
//
//  Created by Pedro Augusto on 06/10/25.
//

import SwiftUI
import CloudKit

struct EntryView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var ckViewModel = LoginViewModel.shared
    @StateObject private var vmNotification = PushNotificationViewModel.shared
    @StateObject var viewModel = EntryViewModel()
    
    @State private var isLoading: Bool = true
    @State private var wasClicked: Bool = false
    @State private var showingAlert1: Bool = false
    @State private var showingAlert2: Bool = false
    @State private var isLoadingLocal: Bool = false

    
    @State private var state: Int = 0
    
    @ViewBuilder func loadingView() -> some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .primary))
            .scaleEffect(2.0, anchor: .center)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    isLoading = false
                }
            }
    }
    
    var body: some View {
        if isLoading {
            loadingView()
        } else if ckViewModel.isLogged{
            HomeView()
        }
        else {
            if state == 0 {
                if !ckViewModel.isLogged {
                    NavigationStack {
                        VStack {
                            Text("Já tem uma conta ou deseja criar uma?")
                                .font(.title2)
                            
                            HStack {
                                Button {
                                    if !ckViewModel.isLogged {
                                        showingAlert1 = true
                                    }
                                    else {
                                        state = 1
                                        isLoading = true
                                    }
                                } label: {
                                    Text("Já tenho")
                                        .foregroundStyle(.nightBlue)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.formCardBack)
                                //.foregroundStyle(.formCardBack)
                                .alert("Ainda não possui conta :(", isPresented: $showingAlert1) {
                                    Button("OK", role: .confirm) {}
                                } message: {
                                    Text("Você não possui uma conta ou não está conectado ao iCloud")
                                }
                                
                                Button {
                                    if !viewModel.isSignedInToiCloud || ckViewModel.isLogged {
                                        showingAlert2 = true
                                    }
                                    else {
                                        vmNotification.requestNotificationPermission()
                                        state = 2
                                        isLoading = true
                                    }
                                } label: {
                                    Text("Ainda não tenho")
                                        .foregroundStyle(.nightBlue)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.formCardBack)
                                .alert("Já possui conta", isPresented: $showingAlert2) {
                                    Button("OK", role: .confirm) {}
                                } message: {
                                    Text("Você não está conectado no iCloud")
                                    Text("ou já possui uma conta!")
                                }
                            }
                        }
                        .navigationTitle("Boas vindas")
                    }
                }
//                Button{
//                    ckViewModel.fetchAndDeletePreference()
//                }label: {
//                    Text("deletar conta")
//                }
            }
            else {
                if isLoading {
                    loadingView()
                }
                else {
                    if state == 1 {
                        
                    }
                    else if state == 2 {
                        OnboardingView(state: $state, isLoading: $isLoading)
                            .environment(ckViewModel)
                    }
                }
                
            }
            
            
        }
    }
}


#Preview {
    EntryView()
}
