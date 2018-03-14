//
//  ViewController.swift
//  SXSW
//
//  Created by Stuart Olivera on 3/13/18.
//  Copyright © 2018 Stuart Olivera. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import PopupDialog
import OpenGLES

class ViewController: UIViewController, ARSCNViewDelegate, SCNNodeRendererDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var eventPreviewView: UIView!
    @IBOutlet weak var hintLabel: UILabel!
    var spaceship: SCNNode? = nil
    var shipText: SCNNode? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self

        eventPreviewView.layer.cornerRadius = 5;
        eventPreviewView.layer.masksToBounds = true;

        hintLabel.layer.cornerRadius = 8;
        hintLabel.layer.masksToBounds = true;
        let tap = UITapGestureRecognizer(target: self, action: #selector(reset))
        hintLabel.addGestureRecognizer(tap)

        // Setup interaction
        initInteraction()
    }
    
    @IBAction func openLink() {
        if let link = URL(string: "https://www.sxsw.com/") {
            UIApplication.shared.open(link)
        }
    }
    
    @objc func reset() {
        print("reset")
    }

    func initInteraction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        sceneView.addGestureRecognizer(tap);
    }

    @objc func handleTap(rec: UITapGestureRecognizer) {
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: sceneView)
            let hits = self.sceneView.hitTest(location)
            if !hits.isEmpty && hits[0].node.name != "plane" {
                let name = hits[0].node.name
                
                if name == "marshmello" {
                    self.presentOffer(rarity: Rarity.Common, offer: "20% off all Marshmello merchandise")
                } else if name == "hat" {
                    self.presentOffer(rarity: Rarity.Rare, offer: "Westworld Season 1 Collector's Edition")
                } else if name == "Body" {
                    self.presentOffer(rarity: Rarity.Legendary, offer: "VIP Invitation to Ready Player One Premiere")
                }
            }
        }
    }

    func presentOffer(rarity: Rarity, offer: String) {
        let viewController = OfferViewController(rarity: rarity, offer: offer)
        self.present(viewController, animated: true, completion: {
            self.sceneView.session.pause()
            self.sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            self.stopTimer()
            self.shipText = nil
            self.spaceship = nil
        })
    }
    
    func showItemDialog() {
        // Prepare the popup assets
        let title = "THIS IS THE DIALOG TITLE"
        let message = "This is the message section of the popup dialog default view"
        let image = UIImage(named: "pexels-photo-103290")

        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)

        // Create buttons
        let buttonOne = DefaultButton(title: "OKAY") {
            print("Dismissed.")
        }

        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne])

        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        
        DispatchQueue.main.async {
            // Create a plane to visualize the initial position of the detected image.
            let plane = SCNPlane(width: referenceImage.physicalSize.width,
                                 height: referenceImage.physicalSize.height)
            // plane.materials[0].diffuse.contents = UIColor(red: 243/256.0, green: 232/256.0, blue: 220/256.0, alpha: 1)
            plane.materials[0].diffuse.contents = UIColor.black

            let planeNode = SCNNode(geometry: plane)
            
            planeNode.scale.x *= 1.25
            planeNode.scale.y *= 1.25
            planeNode.scale.z *= 1.25
            
            planeNode.name = "plane"
            
            planeNode.opacity = 0.95
            
            /*
             `SCNPlane` is vertically oriented in its local coordinate space, but
             `ARImageAnchor` assumes the image is horizontal in its local space, so
             rotate the plane to match.
             */
            planeNode.eulerAngles.x = -.pi / 2
            
            /*
             Image anchors are not tracked after initial detection, so create an
             animation that limits the duration for which the plane visualization appears.
             */
//            planeNode.runAction(self.imageHighlightAction)
            
            // Add the plane visualization to the scene.
            node.addChildNode(planeNode)
            
            // Create a new scene
            let marshmelloScene = SCNScene(named: "art.scnassets/Marshmello.scn")!
            
            if let shipNode = marshmelloScene.rootNode.childNode(withName: "Boole_1_Plastic", recursively: true) {
                shipNode.scale = SCNVector3(0.000075, 0.000075, 0.000075)
                shipNode.position = SCNVector3(-0.025, 0.05, 0)
                shipNode.name = "marshmello"
                
                let action = SCNAction.rotateBy(x: 0.5, y: 0.1, z: 0, duration: 0.25)
                action.timingMode = .easeInEaseOut
                let reversed = action.reversed()
                let sequence = SCNAction.sequence([action, reversed])
                let forever = SCNAction.repeatForever(sequence)
                
                shipNode.runAction(forever)
                
                let actionHorizontal = SCNAction.rotateBy(x: 0.0, y: 0.25, z: 0, duration: 0.5)
                action.timingMode = .easeInEaseOut
                let reversedHorizontal = actionHorizontal.reversed()
                let sequenceHorizontal = SCNAction.sequence([actionHorizontal, reversedHorizontal])
                let foreverHorizontal = SCNAction.repeatForever(sequenceHorizontal)
                
                shipNode.runAction(foreverHorizontal)
                
                node.addChildNode(shipNode)
                
                
                let cylinder = SCNCylinder(radius: 0.017, height: 0.01)
                cylinder.materials[0].diffuse.contents = Colors.Blue
                cylinder.materials[0].fillMode = SCNFillMode.lines
                let cylinderNode = SCNNode(geometry: cylinder)
                cylinderNode.position = SCNVector3(-0.025, 0, 0)
                node.addChildNode(cylinderNode)
                
                let text = SCNText(string: "Westworld", extrusionDepth: 1)
                text.font = UIFont(name: "Apercu-Regular", size: 100)
                text.firstMaterial?.diffuse.contents = UIColor.white
                text.firstMaterial?.specular.contents = UIColor.white
                text.firstMaterial?.isDoubleSided = true

                let textNode = SCNNode(geometry: text)
                textNode.scale = SCNVector3(0.000075, 0.000075, 0.000075)
                textNode.position = SCNVector3(0.006,0,0.025)
                
                node.addChildNode(textNode)
            }
            
            // Create a new scene
            let scene = SCNScene(named: "art.scnassets/hat.scn")!
            
            if let shipNode = scene.rootNode.childNode(withName: "g_SheriffHat_Mesh", recursively: true) {
                shipNode.scale = SCNVector3(0.0125, 0.0125, 0.0125)
                shipNode.position = SCNVector3(0.025, 0.05, 0)
                shipNode.name = "hat"
                
                let action = SCNAction.moveBy(x: 0, y: 0.005, z: 0, duration: 1.0)
                action.timingMode = .easeInEaseOut
                let reversedAction = action.reversed()
                let sequence = SCNAction.sequence([action, reversedAction])
                let forever = SCNAction.repeatForever(sequence)
                
                shipNode.runAction(forever)
                node.addChildNode(shipNode)
                
                
                let cylinder = SCNCylinder(radius: 0.017, height: 0.01)
                cylinder.materials[0].diffuse.contents = Colors.Orange
                cylinder.materials[0].fillMode = SCNFillMode.lines
                let cylinderNode = SCNNode(geometry: cylinder)
                cylinderNode.position = SCNVector3(0.025, 0, 0)
                node.addChildNode(cylinderNode)
                
                let text = SCNText(string: "Marshmello", extrusionDepth: 1)
                text.font = UIFont(name: "Apercu-Regular", size: 100)
                text.firstMaterial?.diffuse.contents = UIColor.white
                text.firstMaterial?.specular.contents = UIColor.white
                text.firstMaterial?.isDoubleSided = true
                
                let textNode = SCNNode(geometry: text)
                textNode.scale = SCNVector3(0.000075, 0.000075, 0.000075)
                textNode.position = SCNVector3(-0.045,0,0.025)
                
                node.addChildNode(textNode)
            }
            
            let rocketScene = SCNScene(named: "art.scnassets/arkit-rocket.scn")!
            
            if let shipNode = rocketScene.rootNode.childNode(withName: "Rocket", recursively: true) {
                shipNode.scale = SCNVector3(0.075, 0.075, 0.075)
                shipNode.position = SCNVector3(0, 0.13, 0)
                
                let rotateAction = SCNAction.rotateBy(x: 1.9, y: 2.4, z: 0, duration: 0)
                shipNode.runAction(rotateAction)
                
                let action = SCNAction.moveBy(x: 0, y: 0.005, z: 0, duration: 1.0)
                action.timingMode = .easeInEaseOut
                let reversedAction = action.reversed()
                let sequence = SCNAction.sequence([action, reversedAction])
                let forever = SCNAction.repeatForever(sequence)
                
                shipNode.runAction(forever)
                self.spaceship = shipNode
                self.spaceship!.name = "ship"
                node.addChildNode(shipNode)
                
                
                let cylinder = SCNCylinder(radius: 0.017, height: 0.01)
                cylinder.materials[0].diffuse.contents = Colors.Orange
                cylinder.materials[0].fillMode = SCNFillMode.lines
                let cylinderNode = SCNNode(geometry: cylinder)
                cylinderNode.position = SCNVector3(0.025, 0, 0)
                node.addChildNode(cylinderNode)

                let text = SCNText(string: "Ready Player One", extrusionDepth: 1)
                text.font = UIFont(name: "Apercu-Regular", size: 100)
                text.firstMaterial?.diffuse.contents = UIColor.white
                text.firstMaterial?.specular.contents = UIColor.white
                text.firstMaterial?.isDoubleSided = true

                let textNode = SCNNode(geometry: text)
                textNode.scale = SCNVector3(0.000075, 0.000075, 0.000075)
                textNode.position = SCNVector3(0,0.1,0)
                self.shipText = textNode
                
                node.addChildNode(textNode)
            }
            
            self.startTimer()
        }
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
    
    weak var timer: Timer?
    var counter: Float = 0
    
    func startTimer() {
        timer?.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            self.counter += 0.01
            guard let ship = self.spaceship else { return }
            guard let text = self.shipText else { return }
            
            let radius: Float = 0.05
            
            let x = cosf(-self.counter) * radius
            let z = sinf(-self.counter) * radius
            
            ship.position.x = x
            ship.position.z = z
            text.position.x = x - 0.03
            text.position.z = z
            
            let rotateAction = SCNAction.rotateTo(x: 2, y: CGFloat(self.counter + 2.25), z: 0, duration: 0.01)
            ship.runAction(rotateAction)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    // if appropriate, make sure to stop your timer in `deinit`
    
    deinit {
        stopTimer()
    }
    
    // MARK: - SCNNodeRendererDelegate
}
