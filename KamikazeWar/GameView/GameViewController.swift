//
//  GameViewController.swift
//  KamikazeWar
//
//  Created by Osvaldo Chaparro on 06/05/2021.
//

import UIKit
import ARKit
import SceneKit

class GameViewController: UIViewController {
    
    var planes = [Plane]()
    
    lazy var sceneView: ARSCNView = {
        let sceneView = ARSCNView()
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        return sceneView
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("EXIT", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 25
        button.layer.maskedCorners = [.layerMaxXMaxYCorner]
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .light)
        label.textColor = .black
        label.backgroundColor = .greyColor
        label.layer.cornerRadius = 25
        label.layer.masksToBounds = true
        label.layer.maskedCorners = [.layerMinXMaxYCorner]
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Score: "
        return label
    }()
    
    lazy var scoreValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .black
        label.backgroundColor = .greyColor
        label.numberOfLines = 1
        label.text = "0"
        return label
    }()
    
    private let viewModel: GameViewModel
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.viewModel.startGame()
        }
    }
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        configureTheView()
        
        
    }
    
    func configureTheView() {
        view.addSubview(sceneView)
        view.addSubview(exitButton)
        view.addSubview(scoreLabel)
        view.addSubview(scoreValueLabel)
        
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sceneView.leftAnchor.constraint(equalTo: view.leftAnchor),
            sceneView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            exitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            exitButton.widthAnchor.constraint(equalToConstant: 150.0),
            exitButton.heightAnchor.constraint(equalToConstant: 50.0),
        
            scoreLabel.rightAnchor.constraint(equalTo: scoreValueLabel.leftAnchor, constant: 0),
            scoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scoreLabel.widthAnchor.constraint(equalToConstant: 110.0),
            scoreLabel.heightAnchor.constraint(equalToConstant: 50.0),
            scoreValueLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            scoreValueLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scoreValueLabel.widthAnchor.constraint(equalToConstant: 80.0),
            scoreValueLabel.heightAnchor.constraint(equalToConstant: 50.0),
        ])
    }
    
    func updateUI() {
        scoreValueLabel.text = String(viewModel.currentScore)
    }
    
    func setupComponents() {
        
        guard ARWorldTrackingConfiguration.isSupported else { return }
        startTracking()
        sceneView.session.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
         
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.shootBullet))
        self.sceneView.addGestureRecognizer(tap)        
    }
    
    private func startTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]

        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    @objc func exitButtonTapped() {
        viewModel.exitButtonTapped()
    }
    
    @objc func shootBullet() {
        guard let camera = self.sceneView.session.currentFrame?.camera else { return }
        let bullet = Bullet(camera)
        self.sceneView.scene.rootNode.addChildNode(bullet)
    }

}

extension GameViewController: GameViewDelegate {
    func newPlaneFromVM(_ plane: Plane) {
        self.sceneView.prepare([plane]) { [weak self] _ in
            self?.sceneView.scene.rootNode.addChildNode(plane)
        }
    }
    
    func planeDestroy(_ plane: Plane, in node: SCNNode) {
        let scene = self.sceneView.scene
        scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        Explosion.show(with: plane, in: scene)
        
        DispatchQueue.main.async { [weak self] in
            guard let self=self else { return }
            self.updateUI()
        }
    }
    
    func resetGame() {
        DispatchQueue.main.async { [weak self] in
            guard let scene = self?.sceneView.scene else {return}
            scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
            self?.scoreValueLabel.text = "0"
            self?.viewModel.currentScore = 0
        }
    }
}

extension GameViewController: ARSessionDelegate, ARSCNViewDelegate {
    func sessionInterruptionEnded(_ session: ARSession) {
        startTracking()
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        startTracking()
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let camera = session.currentFrame?.camera else { return }
        
        viewModel.camera = camera
        viewModel.planes.forEach {
            $0.face(to: camera.transform)
        }
    }
}

extension GameViewController: SCNPhysicsContactDelegate {

    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let n1 = contact.nodeA
        let n2 = contact.nodeB

        let plane: Plane = (n1 is Plane ? n1 : n2) as! Plane
        let bullet: Bullet = (n2 is Bullet ? n2 : n1) as! Bullet
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            bullet.removeFromParentNode()
            self?.viewModel.planedHitted(plane: plane, node: contact.nodeA)
        }
    }
}
