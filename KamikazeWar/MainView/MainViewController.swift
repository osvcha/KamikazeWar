//
//  MainViewController.swift
//  KamikazeWar
//
//  Created by Osvaldo Chaparro on 04/05/2021.
//

import UIKit

class MainViewController: UIViewController {

    lazy var samuraiImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "samurai")
        return image
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("START GAME!", for: .normal)
        button.setTitleColor(.mainColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var highScoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .mainColor
        label.numberOfLines = 1
        label.text = "High Score: "
        return label
    }()
    
    lazy var highScoreValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .mainColor
        label.numberOfLines = 1
        label.text = "0"
        return label
    }()
    
    
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //SET HighScore from UserDefaults
        let highScore = UserDefaults.standard.highScore
        highScoreValueLabel.text = "\(highScore.score)"
    }
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        configureTheView()
        
    }
    
    func configureTheView() {
        
        
        
        view.addSubview(samuraiImage)
        view.addSubview(startButton)
        view.addSubview(highScoreLabel)
        view.addSubview(highScoreValueLabel)
        
        
        NSLayoutConstraint.activate([
            samuraiImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            samuraiImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            samuraiImage.widthAnchor.constraint(equalToConstant: 200.0),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            highScoreLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            highScoreLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            highScoreValueLabel.widthAnchor.constraint(equalToConstant: 200.0),
            highScoreValueLabel.leftAnchor.constraint(equalTo: highScoreLabel.rightAnchor, constant: 6),
            highScoreValueLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
        ])
    }
    
    @objc func startButtonTapped() {
        viewModel.startGameButtonTapped()
    }
    
}

extension MainViewController: MainViewDelegate {
    
}
