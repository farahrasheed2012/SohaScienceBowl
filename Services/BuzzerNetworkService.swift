import Foundation
import MultipeerConnectivity
#if canImport(UIKit)
import UIKit
#endif

/// Local-network buzzer: Mac hosts a drill, iPhone sends a buzz signal.
@MainActor
@Observable
final class BuzzerNetworkService: NSObject {
    static let shared = BuzzerNetworkService()
    private static let serviceType = "sbcoachbuzz"

    private(set) var isHosting = false
    private(set) var isBrowsing = false
    private(set) var isConnected = false
    private(set) var connectedPeerName: String?
    private(set) var remoteBuzzCount = 0
    var onRemoteBuzz: (() -> Void)?

    private var peerID = MCPeerID(displayName: Host.currentDisplayName)
    private var session: MCSession?
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?

    private override init() {
        super.init()
    }

    func startHosting() {
        stopAll()
        peerID = MCPeerID(displayName: Host.currentDisplayName)
        let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        session.delegate = self
        self.session = session

        let advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: ["role": "host"], serviceType: Self.serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        self.advertiser = advertiser
        isHosting = true
    }

    func startBrowsing() {
        stopAll()
        peerID = MCPeerID(displayName: Host.currentDisplayName)
        let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        session.delegate = self
        self.session = session

        let browser = MCNearbyServiceBrowser(peer: peerID, serviceType: Self.serviceType)
        browser.delegate = self
        browser.startBrowsingForPeers()
        self.browser = browser
        isBrowsing = true
    }

    func sendBuzz() {
        guard let session, !session.connectedPeers.isEmpty else { return }
        let data = Data("buzz".utf8)
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }

    func stopAll() {
        advertiser?.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()
        session?.disconnect()
        advertiser = nil
        browser = nil
        session = nil
        isHosting = false
        isBrowsing = false
        isConnected = false
        connectedPeerName = nil
        remoteBuzzCount = 0
    }

    private enum Host {
        static var currentDisplayName: String {
            #if os(iOS)
            return UIDevice.current.name
            #else
            return HostName.current() ?? "Science Bowl Mac"
            #endif
        }
    }
}

#if os(macOS)
import AppKit

private enum HostName {
    static func current() -> String? {
        Host.current().localizedName
    }
}
#endif

extension BuzzerNetworkService: MCSessionDelegate {
    nonisolated func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        Task { @MainActor in
            isConnected = !session.connectedPeers.isEmpty
            connectedPeerName = session.connectedPeers.first?.displayName
        }
    }

    nonisolated func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard String(data: data, encoding: .utf8) == "buzz" else { return }
        Task { @MainActor in
            remoteBuzzCount += 1
            onRemoteBuzz?()
        }
    }

    nonisolated func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    nonisolated func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    nonisolated func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

extension BuzzerNetworkService: MCNearbyServiceAdvertiserDelegate {
    nonisolated func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        Task { @MainActor in
            invitationHandler(true, session)
        }
    }
}

extension BuzzerNetworkService: MCNearbyServiceBrowserDelegate {
    nonisolated func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        Task { @MainActor in
            guard let session else { return }
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        }
    }

    nonisolated func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {}
}
