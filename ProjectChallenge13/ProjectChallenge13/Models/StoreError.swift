//
//  StoreError.swift
//  ProjectChallenge13
//
//  Created by Rafael Neves de Oliveira on 12/06/26.
//

import Foundation

enum StoreError: Error, LocalizedError {
    case failedVerification
    case productNotFound
    case purchaseFailed(reason: String)

    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "Não foi possível verificar a compra com a App Store."
        case .productNotFound:
            return "Produto não encontrado. Tente novamente mais tarde."
        case .purchaseFailed(let reason):
            return "Falha na compra: \(reason)"
        }
    }
}
