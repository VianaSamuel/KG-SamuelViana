//
//  SplashViewController.swift
//  KaizenGaming-SamuelViana
//
//  Created by Samuel Viana on 17/05/26.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "KG"
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.transitionToMain()
        }
    }
    
    private func setup() {
        view.backgroundColor = UIColor(red: 0.0, green: 0.55, blue: 0.55, alpha: 1.0)
        view.addSubview(logoLabel)
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func transitionToMain() {
        guard let windowScene = view.window?.windowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        
        let vc = SportsListViewController(viewModel: SportsListViewModel())
        sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: vc)
    }
}
