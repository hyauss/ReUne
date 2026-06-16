//
//  AdManager.swift
//  ProjectChallenge13
//
//  Created by Rafael Neves de Oliveira on 12/06/26.
//

import GoogleMobileAds
import SwiftUI
import Combine

@MainActor
class AdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    static let shared = AdManager()

    // Substitua pelos IDs reais do AdMob ao publicar
    // Para testes, esses IDs do Google sempre retornam anúncio
    private let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"

    private var interstitial: InterstitialAd?
    @Published var isAdReady: Bool = false
    @Published var isShowingAd: Bool = false

    @AppStorage("groupEntryCount") private var groupEntryCount: Int = 0

    override init() {
        super.init()
        Task { await loadAd() }
    }

    func loadAd() async {
        do {
            interstitial = try await InterstitialAd.load(
                with: interstitialAdUnitID,
                request: Request()
            )
            interstitial?.fullScreenContentDelegate = self
            isAdReady = true
        } catch {
            print("AdMob: falha ao carregar anúncio — \(error.localizedDescription)")
            isAdReady = false
        }
    }

    func showAdAfterVoting(completion: @escaping () -> Void) {
        guard let interstitial,
              let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first?.rootViewController else {
            completion()
            return
        }

        isShowingAd = true
        self.onAdDismissed = completion
        interstitial.present(from: root)
    }

    func trackGroupEntryAndShowAdIfNeeded(completion: @escaping () -> Void) {
        groupEntryCount += 1

        if groupEntryCount >= 3 {
            groupEntryCount = 0
            showAdAfterVoting(completion: completion)
        } else {
            completion()
        }
    }

    private var onAdDismissed: (() -> Void)?

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        isShowingAd = false
        onAdDismissed?()
        onAdDismissed = nil
        Task { await loadAd() }
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        isShowingAd = false
        onAdDismissed?() 
        onAdDismissed = nil
        Task { await loadAd() }
    }
}
