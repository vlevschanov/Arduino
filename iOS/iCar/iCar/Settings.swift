//
//  Settings.swift
//  iCar
//
//  Created by Viktor Levshchanov on 4/17/17.
//  Copyright © 2017 Viktor Levshchanov. All rights reserved.
//

struct Settings {
    
    var frontLeftForwardSpeed: Int
    var frontLeftBackwardSpeed: Int
    var frontRightForwardSpeed: Int
    var frontRightBackwardSpeed: Int
    var rearLeftForwardSpeed: Int
    var rearLeftBackwardSpeed: Int
    var rearRightForwrdSpeed: Int
    var rearRightBackwardSpeed: Int

    init(withJson json: [String:Any]) {
        frontLeftForwardSpeed = json["fl_fwd"] as! Int
        frontLeftBackwardSpeed = json["fl_bwd"] as! Int
        frontRightForwardSpeed = json["fr_fwd"] as! Int
        frontRightBackwardSpeed = json["fr_bwd"] as! Int
        rearLeftForwardSpeed = json["rl_fwd"] as! Int
        rearLeftBackwardSpeed = json["rl_bwd"] as! Int
        rearRightForwrdSpeed = json["rr_fwd"] as! Int
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
            "rr_fwd" : rearRightForwrdSpeed,
            "rr_bwd" : rearRightBackwardSpeed
        ]
    }
}
