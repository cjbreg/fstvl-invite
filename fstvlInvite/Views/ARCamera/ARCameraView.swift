//
//  ContentView.swift
//  IosWorkshopAr
//
//  Created by Quan on 14/12/2021.
//

import SwiftUI
import RealityKit
import ARKit

struct ARCameraView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {

    let arView = ARView(frame: .zero)

    func makeCoordinator() -> Coordinator {
        Coordinator(arView: arView)
    }

    func makeUIView(context: Context) -> ARView {

        let config = ARImageTrackingConfiguration()
        config.maximumNumberOfTrackedImages = 1
        config.isAutoFocusEnabled = true

        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }

        config.trackingImages = trackingImages

        arView.session.delegate = context.coordinator

        arView.session.run(config, options: [])


        return arView

    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    class Coordinator: NSObject, ARSessionDelegate {

        let arView:ARView!
        var avPlayer = AVPlayer()

        init(arView: ARView){
            self.arView = arView
        }

        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            for anchor in anchors {
                if let imageAnchor = anchor as? ARImageAnchor {
                    if imageAnchor.isTracked{
                        avPlayer.play()
                    } else {
                        avPlayer.pause()
                    }
                }
            }
        }

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]){

            for anchor in anchors {
                if let imageAnchor = anchor as? ARImageAnchor {

                    let anchorEntity = AnchorEntity(anchor: imageAnchor)

                    let width = Float(imageAnchor.referenceImage.physicalSize.width)
                    let height = Float(imageAnchor.referenceImage.physicalSize.height)

                    guard let videoUrl = URL(string: "https://i399015.hera.fhict.nl/invite-video.mp4") else {
                        fatalError("Video not found")
                    }

                    let playerItem = AVPlayerItem(url: videoUrl)
                    avPlayer.replaceCurrentItem(with: playerItem)
                    let videoMaterial = VideoMaterial(avPlayer: avPlayer)

                    avPlayer.automaticallyWaitsToMinimizeStalling = false
                    avPlayer.play()


                    let modelEntity = ModelEntity(mesh: .generatePlane(width: width, depth: height), materials: [videoMaterial])

                    anchorEntity.addChild(modelEntity)

                    arView.scene.addAnchor(anchorEntity)
                }

            }

        }

    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ARCameraView()
    }
}
#endif
