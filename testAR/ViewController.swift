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
    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var resultText: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var timer: Timer!
    var timer2: Timer!
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
        resultText.isHidden = true
        backButton.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.timerUpdate2), userInfo: nil, repeats: true)
        scoreText.text = "スコア: " + String(score)
        sceneView.scene.physicsWorld.contactDelegate = self as SCNPhysicsContactDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        if !isPlaying {
            return
        }
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
        
        let particle = SCNParticleSystem(named: "broken.scnp", inDirectory: "art.scnassets")
        let particleNode = SCNNode()
        particleNode.addParticleSystem(particle!)
        
        if (nodeA.name == "onigiri" && nodeB.name == "bullet") || (nodeA.name == "bullet" && nodeB.name == "onigiri") {
            score += 1
            DispatchQueue.main.async {
                self.scoreText.text = "スコア: " + String(self.score)
                if nodeA.name == "onigiri" {
                    particleNode.position = nodeA.position
                    self.sceneView.scene.rootNode.addChildNode(particleNode)
                    nodeA.removeFromParentNode()
                    nodeB.removeFromParentNode()
                } else {
                    particleNode.position = nodeB.position
                    self.sceneView.scene.rootNode.addChildNode(particleNode)
                    nodeA.removeFromParentNode()
                    nodeB.removeFromParentNode()
                }
                nodeA.removeFromParentNode()
                nodeB.removeFromParentNode()
            }
        } else if (nodeA.name == "package" && nodeB.name == "bullet") || (nodeA.name == "bullet" && nodeB.name == "puckage"){
            score += 5
            DispatchQueue.main.async {
                self.scoreText.text = "スコア: " + String(self.score)
                if nodeA.name == "package" {
                    particleNode.position = nodeA.position
                    self.sceneView.scene.rootNode.addChildNode(particleNode)
                    nodeA.removeFromParentNode()
                    nodeB.removeFromParentNode()
                } else {
                    particleNode.position = nodeB.position
                    self.sceneView.scene.rootNode.addChildNode(particleNode)
                    nodeA.removeFromParentNode()
                    nodeB.removeFromParentNode()
                }
                nodeA.removeFromParentNode()
                nodeB.removeFromParentNode()
            }
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
            if timerCnt <= 0 {
                timer?.invalidate()
                finish()
            }
        }
        print(timerCnt)
    }
    
    @objc
    func timerUpdate2() {
        if isPlaying {
            let num = Int.random(in: 1 ... 100)
            if num % 12 == 0 {
                makeOnigiriPackage()
            } else {
                makeOnigiri()
            }
        } else {
            return
        }
    }
    
    func finish() {
        text.text = "おわり！"
        isPlaying = false
        scoreText.isHidden = true
        resultText.isHidden = false
        resultText.text = "スコア: " + String(score)
        backButton.isHidden = false
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let targetPath = documentPath + "/score.txt"
        let output = OutputStream(toFileAtPath: targetPath, append: true)
        output?.open()
        let bytes = [UInt8]("$\(score)".data(using: .utf8)!)
        let size = "$\(score)".lengthOfBytes(using: .utf8)
        output?.write(bytes, maxLength: size)
        output?.close()
        
        rankAction()
    }
    
    func rankAction(){
        let httpSession = HttpClientImpl()
        let url:URL = URL(string: insert_url)!
        let req = NSMutableURLRequest(url: url)
        req.httpMethod = "POST"
        req.httpBody = ("name=\(UIDevice.current.name)&&point=\(score)").data(using: .utf8)
        let (data, _, _) = httpSession.execute(request: req as URLRequest)
        if data != nil {
            print("受信結果 \n\(String(data: data!, encoding: String.Encoding.utf8)!)")
            
        }
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
    
    func makeOnigiriPackage() {
        let randx = Float.random(in: -3 ... 3)
        let randy = Float.random(in: -3 ... 3)
        let randz = Float.random(in: -3 ... 3)
        
        let imagePlane = SCNPlane(width: 0.5, height: 0.5)
        imagePlane.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/package.png")
        imagePlane.firstMaterial?.lightingModel = .constant
        let planeNode = SCNNode(geometry: imagePlane)
        planeNode.name = "package"
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
    @IBAction func backTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
