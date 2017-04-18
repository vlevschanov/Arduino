//
//  ControlsViewController.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/3/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

import UIKit

class ControlsViewController: BaseViewController, WebSocketUseCaseDelegate {
    
    @IBOutlet var controlButtons: [UIButton]!
    
    var connectionUseCse: ConnectionUseCase?
    
    private let controlsUseCase = ControlsUseCase(withSocketManager: WebSocketManager.sharedManager);
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationResign), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        controlsUseCase.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        controlsUseCase.beginWebSocketInteraction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        controlsUseCase.stop()
        controlsUseCase.endWebSocketInteraction()
    }
    
    // MARK: - Actions
    
    @IBAction func forward(_ sender: UIButton) {
        controlsUseCase.moveForward()
    }
    
    @IBAction func backward(_ sender: UIButton) {
        controlsUseCase.moveBackward()
    }
    
    @IBAction func turnRight(_ sender: UIButton) {
        controlsUseCase.turnRight()
    }
    
    @IBAction func turnLeft(_ sender: UIButton) {
        controlsUseCase.turnLeft()
    }
    
    @IBAction func stop(_ sender: UIButton) {
        controlsUseCase.stop()
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        if let connectionUseCase = connectionUseCse {
            connectionUseCase.disconnect()
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - WebSocketUseCaseDelegate
    
    func useCaseDidFailWithError(useCase: WebSocketUseCase, error: Error) {
        showToastMessage(message: "\(error)")
    }
    
    // MARK: - Private
    
    @objc private func handleApplicationResign() {
        controlsUseCase.stop()
    }
}
