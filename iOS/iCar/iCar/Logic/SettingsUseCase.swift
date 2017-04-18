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
    var settingsListener: settingsCallback?
    
    func requestSettings(callback: @escaping settingsCallback) {
        settingsListener = callback
        socketManager.sendMessage(message: DrivingCommand.getSettings.rawValue);
    }
    
    override func socketDidReceiveMessage(socketManager: WebSocketManager, message: String) {
        do {
            let json = try JSONSerialization.jsonObject(with: message.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments)
            if json is [String:Any] {
                settings = Settings(withJson: json as! [String : Any])
                if let listener = settingsListener, settings != nil {
                    DispatchQueue.main.async {
                        listener(self.settings!)
                    }
                }
            }
        }
        catch let e {
            DispatchQueue.main.async {
                self.delegate?.useCaseDidFailWithError(useCase: self, error: e)
            }
        }
    }
}
