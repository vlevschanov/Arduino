//
//  ControlsViewController.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/3/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

import UIKit

enum DrivingCommand: String {
    case forward="f", backward="b", left="l", right="r", stop="s"
}

class ControlsViewController: UIViewController, WebSocketManagerDelegate {
    
    @IBOutlet weak var connectionButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet var controlButtons: [UIButton]!
    
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
    
    @IBAction func connect(_ sender: UIButton) {
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
    
    func socketStateDidChanged(socketManager: WebSocketManager) {
        statusLabel.text = socketManager.connected ? "Connected" : "Disconnected"
        if(socketManager.connected) {
            connectionButton.setTitle("Disconnect", for: .normal)
        }
        else {
            connectionButton.setTitle("Connect", for: .normal)
        }
        updateControlButtons(socketManager.connected)
    }
    
    func socketDidFailed(socketManager: WebSocketManager, error: Error) {
        statusLabel.text = "\(error)"
    }
    
    private func updateControlButtons(_ enabled: Bool) {
        for button in controlButtons {
            button.isEnabled = enabled
        }
    }
    
    @objc private func handleApplicationResign() {
        socketManager.sendMessage(message: DrivingCommand.stop.rawValue)
    }
}
