import GoogleMobileAds
import UIKit

class AdsManager: NSObject, FullScreenContentDelegate {
    static let shared = AdsManager()
    
    private var gameOverInterstitial: InterstitialAd?
    private var timedInterstitial: InterstitialAd?
    
    private var lastTimedAdShown: Date = Date()
    private let timeInterval: TimeInterval = 90 // 1.5 minutes
    
    // Test Ad Unit ID: ca-app-pub-3940256099942544/4411468910
    // Real Game Over Ad Unit ID: ca-app-pub-9857318611224113/8957835913
    let gameOverAdUnitID = "ca-app-pub-3940256099942544/4411468910"
    
    // Real Timed Ad Unit ID: ca-app-pub-9857318611224113/3329280304
    let timedAdUnitID = "ca-app-pub-3940256099942544/4411468910"
    
    override private init() {
        super.init()
        loadGameOverInterstitial()
        loadTimedInterstitial()
    }
    
    // MARK: - Game Over Ad
    func loadGameOverInterstitial() {
        let request = Request()
        InterstitialAd.load(with: gameOverAdUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load game over interstitial: \(error.localizedDescription)")
                return
            }
            self?.gameOverInterstitial = ad
            self?.gameOverInterstitial?.fullScreenContentDelegate = self
        }
    }
    
    func showGameOverInterstitial() {
        showAd(gameOverInterstitial)
    }
    
    // MARK: - Timed Ad
    func loadTimedInterstitial() {
        let request = Request()
        InterstitialAd.load(with: timedAdUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load timed interstitial: \(error.localizedDescription)")
                return
            }
            self?.timedInterstitial = ad
            self?.timedInterstitial?.fullScreenContentDelegate = self
        }
    }
    
    func checkAndShowTimedAd() {
        let now = Date()
        if now.timeIntervalSince(lastTimedAdShown) >= timeInterval {
            if timedInterstitial != nil {
                showAd(timedInterstitial)
                lastTimedAdShown = Date() // Reset timer
            } else {
                print("Timed ad not ready yet")
                loadTimedInterstitial()
            }
        }
    }
    
    // MARK: - Helper
    private func showAd(_ ad: InterstitialAd?) {
        if let ad = ad {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let root = windowScene.windows.first?.rootViewController {
                ad.present(from: root)
            }
        } else {
            print("Ad wasn't ready")
            loadGameOverInterstitial()
            loadTimedInterstitial()
        }
    }
    
    // MARK: - GADFullScreenContentDelegate
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Ad dismissed")
        // Reload the specific ad that was dismissed
        // Note: `ad` is a protocol type, so strict identity check against our properties might need casting or assumption.
        // Or simply reload both if they are nil/used.
        
        // Simple strategy: check if properties are 'used' (presented ads usually aren't nil-ed out automatically in the property, 
        // but they can't be reused). The SDK requires fetching a NEW ad object.
        
        // Since we can't easily equate the protocol `ad` to our specific `InterstitialAd` instance 
        // (unless we cast or keep references carefully), let's just try to reload both if they seem stale
        // or just reload generally.
        // Actually `ad` IS the instance.
        
        if let ad = ad as? InterstitialAd {
            if ad === gameOverInterstitial {
                loadGameOverInterstitial()
            } else if ad === timedInterstitial {
                loadTimedInterstitial()
            }
        }
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad failed to present: \(error.localizedDescription)")
        if let ad = ad as? InterstitialAd {
             if ad === gameOverInterstitial {
                 loadGameOverInterstitial()
             } else if ad === timedInterstitial {
                 loadTimedInterstitial()
             }
        }
    }
}
