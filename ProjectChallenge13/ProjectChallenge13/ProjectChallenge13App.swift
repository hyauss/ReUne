//
//  ProjectChallenge13App.swift
//  ProjectChallenge13
//
//  Created by Vinicius Marques on 14/05/26.
//

import SwiftUI
import CloudKit
import Aptabase

@main
struct ProjectChallenge13App: App {
    @StateObject private var vm =  GroupViewModel.shared
    @State var ckViewModel = LoginViewModel.shared
    @State private var showLogin = false
    
    init() {
        Aptabase.shared.initialize(appKey: "A-US-8107330164") // 👈 this is where you enter your App Key
    }
    
    var body: some Scene {
        WindowGroup {
            //            AptabaseTesteView()
            HomeView()
            ContentView()
                .sheet(isPresented: $showLogin) {
                    EntryView()
                }
                .onOpenURL { url in
                    print(url)
                    guard let recordID = url.host else {
                        return
                    }
                    
                    print(recordID)
                    Task{
                        do{
                            let groupRecord = try await vm.fetchGroupsWithId(groupID: recordID)
                            var group = EventGroup.fromRecord(groupRecord)
                            if(ckViewModel.isLogged){
                                group?.users.insert(ckViewModel.preference?.userID ?? "Não Logado")
                                groupRecord["users"] = Array(group?.users ?? [])
                                await vm.save(groupRecord: groupRecord)
                            }else{
                                //ei voce nao esta logado
                                showLogin = true
                            }
                        }
                        catch{
                            print(error.localizedDescription)
                        }
                    }
                }
        }
    }
}
