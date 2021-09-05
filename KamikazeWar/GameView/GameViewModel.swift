//
//  GameViewModel.swift
//  KamikazeWar
//
//  Created by Osvaldo Chaparro on 06/05/2021.
//

import Foundation
import ARKit

protocol GameCoordinatorDelegate: class {
    func exitButtonTapped()
    func performGameOver(finalScore: Int)
    
}

protocol GameViewDelegate: class {
    func newPlaneFromVM(_ plane: Plane)
    func planeDestroy(_ plane: Plane, in node: SCNNode)
    func resetGame()
}

class GameViewModel {
    
    weak var coordinatorDelegate: GameCoordinatorDelegate?
    weak var viewDelegate: GameViewDelegate?
    var currentScore: Int = 0
    var camera: ARCamera?
    var planes: [Plane] = []
    
    
    func exitButtonTapped(){
        coordinatorDelegate?.exitButtonTapped()
    }
    
    func startGame() {
        addPlane()
    }
    
    func addPlane() {
        let plane = Plane(camera)
        plane.didFinishMoving = planeDidFinishMoving
        planes.append(plane)
        
        viewDelegate?.newPlaneFromVM(plane)
    }
    
    func planedHitted(plane: Plane, node: SCNNode) {
        plane.removeLive()
        
        if(plane.difficulty.lives == 0) {
            addScore()
            addPlane()
            viewDelegate?.planeDestroy(plane, in: node)
        }
    }
    
    func addScore(){
        self.currentScore += 1
        
        //Check HighScore
        let currentHighScore = UserDefaults.standard.highScore
        if (currentHighScore.score <= currentScore) {
            UserDefaults.standard.highScore = HighScore(score: currentScore, date: Date())
        }
        
    }
    
    private func planeDidFinishMoving(_ plane: Plane){
        gameOver()
    }
    
    private func gameOver() {
        DispatchQueue.main.async { [weak self] in
            guard let self=self else { return }
            self.coordinatorDelegate?.performGameOver(finalScore: self.currentScore)
        }
        viewDelegate?.resetGame()
    }
}
