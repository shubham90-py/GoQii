//
//  ViewController.swift
//  GoQii
//
//  Created by Neosoft on 02/05/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            // Delay transition to HomeVC by 1-2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.transitionToHomeVC()
            }
        }
        
        func transitionToHomeVC() {
            let homeVC = HomeVC()
            let navigationController = UINavigationController(rootViewController: homeVC)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }


}

