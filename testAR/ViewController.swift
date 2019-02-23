//
//  ViewController.swift
//  testAR
//
//  Created by ymgn on 2019/02/22.
//  Copyright © 2019 ymgn. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    override var prefersStatusBarHidden: Bool { return true }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide}
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var imageView: UIImageView!
    
    private var timer: Timer?
    private var timer2: Timer?
    private var timerCnt: Int = 30
    private var timerCnt2: Int = 0
    public var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard ARFaceTrackingConfiguration.isSupported else {
            return
        }
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    @IBAction func handletap(_ sender: Any) {
        let imagePlane = SCNPlane(width: 0.3, height: 0.3)
        imagePlane.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/onigiri.png")
        imagePlane.firstMaterial?.lightingModel = .constant
        let planeNode = SCNNode(geometry: imagePlane)
        planeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        let position = SCNVector3(x: 0, y: 0, z: -0.5)
        if let camera = sceneView.pointOfView {
            planeNode.position = camera.convertPosition(position, to: nil)
            planeNode.eulerAngles = camera.eulerAngles
            
//            planeNode.physicsBody?.applyForce(camera.eulerAngles, asImpulse: true)
        }
        sceneView.scene.rootNode.addChildNode(planeNode)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
