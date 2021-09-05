//
//  Bullet.swift
//  KamikazeWar
//
//  Created by Osvaldo Chaparro on 09/05/2021.
//

import ARKit

class Bullet: SCNNode {
    let speed: Float = 9

    init(_ camera: ARCamera) {
        super.init()
        
        //Forma
        let bullet = SCNSphere(radius: 0.02)
        //material
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        bullet.materials = [material]
        //asigno forma a geometry del node
        self.geometry = bullet
        
        //Forma física
        let shape = SCNPhysicsShape(geometry: bullet, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        self.physicsBody?.restitution = 0.0
        
        //Defino con quien colisiona
        self.physicsBody?.categoryBitMask = Collisions.bullet.rawValue
        self.physicsBody?.contactTestBitMask = Collisions.plane.rawValue
        
        
        //Posición y movimiento
        let matrix = SCNMatrix4(camera.transform)
        let v = -self.speed
        let dir = SCNVector3(v * matrix.m31, v * matrix.m32, v * matrix.m33)
        let pos = SCNVector3(matrix.m41, matrix.m42, matrix.m43)

        self.position = pos
        self.physicsBody?.applyForce(dir, asImpulse: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
