//
//  WebSocketManager.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/3/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

import Foundation
import SwiftWebSocket

enum DrivingCommand: String {
    case forward="f", backward="b", left="l", right="r", stop="s", getSettings="gs", setSettings="ss:%@", resetSettings="rs"
}

protocol WebSocketStateDelegate: class {
    func didOpenSocket(socketManager: WebSocketManager)
    func didCloseSocket(socketManager: WebSocketManager)
}

protocol WebSocketManagerDelegate: class {
    func socketDidFailed(socketManager: WebSocketManager, error: Error)
    func socketDidReceiveMessage(socketManager: WebSocketManager, message: String)
    func socketDidSucceded(socketManager: WebSocketManager)
}

class WebSocketManager {
    
    static let sharedManager = WebSocketManager()
    
    let errorDomain = "WebSocketError"
    
    weak var actionDelegate: WebSocketManagerDelegate?
    weak var stateDelegate: WebSocketStateDelegate?
    
    private let address = "ws://192.168.4.22:81"
    private let socket = WebSocket()
    
    private(set) var connected = false
    private(set) var error: Error?
    
    private init() {
        socket.event.open = { [unowned self] in
            print("connected")
            self.connected = true
            self.stateDelegate?.didOpenSocket(socketManager: self)
        }
        socket.event.close = { [unowned self] (code, reason, clean) in
            print("disconnected")
            self.connected = false
            self.stateDelegate?.didCloseSocket(socketManager: self)
        }
        socket.event.error = { [unowned self] (error) in
            print("error: \(error)")
            self.connected = false
            self.error = error
            self.actionDelegate?.socketDidFailed(socketManager: self, error: error)
        }
        socket.event.message = { [unowned self] (data) in
            if let stringData = data as? String {
                print(stringData)
                if stringData == "200" {
                    self.actionDelegate?.socketDidSucceded(socketManager: self)
                }
                else if stringData == "400" {
                    self.actionDelegate?.socketDidFailed(socketManager: self, error: NSError(domain: self.errorDomain, code: 400, userInfo: [NSLocalizedDescriptionKey:"Bad request"]))
                }
                else {
                    self.actionDelegate?.socketDidReceiveMessage(socketManager: self, message: stringData)
                }
            }
        }
    }
    
    func open() {
        if(connected) {
            close()
        }
        socket.open(address)
    }
    
    func close() {
        socket.close()
    }
    
    func sendMessage(message: String) {
        print("sending: \(message)")
        if(connected) {
            socket.send(message)
        }
    }
    
}
