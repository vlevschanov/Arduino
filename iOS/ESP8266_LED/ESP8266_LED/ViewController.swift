//
//  ViewController.swift
//  ArduinoLED
//
//  Created by Viktor Levshchanov on 2/12/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

import UIKit
import SwiftWebSocket

class ViewController: UIViewController {
    
    let address = "ws://192.168.4.22:81"
    
    let socket = WebSocket()
    
    var connected = false

    @IBOutlet weak var connectionButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var colorsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCallbacks()
    }
    
    func setupCallbacks() {
        socket.event.open = { [unowned self] in
            DispatchQueue.main.async {
                self.connectionButton.setTitle("Disconnect", for: .normal)
                self.statusLabel.text = "Connected"
                self.connected = true
                self.connectionButton.isUserInteractionEnabled = true
                self.showColors()
            }
        }
        socket.event.close = { [unowned self] (code, reason, clean) in
            DispatchQueue.main.async {
                self.connectionButton.setTitle("Connect", for: .normal)
                self.statusLabel.text = "Disconnected"
                self.connected = false
                self.connectionButton.isUserInteractionEnabled = true
                self.hideColos()
            }
        }
        socket.event.error = { [unowned self] (error) in
            self.statusLabel.text = "\(error)"
            self.connectionButton.setTitle("Connect", for: .normal)
            self.statusLabel.text = "Disconnected"
            self.connected = false
            self.connectionButton.isUserInteractionEnabled = true
            self.hideColos()
        }
    }
    
    @IBAction func connectionButtonPressed(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        if(connected) {
            socket.close()
        }
        else {
            socket.open(address)
        }
    }
    
    @IBAction func redButtonPressed(_ sender: UIButton) {
        socket.send("red");
    }
    
    @IBAction func greenButtonPressed(_ sender: UIButton) {
        socket.send("green");
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        socket.send("reset")
    }
    
    func showColors() {
        UIView.animate(withDuration: 0.5) {
            self.colorsView.alpha = 1.0;
        }
    }
    
    func hideColos() {
        UIView.animate(withDuration: 0.5) {
            self.colorsView.alpha = 0.0
        }
    }
}

