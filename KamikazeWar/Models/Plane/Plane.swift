//
//  Plane.swift
//  KamikazeWar
//
//  Created by Osvaldo Chaparro on 07/05/2021.
//

import ARKit

protocol planeBehavior{
    func removeLive()
}

class Plane: SCNNode, planeBehavior {
    
    var difficulty = Difficulty()
    var didFinishMoving: ((_ plane: Plane) -> Void)?
    
    init(_ camera: ARCamera?) {
        super.init()

        let scene = SCNScene(named: "ship.scn")
        guard let plane = scene?.rootNode.childNode(withName: "ship", recursively: true) else { return }

        self.addChildNode(plane)
        
        addHearts()
        
        self.transform.m41 = Float.random(in: -5...5) // X
        self.transform.m42 = Float.random(in: -1.5...1.5) // Y
        self.transform.m43 = Float.random(in: -10 ... -5) // Z
      
        let shape = SCNPhysicsShape(node: plane, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .kinematic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.categoryBitMask = Collisions.plane.rawValue
        self.physicsBody?.collisionBitMask = Collisions.bullet.rawValue
        
        let balanceUp = SCNAction.moveBy(x: 0, y: CGFloat(difficulty.maxBalance), z: 0, duration: TimeInterval(difficulty.balanceSpeed))
        let balanceDown = SCNAction.moveBy(x: 0, y: -CGFloat(difficulty.maxBalance), z: 0, duration: TimeInterval(difficulty.balanceSpeed))
        let balanceSequence = SCNAction.sequence([balanceUp, balanceDown])
        let balance = SCNAction.repeatForever(balanceSequence)
        self.runAction(balance)
        
        if let cameraColumns = camera?.transform.columns {
            let vectorToColumns = SCNVector3(cameraColumns.3.x, cameraColumns.3.y, cameraColumns.3.z)
            let moveToCamera = SCNAction.move(to: vectorToColumns, duration: TimeInterval(difficulty.planeSpeed))

            self.runAction(moveToCamera) { [weak self] in
                guard let self = self else { return }
                self.didFinishMoving?(self)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func face(to cameraOrientation: simd_float4x4) {
        var transform = cameraOrientation
        transform.columns.3.x = self.position.x
        transform.columns.3.y = self.position.y
        transform.columns.3.z = self.position.z
        self.transform = SCNMatrix4(transform)
    }
    
    func addHearts() {
        if (difficulty.lives>0) {
            let sceneHeart = SCNScene(named: "Heart.scn")
            guard let heart = sceneHeart?.rootNode.childNode(withName: "Heart", recursively: true) else { return }
            for index in 1...difficulty.lives {
                let heartX: Float = 0.15 * Float(index)
                var heartNode = SCNNode()
                heartNode = heart.clone()
                heartNode.scale = SCNVector3(0.00035, 0.00035, 0.00035)
                heartNode.position = SCNVector3(-0.5+heartX, 0.2, -1)
                self.addChildNode(heartNode)
            }
        }
    }
    
    func removeLive(){
        self.difficulty.lives -= 1
        let lastHeart = self.childNodes.filter( {$0.name == "Heart"} ).last
        lastHeart?.removeFromParentNode()
    }
    
}
