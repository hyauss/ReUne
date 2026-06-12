//
//  PayWallView.swift
//  ProjectChallenge13
//
//  Created by Rafael Neves de Oliveira on 12/06/26.
//

import SwiftUI
import StoreKit

struct PremiumPaywallView: View {
    @StateObject private var store = StoreKitManager.shared
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.yellow)
                    .padding(.top, 40)

                Text("Grupos Ilimitados")
                    .font(.largeTitle.bold())

                Text("Você atingiu o limite de 5 grupos no plano gratuito.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            VStack(alignment: .leading, spacing: 14) {
                BenefitRow(icon: "infinity",        text: "Grupos ilimitados")
                BenefitRow(icon: "bell.badge.fill", text: "Notificações prioritárias")
                BenefitRow(icon: "crown.fill",      text: "Suporte ao desenvolvedor")
            }
            .padding(24)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 24)
            .padding(.top, 32)

            Spacer()

            VStack(spacing: 12) {
                purchaseButton
                restoreButton
                dismissButton
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .onChange(of: store.isPremium) { isPremium in
            if isPremium { dismiss() }
        }
    }


    @ViewBuilder
    private var purchaseButton: some View {
        if store.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity)
                .frame(height: 54)
        } else if let product = store.products.first {
            Button {
                Task { try? await store.purchase(product) }
            } label: {
                VStack(spacing: 2) {
                    Text("Assinar Premium")
                        .font(.headline)
                    Text("\(product.displayPrice)/mês")
                        .font(.caption)
                        .opacity(0.85)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(.yellow)
                .foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        } else {
            RoundedRectangle(cornerRadius: 14)
                .fill(.secondary.opacity(0.2))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .overlay {
                    ProgressView()
                }
        }
    }

    private var restoreButton: some View {
        Button("Restaurar compras") {
            Task { await store.restorePurchases() }
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
        .disabled(store.isLoading)
    }

    private var dismissButton: some View {
        Button("Agora não") {
            dismiss()
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
    }
}
