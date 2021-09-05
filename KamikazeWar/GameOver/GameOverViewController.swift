//
//  GameOverViewController.swift
//  KamikazeWar
//
//  Created by Osvaldo Chaparro on 04/09/2021.
//

import UIKit

class GameOverViewController: UIViewController {
    
    lazy var gameOverLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 50, weight: .black)
        label.textColor = .mainColor
        label.numberOfLines = 1
        label.text = "GAME OVER"
        return label
    }()
    
    lazy var finalScoreValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .mainColor
        label.numberOfLines = 1
        label.text = "0"
        return label
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("START AGAIN!", for: .normal)
        button.setTitleColor(.mainColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var mainMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("MAIN MENU", for: .normal)
        button.setTitleColor(.mainColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        button.addTarget(self, action: #selector(mainMenuButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let viewModel: GameOverViewModel
    
    init(viewModel: GameOverViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        configureTheView()
    }
    
    func configureTheView() {
        
        finalScoreValueLabel.text = "Final Score: \(viewModel.finalScore)"
        view.addSubview(gameOverLabel)
        view.addSubview(finalScoreValueLabel)
        view.addSubview(startButton)
        view.addSubview(mainMenuButton)
        
        NSLayoutConstraint.activate([
            gameOverLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameOverLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            finalScoreValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finalScoreValueLabel.topAnchor.constraint(equalTo: gameOverLabel.bottomAnchor, constant: 20),
            mainMenuButton.topAnchor.constraint(equalTo: finalScoreValueLabel.bottomAnchor, constant: 20),
            mainMenuButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 150),
            startButton.topAnchor.constraint(equalTo: finalScoreValueLabel.bottomAnchor, constant: 20),
            startButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -150),
        ])
    }
    
    @objc func startButtonTapped() {
        viewModel.startGameButtonTapped()
    }
    
    @objc func mainMenuButtonTapped() {
        viewModel.gotoMainScreenButtonTapped()
    }
}

extension GameOverViewController: GameOverViewDelegate {
    
}
