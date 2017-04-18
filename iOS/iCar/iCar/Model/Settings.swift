//
//  Settings.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/17/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

struct Settings {
    
    var frontLeftForwardSpeed: Int = 0
    var frontLeftBackwardSpeed: Int = 0
    var frontRightForwardSpeed: Int = 0
    var frontRightBackwardSpeed: Int = 0
    var rearLeftForwardSpeed: Int = 0
    var rearLeftBackwardSpeed: Int = 0
    var rearRightForwardSpeed: Int = 0
    var rearRightBackwardSpeed: Int = 0
    
    init() { }

    init(withJson json: [String:Any]) {
        frontLeftForwardSpeed = json["fl_fwd"] as! Int
        frontLeftBackwardSpeed = json["fl_bwd"] as! Int
        frontRightForwardSpeed = json["fr_fwd"] as! Int
        frontRightBackwardSpeed = json["fr_bwd"] as! Int
        rearLeftForwardSpeed = json["rl_fwd"] as! Int
        rearLeftBackwardSpeed = json["rl_bwd"] as! Int
        rearRightForwardSpeed = json["rr_fwd"] as! Int
        rearRightBackwardSpeed = json["rr_bwd"] as! Int
    }
    
    func toJson() -> [String:Any] {
        return [
            "fl_fwd" : frontLeftForwardSpeed,
            "fl_bwd" : frontLeftBackwardSpeed,
            "fr_fwd" : frontRightForwardSpeed,
            "fr_bwd" : frontRightBackwardSpeed,
            "rl_fwd" : rearLeftForwardSpeed,
            "rl_bwd" : rearLeftBackwardSpeed,
            "rr_fwd" : rearRightForwardSpeed,
            "rr_bwd" : rearRightBackwardSpeed
        ]
    }
}
