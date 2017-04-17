//
//  ControlsViewController.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/3/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

import UIKit

class ControlsViewController: UIViewController, WebSocketManagerDelegate {
    
    
    @IBOutlet weak var connectionButton: UIBarButtonItem!
    @IBOutlet var controlButtons: [UIButton]!
    
    private let settingsSegue = "showSettings";
    
    private let socketManager = WebSocketManager();
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socketManager.delegate = self
        updateControlButtons(false)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationResign), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        socketManager.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func connect(_ sender: UIBarButtonItem) {
        if(!socketManager.connected) {
            socketManager.open()
        }
        else {
            socketManager.close()
        }
    }
    
    @IBAction func forward(_ sender: UIButton) {
        socketManager.sendMessage(message: DrivingCommand.forward.rawValue)
    }
    
    @IBAction func backward(_ sender: UIButton) {
        socketManager.sendMessage(message: DrivingCommand.backward.rawValue)
    }
    
    @IBAction func turnRight(_ sender: UIButton) {
        socketManager.sendMessage(message: DrivingCommand.right.rawValue)
    }
    
    @IBAction func turnLeft(_ sender: UIButton) {
        socketManager.sendMessage(message: DrivingCommand.left.rawValue)
    }
    
    @IBAction func stop(_ sender: UIButton) {
        socketManager.sendMessage(message: DrivingCommand.stop.rawValue)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == settingsSegue {
            if let nc = segue.destination as? NavigationController {
                if let vc = nc.topViewController as? SettingsViewController {
                    vc.socketManager = socketManager
                }
            }
        }
        
    }
    
    // MARK: - WebSocketManagerDelegate
    
    func socketStateDidChanged(socketManager: WebSocketManager) {
        navigationItem.title = socketManager.connected ? "Connected" : "Disconnected"
        connectionButton.title = socketManager.connected ? "Disconnect" : "Connect"
        updateControlButtons(socketManager.connected)
    }
    
    func socketDidFailed(socketManager: WebSocketManager, error: Error) {
        navigationItem.title = "\(error)"
    }
    
    func socketDidReceiveMessage(socketManager: WebSocketManager, message: String) {
        
    }
    
    // MARK: - Private
    
    private func updateControlButtons(_ enabled: Bool) {
        for button in controlButtons {
            button.isEnabled = enabled
        }
    }
    
    @objc private func handleApplicationResign() {
        socketManager.sendMessage(message: DrivingCommand.stop.rawValue)
    }
}
