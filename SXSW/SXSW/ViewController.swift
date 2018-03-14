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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self

        eventPreviewView.layer.cornerRadius = 5;
        eventPreviewView.layer.masksToBounds = true;

        // Setup interaction
        initInteraction()
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
                // let tappedNode = hits.first?.node
                self.presentOffer()
            }
        }
    }

    func presentOffer() {
        let viewController = OfferViewController()
        self.present(viewController, animated: true, completion: {
            self.sceneView.session.pause()
            self.sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
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
            plane.materials[0].diffuse.contents = UIColor(red: 243/256.0, green: 232/256.0, blue: 220/256.0, alpha: 1)

            let planeNode = SCNNode(geometry: plane)
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
            let scene = SCNScene(named: "art.scnassets/ship.scn")!
            
            if let shipNode = scene.rootNode.childNode(withName: "ship", recursively: true) {
                let shipMesh = shipNode.childNode(withName: "shipMesh", recursively: true)!
                
                shipNode.scale = SCNVector3(0.5, 0.5, 0.5)
                shipNode.position = SCNVector3(0, 0.01, 0)
                
                let action = SCNAction.moveBy(x: 0, y: 0.005, z: 0, duration: 1.0)
                action.timingMode = .easeInEaseOut
                let reversedAction = action.reversed()
                let sequence = SCNAction.sequence([action, reversedAction])
                let forever = SCNAction.repeatForever(sequence)
                
                shipNode.runAction(forever)
                node.addChildNode(shipNode)
                
                
                let cylinder = SCNCylinder(radius: 0.017, height: 0.01)
                cylinder.materials[0].diffuse.contents = UIColor.blue
                cylinder.materials[0].fillMode = SCNFillMode.lines
                let cylinderNode = SCNNode(geometry: cylinder)
                cylinderNode.position = SCNVector3(0, 0, 0)
                node.addChildNode(cylinderNode)
            }
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
    
    // MARK: - SCNNodeRendererDelegate
}
