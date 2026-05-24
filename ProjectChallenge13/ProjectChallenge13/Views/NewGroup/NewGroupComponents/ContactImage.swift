//
//  ContactImage.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 23/05/26.
//

import SwiftUI
import ContactsUI

struct ContactImage: View {
    @Environment(ContactsViewModel.self) private var contactsVM

    var contact: CNContact
    
    var body: some View {
        Button {
            contactsVM.selectedContacts.removeAll(where: { $0.identifier == contact.identifier })
        } label: {
            ZStack {
                if let imageData = contact.thumbnailImageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 70)
                        .padding(.trailing, 12)
                }
                else {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 70)
                        
                        Text(contact.givenName.prefix(1).uppercased())
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 12)
                }
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.white, .gray)
                    .font(.system(size: 20))
                    .padding(.leading, 35)
                    .padding(.top, 50)
            }
        }
        .padding(.bottom)
    }
}
