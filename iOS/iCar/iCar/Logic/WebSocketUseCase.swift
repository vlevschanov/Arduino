//
//  WebSocketUseCase.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/17/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

import Foundation

protocol WebSocketUseCaseDelegate: class {
    func useCaseDidFailWithError(useCase: WebSocketUseCase, error: Error)
}

class WebSocketUseCase: NSObject, WebSocketManagerDelegate {

    let socketManager: WebSocketManager
    weak var delegate: WebSocketUseCaseDelegate?
    
    init(withSocketManager socketManager: WebSocketManager) {
        self.socketManager = socketManager
    }
    
    func beginWebSocketInteraction() {
        socketManager.actionDelegate = self
    }
    
    func endWebSocketInteraction() {
        socketManager.actionDelegate = nil
    }
    
    // MARK: - WebSocketManagerDelegate
    
    func socketDidFailed(socketManager: WebSocketManager, error: Error) {
        DispatchQueue.main.async {
            self.delegate?.useCaseDidFailWithError(useCase: self, error: error)
        }
    }
    
    func socketDidReceiveMessage(socketManager: WebSocketManager, message: String) {
        //no-op
    }
}
