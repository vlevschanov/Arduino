//
//  ControlsUseCase.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/17/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

class ControlsUseCase: WebSocketUseCase {
    
    func moveForward() {
        socketManager.sendMessage(message: DrivingCommand.forward.rawValue)
    }
    
    func moveBackward() {
        socketManager.sendMessage(message: DrivingCommand.backward.rawValue)
    }
    
    func turnLeft() {
        socketManager.sendMessage(message: DrivingCommand.left.rawValue)
    }
    
    func turnRight() {
        socketManager.sendMessage(message: DrivingCommand.right.rawValue)
    }
    
    func stop() {
        socketManager.sendMessage(message: DrivingCommand.stop.rawValue)
    }
}
