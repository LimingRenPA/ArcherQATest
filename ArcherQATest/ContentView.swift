//
//  ContentView.swift
//  ArcherQATest
//
//  Created by Liming Ren on 11/22/23.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        Button("Show Preview") {
            // Action that runs when the button is tapped goes here...
        }
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        var tankAnchor: TinyToyTank._TinyToyTank?
        
        
        let arView = ARView(frame: .zero)
        
        // Create a new anchor to add content to
        let anchor = AnchorEntity()
        arView.scene.anchors.append(anchor)
        
        // Add a dice entity
        let cup = //try! ModelEntity.loadModel(named: "Dice")
        try!ModelEntity.loadModel(named: "cup_saucer_set")
        let size = cup.visualBounds(relativeTo: cup).extents
        let boxShape = ShapeResource.generateBox(size: size)
        
        cup.collision = CollisionComponent(shapes: [boxShape])
        cup.scale = [0.02, 0.02, 0.02]
        cup.position = SIMD3<Float>(0.3,0.5,-1);
        cup.physicsBody = PhysicsBodyComponent(
            massProperties: .init(shape: boxShape, mass: 50),
            material: nil,
            mode: .dynamic
        )
        
        // Create a plane below the dice
        let planeMesh = MeshResource.generatePlane(width: 2, depth: 2) //meters
        let material = SimpleMaterial(color: .init(white: 1.0, alpha: 0.1), isMetallic: false)
        let planeEntity = ModelEntity(mesh: planeMesh, materials: [material])
        planeEntity.position = SIMD3<Float>(0.3,0.5,-1);
        planeEntity.physicsBody = PhysicsBodyComponent(massProperties: .default, material: nil, mode: .static)
        planeEntity.collision = CollisionComponent(shapes: [.generateBox(width: 2, height: 0.001, depth: 2)])
        //planeEntity.position = focusEntity.position
        anchor.addChild(planeEntity)
        
        anchor.addChild(cup)
        
        
        // 2
        tankAnchor = try! TinyToyTank.load_TinyToyTank()
        // 3
        arView.scene.anchors.append(tankAnchor!)
        
        // Original code
        //        let arView = ARView(frame: .zero)
        //
        //        // Create a cube model
        //        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        //        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
        //        let model = ModelEntity(mesh: mesh, materials: [material])
        //
        //        // Create horizontal plane anchor for the content
        //        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        //        anchor.children.append(model)
        //
        //        // Add the horizontal plane anchor to the scene
        //        arView.scene.anchors.append(anchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    ContentView()
}
