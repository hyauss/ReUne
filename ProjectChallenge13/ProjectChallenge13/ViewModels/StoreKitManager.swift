//
//  StoreKitManager.swift
//  ProjectChallenge13
//
//  Created by Rafael Neves de Oliveira on 12/06/26.
//

import StoreKit
import SwiftUI
import Combine

@MainActor
class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()
    
    // Coloque aqui o Product ID que você criou no App Store Connect
    private let productIDs: Set<String> = ["com.reune.premiumtest.monthly"]
    
    @Published var products: [Product] = []
    @Published var isPremium: Bool = false
    @Published var isLoading: Bool = false
    
    private var transactionListener: Task<Void, Error>?
    
    init() {
        transactionListener = listenForTransactions()
        Task {
            await loadProducts()
            await updatePurchaseStatus()
        }
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    // MARK: - Carregar produtos da App Store
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("Erro ao carregar produtos: \(error)")
        }
    }
    
    // MARK: - Realizar compra
    func purchase(_ product: Product) async throws {
        isLoading = true
        defer { isLoading = false }
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updatePurchaseStatus()
            await transaction.finish()
        case .userCancelled:
            break
        case .pending:
            break
        @unknown default:
            break
        }
    }
    
    // MARK: - Restaurar compras
    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await AppStore.sync()
            await updatePurchaseStatus()
        } catch {
            print("Erro ao restaurar: \(error)")
        }
    }
    
    // MARK: - Verificar se é premium
    func updatePurchaseStatus() async {
        var hasPremium = false
        
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if productIDs.contains(transaction.productID) && !transaction.isExpired {
                    hasPremium = true
                }
            }
        }
        
        isPremium = hasPremium
    }
    
    // MARK: - Escutar transações em tempo real (renovações, etc.)
    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    await self.updatePurchaseStatus()
                    await transaction.finish()
                } catch {
                    print("Transação inválida: \(error)")
                }
            }
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let value):
            return value
        }
    }
    
    var isExpired: Bool {
        return !isPremium
    }
}

extension StoreKit.Transaction {
    var isExpired: Bool {
        if let expirationDate = expirationDate {
            return expirationDate < Date()
        }
        return false
    }
}
