//
//  ConnectViewController.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/17/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

import UIKit

class ConnectViewController: BaseViewController, WebSocketUseCaseDelegate {
    
    @IBOutlet weak var connectionButton: UIButton!
    
    private let controlsSegueIdentifier = "showControls"
    
    private let connectionUseCase = ConnectionUseCase(withSocketManager: WebSocketManager.sharedManager)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectionButton.layer.cornerRadius = 10
        
        connectionUseCase.delegate = self
        connectionUseCase.connectionListener = { [unowned self] (connected) in
            self.hideLoadingView()
            self.connectionButton.isHidden = false
            if(self.active) {
                if(connected) {
                    self.performSegue(withIdentifier: self.controlsSegueIdentifier, sender: self)
                }
                else {
                    self.showToastMessage(message: "unable to connect")
                }
            }
            else if(!connected) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connectionUseCase.beginWebSocketInteraction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        connectionUseCase.endWebSocketInteraction()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == controlsSegueIdentifier {
            if let controlsVC = segue.destination as? ControlsViewController {
                controlsVC.connectionUseCse = connectionUseCase
            }
        }
    }
    
    @IBAction func connect(_ sender: UIButton) {
        connectionButton.isHidden = true
        showLoadingView()
        connectionUseCase.connect()
    }
    
    // MARK: - WebSocketUseCaseDelegate
    
    func useCaseDidFailWithError(useCase: WebSocketUseCase, error: Error) {
        hideLoadingView()
        connectionButton.isHidden = false
        showToastMessage(message: "\(error)")
    }
}
