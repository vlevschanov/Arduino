//
//  SettingsUseCase.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/17/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

import Foundation

class SettingsUseCase: WebSocketUseCase {
    
    typealias settingsCallback = (_ settings: Settings)->()
    
    var settings: Settings?
    
    private var settingsListener: settingsCallback?
    private var requestedCommand: DrivingCommand?
    
    func requestSettings(callback: @escaping settingsCallback) {
        settingsListener = callback
        requestSettings()
    }
    
    func save(settings: Settings, callback: @escaping settingsCallback) {
        settingsListener = callback
        requestedCommand = DrivingCommand.setSettings
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: settings.toJson())
            if var jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                jsonString = jsonString.replacingOccurrences(of: "\\/", with: "/")
                let message = String.init(format: DrivingCommand.setSettings.rawValue, jsonString)
                socketManager.sendMessage(message: message)
            }
        }
        catch let e {
            DispatchQueue.main.async {
                self.delegate?.useCaseDidFailWithError(useCase: self, error: e)
            }
        }
    }
    
    func reset(callback: @escaping settingsCallback) {
        settingsListener = callback
        requestedCommand = DrivingCommand.resetSettings
        socketManager.sendMessage(message: DrivingCommand.resetSettings.rawValue)
    }
    
    override func socketDidReceiveMessage(socketManager: WebSocketManager, message: String) {
        if let currentCommand = requestedCommand {
            switch currentCommand {
            case .getSettings:
                parseSettings(settingsJson: message)
            default:
                break
            }
        }
    }
    
    override func socketDidSucceded(socketManager: WebSocketManager) {
        if let currentCommand = requestedCommand {
            switch currentCommand {
            case .setSettings, .resetSettings:
                requestSettings()
            default:
                break
            }
        }
    }
    
    private func requestSettings() {
        requestedCommand = DrivingCommand.getSettings
        socketManager.sendMessage(message: DrivingCommand.getSettings.rawValue);
    }
    
    private func parseSettings(settingsJson: String) {
        do {
            let json = try JSONSerialization.jsonObject(with: settingsJson.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments)
            if json is [String:Any] {
                settings = Settings(withJson: json as! [String : Any])
                fireListener()
            }
        }
        catch let e {
            DispatchQueue.main.async {
                self.delegate?.useCaseDidFailWithError(useCase: self, error: e)
            }
        }
    }
    
    private func fireListener() {
        if let listener = settingsListener, settings != nil {
            DispatchQueue.main.async {
                listener(self.settings!)
            }
        }
        settingsListener = nil
        requestedCommand = nil
    }
}
