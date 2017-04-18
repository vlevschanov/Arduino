//
//  ConnectionUseCase.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/17/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

import Foundation

class ConnectionUseCase: WebSocketUseCase, WebSocketStateDelegate {
    
    var connectionListener: ((_ connected: Bool)->())?

    override init(withSocketManager socketManager: WebSocketManager) {
        super.init(withSocketManager: socketManager)
        socketManager.stateDelegate = self
    }
    
    func connect() {
        socketManager.open()
    }
    
    func disconnect() {
        socketManager.close()
    }
    
    // MARK: - WebSocketStateDelegate
    
    func didOpenSocket(socketManager: WebSocketManager) {
        if let listener = connectionListener {
            DispatchQueue.main.async {
                listener(true)
            }
        }
    }
    
    func didCloseSocket(socketManager: WebSocketManager) {
        if let listener = connectionListener {
            DispatchQueue.main.async {
                listener(false)
            }
        }
    }
}
