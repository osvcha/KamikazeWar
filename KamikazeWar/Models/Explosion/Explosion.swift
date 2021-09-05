//
//  Explosion.swift
//  KamikazeWar
//
//  Created by Osvaldo Chaparro on 08/05/2021.
//

import ARKit

class Explosion: SCNNode {
    static func show(with node: SCNNode, in scene: SCNScene) {
        guard let explosion = SCNParticleSystem(named: "Explossion", inDirectory: nil) else { return }
        let p = node.presentation.position
        let translationMatrix = SCNMatrix4MakeTranslation(p.x, p.y, p.z)
        let r = node.rotation
        let rotationMAtrix = SCNMatrix4MakeRotation(r.w, r.x, r.y, r.z)
        let transformMatrix = SCNMatrix4Mult(rotationMAtrix, translationMatrix)
        explosion.emitterShape = node.geometry
        scene.addParticleSystem(explosion, transform: transformMatrix)
    }
}
