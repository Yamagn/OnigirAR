import MultipeerConnectivity

class MultiPeerSession : NSObject {
    let serviceType = "OnigiriAR"
    
    var blowser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    var session: MCSession!
    var peerID: MCPeerID!
}
