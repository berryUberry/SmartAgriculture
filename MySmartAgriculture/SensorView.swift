//
//  SensorView.swift
//  MySmartAgriculture
//
//  Created by 王凯 on 16/3/31.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class SensorView: UIViewController {
    
    
    var id:Int!
    var o = 0
    var timer = NSTimer()
    @IBOutlet weak var temperature: UIImageView!
    @IBOutlet weak var hnmidity: UIImageView!
    
 
    @IBOutlet weak var setting: UIButton!

    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var temperatureSettingButton: UIImageView!
   
    @IBOutlet weak var hnmiditySettingButton: UIImageView!
    
    @IBOutlet weak var temperatureSlider: UISlider!
    @IBOutlet weak var temperatureLabel: UILabel!
 
    @IBOutlet weak var hnmiditySlider: UISlider!
    @IBOutlet weak var hnmidityLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var returnMain: UIButton!
    @IBOutlet weak var titleButton: UIButton!
    

    @IBOutlet weak var temperatureValue: UILabel!
    @IBOutlet weak var hnmidityValue: UILabel!

    
    var backgroundButton:UIButton!
    
    var temperatureInit:Int = 20
    var hnmidityInit:Int = 40
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 228/255, green: 229/255, blue: 198/255, alpha: 1)
        
//        temperatureValue.text = String(greenHouses[id - 1].temperature)
//        hnmidityValue.text = String(greenHouses[id - 1].hnmidity)
        print(houseInfo)
        temperatureValue.text = houseInfo[0]
        hnmidityValue.text = houseInfo[1]
        
        temperature.layer.cornerRadius = temperature.frame.width/2
        hnmidity.layer.cornerRadius = hnmidity.frame.width/2
        setting.layer.cornerRadius = 25
        
        backgroundButton = UIButton(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.height))
        backgroundButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.view.addSubview(backgroundButton)
        self.view.bringSubviewToFront(backgroundButton)
        self.view.bringSubviewToFront(settingView)
        backgroundButton.hidden = true
        settingView.hidden = true
        
        temperatureSettingButton.layer.cornerRadius = temperatureSettingButton.frame.width/2
        hnmiditySettingButton.layer.cornerRadius = hnmiditySettingButton.frame.width/2
        
//        if((NSUserDefaults.standardUserDefaults().boolForKey("launched\(phoneNumber)\(id)") as Bool!) == false){
//            
//            temperatureSlider.value = 20
//            hnmiditySlider.value = 40
//            //NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launched\(id)")
//            print("diyici")
//            
//        }else{
//            print(id)
//            var storedHouse = userDefault.objectForKey("\(phoneNumber)\(id)") as! NSData
//            //print(storedHouse)
//            var sHouse = NSKeyedUnarchiver.unarchiveObjectWithData(storedHouse) as! GreenHouse
//            
//            temperatureSlider.value = Float(sHouse.settingTemperature)
//            hnmiditySlider.value = Float(sHouse.settingHnmidity)
//            
//        }
        
        
        
        
        
        temperatureLabel.text = String(Int(floor(temperatureSlider.value)))
        hnmidityLabel.text = String(Int(floor(hnmiditySlider.value)))
        temperatureSlider.addTarget(self, action: #selector(SensorView.valueChanged), forControlEvents: .ValueChanged)
        hnmiditySlider.addTarget(self, action: #selector(SensorView.valueChanged), forControlEvents: .ValueChanged)
        
        
        setting.clipsToBounds = true
        setting.addTarget(self, action: #selector(SensorView.toSetting), forControlEvents: .TouchUpInside)
        backgroundButton.addTarget(self, action: #selector(SensorView.back), forControlEvents: .TouchUpInside)
        doneButton.addTarget(self, action: #selector(SensorView.done), forControlEvents: .TouchUpInside)
        doneButton.layer.cornerRadius = 12
        
        returnMain.clipsToBounds = true
        returnMain.layer.cornerRadius = 22.5
        returnMain.addTarget(self, action: #selector(SensorView.returnMainAction), forControlEvents: .TouchUpInside)
        
        titleButton.setTitle("\(nameString[id-1])", forState: .Normal)
        titleButton.layer.cornerRadius = 12
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(SensorView.THConnectHttp), userInfo: nil, repeats: true)
        
        timer.fire()
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func toSetting(){
        settingView.hidden = false
        backgroundButton.hidden = false
        settingView.layer.setAffineTransform(CGAffineTransformMakeScale(0.1, 0.1))
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.settingView.layer.setAffineTransform(CGAffineTransformMakeScale(1.1, 1.1))
            }) { (finished:Bool) -> Void in
                self.settingView.layer.setAffineTransform(CGAffineTransformMakeScale(1, 1))
        }
    
        
        
        if((NSUserDefaults.standardUserDefaults().boolForKey("launched\(phoneNumber)\(id)") as Bool!) == false){
            
            temperatureSlider.value = 20
            hnmiditySlider.value = 40
            
            temperatureLabel.text = String(Int(floor(temperatureSlider.value)))
            hnmidityLabel.text = String(Int(floor(hnmiditySlider.value)))
            //NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launched\(id)")
            print("diyici")
            
        }else{
            print(id)
            let storedHouse = userDefault.objectForKey("\(phoneNumber)\(id)") as! NSData
            //print(storedHouse)
            let sHouse = NSKeyedUnarchiver.unarchiveObjectWithData(storedHouse) as! GreenHouse
            
            temperatureSlider.value = Float(sHouse.settingTemperature)
            hnmiditySlider.value = Float(sHouse.settingHnmidity)
            temperatureLabel.text = String(Int(floor(temperatureSlider.value)))
            hnmidityLabel.text = String(Int(floor(hnmiditySlider.value)))
            
        }
    }
    
    
    func back(){
    
        settingView.hidden = true
        backgroundButton.hidden = true
        doneButton.setTitle("Done", forState: .Normal)
    }
    
    func returnMainAction(){
        //self.navigationController?.popToRootViewControllerAnimated(true)
        timer.invalidate()
        
    
    
    }
    
    func valueChanged(){
    
        temperatureLabel.text = String(Int(floor(temperatureSlider.value)))
        hnmidityLabel.text = String(Int(floor(hnmiditySlider.value)))
        doneButton.setTitle("Done", forState: .Normal)
    
    }
    
    func done(){
    
//        a.settingTemperature = Int(temperatureSlider.value)
//        a.settingHnmidity = Int(hnmiditySlider.value)
//        temperatureInit = Int(temperatureSlider.value)
//        hnmidityInit = Int(hnmiditySlider.value)
//        greenHouses[id - 1].settingTemperature = Int(temperatureSlider.value)
//        greenHouses[id - 1].settingHnmidity = Int(hnmiditySlider.value)
//        
//        var modelHouse:NSData = NSKeyedArchiver.archivedDataWithRootObject(greenHouses[id - 1])
//        userDefault.setObject(modelHouse,forKey:"\(id)")
//        
//        settingView.hidden = true
//        backgroundButton.hidden = true
//        
//        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launched\(id)")
        connectHttp()
        
    }
    
    
    
    
    func connectHttp(){
        
        do {
            
            let url:NSURL! = NSURL(string:"http://\(ip)/IAServer/Greenhouse/greenhouseSetting.php?greenhouse_id=\(keyString[id - 1])&tem_set=\(temperatureLabel.text!)&hum_set=\(hnmidityLabel.text!)")
           
            let urlRequest:NSURLRequest = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 10)
            let data:NSData = try NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response)
            let dict:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            
            print("qqwqwqwq")
            let dic = dict as! NSDictionary
            
            let token = dic.objectForKey("token") as! String?
            
            if token == "success"{
                doneButton.setTitle("设置成功", forState: .Normal)
                
                
                a.settingTemperature = Int(temperatureSlider.value)
                a.settingHnmidity = Int(hnmiditySlider.value)
                temperatureInit = Int(temperatureSlider.value)
                hnmidityInit = Int(hnmiditySlider.value)
                greenHouses[id - 1].settingTemperature = Int(temperatureSlider.value)
                greenHouses[id - 1].settingHnmidity = Int(hnmiditySlider.value)
                
                let modelHouse:NSData = NSKeyedArchiver.archivedDataWithRootObject(greenHouses[id - 1])
                userDefault.setObject(modelHouse,forKey:"\(phoneNumber)\(id)")
                
//                settingView.hidden = true
//                backgroundButton.hidden = true
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launched\(phoneNumber)\(id)")

                
                
                
            }else{
                let errorMessage = dic.objectForKey("error") as! String
                print(errorMessage)
                
                
                
            }
            
            
        }
        catch{
            
            print("网络问题")
            
        }
        
    }

    
    func THConnectHttp(){
    
        do {
            
            print("gengxin\(o)")
            o += 1
            let url:NSURL! = NSURL(string:"http://\(ip)/IAServer/Greenhouse/greenhouseInfo.php?greenhouse_id=\(keyString[id - 1])")
            let urlRequest:NSURLRequest = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 20)
            let data:NSData = try NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response)
            let dict:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            
            
            let dic = dict as! NSDictionary
            
            let token = dic.objectForKey("token") as! String?
            
            if token == "success"{
                
                let data = dic.objectForKey("data") as! NSDictionary
                print(data)
                
                
                let temInfo = data.objectForKey("temperature") as? NSString
                let hnmInfo = data.objectForKey("humidity") as? NSString
                houseInfo.removeAll()
                houseInfo.append(String(temInfo!))
                houseInfo.append(String(hnmInfo!))
                
                temperatureValue.text = houseInfo[0]
                hnmidityValue.text = houseInfo[1]
                
                
            }else{
                let errorMessage = dic.objectForKey("error") as! String
                print(errorMessage)
                
                
                
            }
            
        
        }
        catch{
            
            print("网络问题")
            
        }

    
    }

}
