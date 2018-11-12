//
//  ViewController.swift
//  Poke3D
//
//  Created by Hector Mendoza on 9/23/18.
//  Copyright © 2018 Hector Mendoza. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            
            configuration.maximumNumberOfTrackedImages = 2
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let planeNode = createPlaneNode(with: imageAnchor)
            
            node.addChildNode(planeNode)
            
            if let imageName = imageAnchor.referenceImage.name {
                createPokeScene(with: imageName, at: planeNode)
            }
        }
        
        return node
    }
    
    func createPlaneNode(with imageAnchor: ARImageAnchor) -> SCNNode {
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        
        plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2
        
        return planeNode
    }
    
    func createPokeScene(with imageName: String, at planeNode: SCNNode) {
        var pokeName: String = ""
        
        switch imageName {
        case "id-card":
            pokeName = "eevee"
        case "autozone-card":
            pokeName = "oddish"
        default:
            pokeName = ""
        }
        
        if let pokeScene = SCNScene(named: "art.scnassets/\(pokeName).scn") {
            if let pokeNode = pokeScene.rootNode.childNodes.first {
                pokeNode.eulerAngles.x = .pi / 2
                
                planeNode.addChildNode(pokeNode)
            }
        }
    }
}
