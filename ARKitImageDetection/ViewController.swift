/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Main view controller for the AR experience.
 */

import ARKit
import SceneKit
import UIKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var player : AVPlayer?
    
    let configuration = ARWorldTrackingConfiguration()
    
    
    let videoNode = SCNNode(geometry: SCNPlane())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set delegate so renderer fn gets called
        sceneView.delegate = self
        // type of plane detection
        configuration.planeDetection = .vertical
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        configuration.detectionImages = referenceImages
        
        // run, requests camera access first run
        sceneView.session.run(configuration,  options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Okaay, let's gooo")
    }
    
    func createNode(imageAnchor: ARImageAnchor) -> SCNNode {
        
        
        let referenceImage = imageAnchor.referenceImage
        
        // set width & height
        videoNode.geometry?.setValue(CGFloat(referenceImage.physicalSize.width), forKey: "width")  //Play around to get correct size
        videoNode.geometry?.setValue(CGFloat(referenceImage.physicalSize.height) , forKey: "height") //Play around to get correct size
        
        videoNode.geometry?.firstMaterial?.isDoubleSided = true
//        videoNode.position = SCNVector3(referenceImage.center.x, referenceImage.center.y, referenceImage.center.z)
        
        videoNode.eulerAngles.x = -.pi / 2
        
        videoNode.runAction(self.imageHighlightAction)
        
        return videoNode
    }
    
    // This delegate fires when an anchor is added whenever an ARAnchor was added to the sceneview. An anchor encodes position, size and orientation of something ... the surface in this case.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        print("New surface detected")
        
        // Video
        let videoURL = Bundle.main.url(forResource: "slamstoxAnimation", withExtension: "mp4")!
        player = AVPlayer(url: videoURL)
        videoNode.geometry?.firstMaterial?.diffuse.contents = player
        player!.play()
        
        
        if (player?.timeControlStatus == AVPlayer.TimeControlStatus.playing) {
            print("playing, so not creating a new node")
            
        } else {
            // ... we proceed creating and adding the scene node
            let childNode = createNode(imageAnchor: imageAnchor)
            node.addChildNode(childNode)
        }
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
//        print("Surface updated")
//
//        if (player?.timeControlStatus == AVPlayer.TimeControlStatus.playing) {
//
//            print("playing, so not updating nodes")
//
//        } else {
//            // remove all
//            node.enumerateChildNodes { (childNode, _) in
//                childNode.removeFromParentNode()
//            }
//            // add back
//            let childNode = createNode(planeAnchor: planeAnchor )
//            node.addChildNode(childNode)
//        }
//    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("Surface anchor removed")
        // pause player
        player!.pause()
        
        // remove all
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
    
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 1, duration: 8.5),
            .fadeOpacity(to: 0, duration: 0.1),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
        ])
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}
