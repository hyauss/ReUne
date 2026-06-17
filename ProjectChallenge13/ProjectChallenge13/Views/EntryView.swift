//
//  EntryView.swift
//  NotADiary
//
//  Created by Pedro Augusto on 06/10/25.
//

import SwiftUI
import CloudKit

struct EntryView: View {
    @StateObject var viewModel = EntryViewModel()

    @State var ckViewModel = LoginViewModel.shared
    @State var notificationVM = PushNotificationViewModel.shared
        
    @State var cloudKitAlert: Bool = false
    @State var notificationAlert: Bool = false
    
    @State private var isLoading: Bool = true
    
    var body: some View {
        if isLoading {
            loadingView()
        } else if ckViewModel.isLogged{
            HomeView()
        }
        else {
            if !ckViewModel.isLogged {
                NavigationStack {
                    Text("")
                        .onAppear() {
                            cloudKitAlert.toggle()
                            notificationAlert.toggle()
                        }
                        .alert("Permitir utilizar seu iCloud para identificação?", isPresented: $cloudKitAlert) {
                            Button {
                                ckViewModel.createPreference(name: "")
                            } label: {
                                Text("Permitir")
                            }
                            Button(role: .cancel) {
                                
                            } label: {
                                Text("Não Permitir")
                            }
                        } message: {
                            Text("Usaremos suas informações do iCloud para identificar sua conta em nosso app.")
                        }
                        .alert("Permitir o ReUne enviar notificações?", isPresented: $notificationAlert) {
                            Button {
                                notificationVM.requestNotificationPermission()
                                notificationVM.permitionState = true
                            } label: {
                                Text("Permitir")
                            }
                            Button(role: .cancel) {
                                notificationVM.permitionState = false
                            } label: {
                                Text("Não Permitir")
                            }
                        } message: {
                            Text("Enviaremos notificações a respeito dos grupos criados e resultados de votação.")
                        }
                }
            }
            if(!ckViewModel.isLogged){
                VStack(spacing: 8) {
                    Image(systemName: "icloud.slash")
                        .font(.largeTitle)

                    Text("Uma conta iCloud não está configurada no dispositivo.")
                        .font(.headline)

                    Text("Por favor configure uma conta iCloud no seu dispositivo e reabra o aplicativo.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button{
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                                   UIApplication.shared.open(url)
                               }
                    }label: {
                        Text("Configurar iCloud")
                    }
                        .padding()
                }
                .multilineTextAlignment(.center)
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding()
            }
            
        }
    }
    
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
}


#Preview {
    EntryView()
}
