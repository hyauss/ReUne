//
//  GroupCardComponent.swift
//  ProjectChallenge13
//
//  Created by Carolina Sun on 22/05/26.
//

import SwiftUI

struct GroupCardComponent: View {
    var groupNumber: Int
    var item: ItemViewModel

    private var categories: [String] { item.categories.map { $0.name } }
    private var membersCount: Int { item.users.count }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 344)
                .shadow(color: .black.opacity(0.16), radius: 2, x: 2, y: 6)

            VStack(alignment: .leading, spacing: 12) {
                ZStack(alignment: .topTrailing) {
                    let coverWidth: CGFloat = 320
                    let coverImageName = (groupNumber % 2 == 0) ? "darkGroupCover" : "groupCover"

                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                        .frame(width: coverWidth, height: 120)
                        .overlay(
                            Image(coverImageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: coverWidth, height: 120)
                        )
                        .mask(RoundedRectangle(cornerRadius: 16))

                    HStack(spacing: 6) {
                        Text("\(membersCount)")
                            .font(.subheadline).bold()
                            .foregroundColor(.black)
                        Image(systemName: "person.2.fill")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .padding([.top, .trailing], 12
                    )
                }
                .padding(.top, 12)
                .padding(.horizontal, 12)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Grupo \(groupNumber)")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 16)

                    HStack(spacing: 12) {
                        ForEach(Array(categories.prefix(2).enumerated()), id: \.element) { idx, cat in
                            Text(cat)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                                .background(
                                    Group {
                                        if idx == 0 {
                                            Color("nightBlue")
                                        } else if idx == 1 {
                                            Color("ultramarineBlue")
                                        } else {
                                            Color("nightBlue")
                                        }
                                    }
                                )
                                .clipShape(Capsule())
                        }

            
                        if categories.count > 2 {
                            let extra = categories.count - 2
                            Text("+\(extra)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.leading, 4)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
            .frame(width: 344)
        }
    }
}
