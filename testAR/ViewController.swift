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

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {
    
    override var prefersStatusBarHidden: Bool { return true }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide}
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var text: UILabel!
    
    var timer: Timer!
    var timerCnt: Int = 30
    var timerCnt2: Int = 3
    var score: Int = 0
    var isPlaying: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: true)
        sceneView.scene.physicsWorld.contactDelegate = self as! SCNPhysicsContactDelegate
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
        timer.invalidate()
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func handletap(_ sender: Any) {
        let bullet = SCNSphere(radius: 0.05)
        bullet.segmentCount = 10
        bullet.firstMaterial?.diffuse.contents = UIColor.black
        let shape = SCNPhysicsShape(geometry: bullet, options: nil)
        let bulletNode = SCNNode(geometry: bullet)
        bulletNode.name = "bullet"
        bulletNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        bulletNode.physicsBody?.contactTestBitMask = 1
        bulletNode.physicsBody?.isAffectedByGravity = false
        let position = SCNVector3(x: 0, y: 0, z: -0.5)
        if let camera = sceneView.pointOfView {
            bulletNode.position = camera.convertPosition(position, to: nil)
            bulletNode.eulerAngles = camera.eulerAngles
            let mat = camera.transform
            let dir = SCNVector3(-10 * mat.m31, -10 * mat.m32, -10 * mat.m33)
            bulletNode.physicsBody?.applyForce(dir, asImpulse: true)
        }
        sceneView.scene.rootNode.addChildNode(bulletNode)
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        if (nodeA.name == "onigiri" && nodeB.name == "bullet") || (nodeA.name == "bullet" && nodeB.name == "onigiri") {
            
        }
    }
    
    @objc func timerUpdate() {
        if !isPlaying {
            timerCnt2 -= 1
            text.text = String(timerCnt2)
            if timerCnt2 == 0 {
                text.text = "はじめ！"
                isPlaying = true
            }
        } else {
            timerCnt -= 1
            text.text = String(timerCnt)
            makeOnigiri()
            if timerCnt <= 0 {
                timer?.invalidate()
                finish()
            }
        }
        print(timerCnt)
    }
    
    func finish() {
        text.text = "おわり！"
        isPlaying = false
    }
    
    func makeOnigiri() {
        let randx = Float.random(in: -3 ... 3)
        let randy = Float.random(in: -3 ... 3)
        let randz = Float.random(in: -3 ... 3)
        
        let imagePlane = SCNPlane(width: 0.5, height: 0.5)
        imagePlane.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/onigiri.png")
        imagePlane.firstMaterial?.lightingModel = .constant
        let planeNode = SCNNode(geometry: imagePlane)
        planeNode.name = "onigiri"
        let shape = SCNPhysicsShape(geometry: imagePlane, options: nil)
        planeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        planeNode.physicsBody?.isAffectedByGravity = false
        let position = SCNVector3(x: randx, y: randy, z: randz)
        if let camera = sceneView.pointOfView {
            planeNode.position = camera.convertPosition(position, from: nil)
            planeNode.eulerAngles = camera.eulerAngles
        }
        sceneView.scene.rootNode.addChildNode(planeNode)
        print(planeNode.position)
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
