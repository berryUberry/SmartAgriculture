//
//  Greenhouse.swift
//  MySmartAgriculture
//
//  Created by 王凯 on 16/3/30.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class GreenHouse:NSObject{

    var temperature:Double
    var hnmidity:Double
    var settingTemperature:Int
    var settingHnmidity:Int
    
    override init(){
        temperature = 0.0
        hnmidity = 0.0
        settingTemperature = 20
        settingHnmidity = 40
    
    }
    init(temperature:Double,hnmidity:Double){
        self.temperature = temperature
        self.hnmidity = hnmidity
        settingTemperature = 20
        settingHnmidity = 40
        super.init()
    
    }
    
    func encodeWithCoder(_encoder:NSCoder){
        _encoder.encodeObject(self.temperature, forKey: "tem")
        _encoder.encodeObject(self.hnmidity, forKey: "hnm")
        _encoder.encodeObject(self.settingTemperature, forKey: "set_temperature")
        _encoder.encodeObject(self.settingHnmidity, forKey: "set_hnmidity")
        
    }
    
    init(coder decoder:NSCoder){
    
        temperature = decoder.decodeObjectForKey("tem") as! Double
        hnmidity = decoder.decodeObjectForKey("hnm") as! Double
        settingTemperature = decoder.decodeObjectForKey("set_temperature") as! Int
        settingHnmidity = decoder.decodeObjectForKey("set_hnmidity") as! Int
        
    
    }


}
