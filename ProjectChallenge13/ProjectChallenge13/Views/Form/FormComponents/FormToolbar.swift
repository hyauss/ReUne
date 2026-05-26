//
//  FormToolbar.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 26/05/26.
//

import Foundation
import SwiftUI

struct FormToolbar: View {
    var body: some View {
        NavigationStack {
            Text("")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            Button {
                                
                            } label: {
                                Image(systemName: "checkmark")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    
                    //                ToolbarItem(placement: .cancellationAction) {
                    //                    Button {
                    //
                    //                    } label: {
                    //                        Image(systemName: "xmark")
                    //                    }
                    //                }
                }
        }
    }
}

#Preview {
    FormToolbar()
}
