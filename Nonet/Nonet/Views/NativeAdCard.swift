import SwiftUI
import GoogleMobileAds

class NativeAdViewModel: NSObject, ObservableObject, NativeAdLoaderDelegate {
    @Published var nativeAd: NativeAd?
    private var adLoader: AdLoader!
    
    // Test Ad Unit ID: ca-app-pub-3940256099942544/3986624511
    // Real Ad Unit ID: ca-app-pub-9857318611224113/1715873782
    let adUnitID = "ca-app-pub-3940256099942544/3986624511"
    
    func refreshAd() {
        adLoader = AdLoader(
            adUnitID: adUnitID,
            rootViewController: nil,
            adTypes: [.native],
            options: nil
        )
        adLoader.delegate = self
        adLoader.load(Request())
    }
    
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        print("Native ad failed to load with error: \(error.localizedDescription)")
    }
    
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        self.nativeAd = nativeAd
    }
}

struct NativeAdCard: View {
    @StateObject private var viewModel = NativeAdViewModel()
    
    var body: some View {
        VStack {
            if let nativeAd = viewModel.nativeAd {
                NativeAdViewRepresentable(nativeAd: nativeAd)
                    .frame(height: 300) // Adjust height as needed
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
            } else {
                // Placeholder or empty view while loading
                Text("Ad Loading...")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(height: 50)
                    .onAppear {
                        viewModel.refreshAd()
                    }
            }
        }
    }
}

struct NativeAdViewRepresentable: UIViewRepresentable {
    let nativeAd: NativeAd
    
    func makeUIView(context: Context) -> GoogleMobileAds.NativeAdView {
        let nativeAdView = GoogleMobileAds.NativeAdView()
        
        // Create UI Components
        let headlineLabel = UILabel()
        headlineLabel.font = UIFont.boldSystemFont(ofSize: 17)
        headlineLabel.numberOfLines = 1
        
        let bodyLabel = UILabel()
        bodyLabel.font = UIFont.systemFont(ofSize: 14)
        bodyLabel.numberOfLines = 2
        bodyLabel.textColor = .secondaryLabel
        
        let callToActionButton = UIButton(type: .system)
        callToActionButton.backgroundColor = UIColor(named: "NonetBeige") ?? .systemBlue
        callToActionButton.setTitleColor(.white, for: .normal)
        callToActionButton.layer.cornerRadius = 5
        callToActionButton.clipsToBounds = true
        callToActionButton.isUserInteractionEnabled = false // Events handled by NativeAdView
        
        let iconImageView = UIImageView()
        iconImageView.layer.cornerRadius = 5
        iconImageView.clipsToBounds = true
        iconImageView.backgroundColor = .lightGray
        
        let advertiserLabel = UILabel()
        advertiserLabel.font = UIFont.systemFont(ofSize: 12)
        advertiserLabel.textColor = .secondaryLabel
        
        // Add to view hierarchy (Programmatically layout)
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        let topStack = UIStackView()
        topStack.axis = .horizontal
        topStack.spacing = 8
        topStack.alignment = .center
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.addArrangedSubview(headlineLabel)
        textStack.addArrangedSubview(advertiserLabel)
        
        topStack.addArrangedSubview(iconImageView)
        topStack.addArrangedSubview(textStack)
        
        let mediaView = MediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        mediaView.heightAnchor.constraint(equalToConstant: 150).isActive = true // Fixed height for media
        
        mainStack.addArrangedSubview(topStack)
        mainStack.addArrangedSubview(bodyLabel)
        mainStack.addArrangedSubview(mediaView)
        mainStack.addArrangedSubview(callToActionButton)
        
        nativeAdView.addSubview(mainStack)
        
        // Constraints
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: 10),
            mainStack.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -10),
            mainStack.topAnchor.constraint(equalTo: nativeAdView.topAnchor, constant: 10),
            mainStack.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor, constant: -10)
        ])
        
        // Bind config
        nativeAdView.nativeAd = nativeAd
        nativeAdView.headlineView = headlineLabel
        nativeAdView.bodyView = bodyLabel
        nativeAdView.callToActionView = callToActionButton
        nativeAdView.iconView = iconImageView
        nativeAdView.advertiserView = advertiserLabel
        nativeAdView.mediaView = mediaView
        
        // Populate Data
        headlineLabel.text = nativeAd.headline
        bodyLabel.text = nativeAd.body
        callToActionButton.setTitle(nativeAd.callToAction, for: .normal)
        iconImageView.image = nativeAd.icon?.image
        advertiserLabel.text = nativeAd.advertiser
        mediaView.mediaContent = nativeAd.mediaContent
        
        // Hide unused views
        callToActionButton.isHidden = nativeAd.callToAction == nil
        iconImageView.isHidden = nativeAd.icon == nil
        
        return nativeAdView
    }
    
    func updateUIView(_ uiView: GoogleMobileAds.NativeAdView, context: Context) {}
}
