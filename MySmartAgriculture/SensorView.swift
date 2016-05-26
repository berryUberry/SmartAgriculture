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
    var sensorId:Int!
    var o = 0
    var timer = NSTimer()
    @IBOutlet weak var temperature: UIImageView!
    @IBOutlet weak var hnmidity: UIImageView!
    @IBOutlet weak var sensorID: UILabel!
    @IBOutlet weak var startTime: UILabel!
 
    @IBOutlet weak var setting: UIButton!

    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var temperatureSettingButton: UIImageView!
   
    @IBOutlet weak var hnmiditySettingButton: UIImageView!
    
    @IBOutlet weak var temperatureSlider: UISlider!
    @IBOutlet weak var temperatureLabel: UILabel!
 
    @IBAction func backToSensorList(sender: AnyObject) {
        
        self.performSegueWithIdentifier("backToSensorList", sender: self)
        
    }
    @IBOutlet weak var hnmiditySlider: UISlider!
    @IBOutlet weak var hnmidityLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var returnMain: UIButton!
    @IBOutlet weak var titleButton: UIButton!
    

    @IBOutlet weak var temperatureValue: UILabel!
    @IBOutlet weak var hnmidityValue: UILabel!

    @IBOutlet weak var formButton: UIButton!
    
    @IBAction func gotoForm(sender: AnyObject) {
        
        timer.invalidate()
        self.performSegueWithIdentifier("gotoForm", sender: self)
        
    }
    var backgroundButton:UIButton!
    
    var temperatureInit:Int = 20
    var hnmidityInit:Int = 40
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 228/255, green: 229/255, blue: 198/255, alpha: 1)
        

        
        print(sensorId)
        print(sensors.count)
        temperatureValue.text = String(sensors[sensorId].temperature)
        hnmidityValue.text = String(sensors[sensorId].hnmidity)

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
        

        
        
        
        
        
        temperatureLabel.text = String(Int(floor(temperatureSlider.value)))
        hnmidityLabel.text = String(Int(floor(hnmiditySlider.value)))
        sensorID.text = "传感器ID:  \(String(sensors[sensorId].sensor_id))"
        startTime.text = "种植时间:  \(String(sensors[sensorId].start_time))"
        
        formButton.setTitle("表单", forState: .Normal)
        formButton.layer.cornerRadius = 12
        formButton.clipsToBounds = true
        
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
        
        titleButton.setTitle("\(sensors[sensorId].plant_name)", forState: .Normal)
        titleButton.layer.cornerRadius = 12
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(120, target: self, selector: #selector(SensorView.THConnectHttp), userInfo: nil, repeats: true)
        
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
    
        
        
        if((NSUserDefaults.standardUserDefaults().boolForKey("launched\(phoneNumber)\(id)\(sensors[sensorId].sensor_id)") as Bool!) == false){
            
            temperatureSlider.value = 20
            hnmiditySlider.value = 40
            
            temperatureLabel.text = String(Int(floor(temperatureSlider.value)))
            hnmidityLabel.text = String(Int(floor(hnmiditySlider.value)))
            //NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launched\(id)")
            print("diyici")
            
        }else{
            
            let storedHouse = userDefault.objectForKey("\(phoneNumber)\(id)\(sensors[sensorId].sensor_id)") as! NSData
            //print(storedHouse)
            let sHouse = NSKeyedUnarchiver.unarchiveObjectWithData(storedHouse) as! Sensor
            
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
    

        connectHttp()
        
    }
    
    
    
    
    func connectHttp(){
        
        do {
            
            let url:NSURL! = NSURL(string:"http://\(ip)/IAServer/Greenhouse/greenhouseSetting.php?sensor_id=\(sensors[sensorId].sensor_id)&tem_set=\(temperatureLabel.text!)&hum_set=\(hnmidityLabel.text!)")
            print(url)
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
                sensors[sensorId].settingTemperature = Int(temperatureSlider.value)
                sensors[sensorId].settingHnmidity = Int(hnmiditySlider.value)
                
                let modelHouse:NSData = NSKeyedArchiver.archivedDataWithRootObject(sensors[sensorId])
                userDefault.setObject(modelHouse,forKey:"\(phoneNumber)\(id)\(sensors[sensorId].sensor_id)")
                
//                settingView.hidden = true
//                backgroundButton.hidden = true
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launched\(phoneNumber)\(id)\(sensors[sensorId].sensor_id)")

                
                
                
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
            
            
            print("qqwqwqwq")
            let dic = dict as! NSDictionary
            
            let token = dic.objectForKey("token") as! String?
            
            if token == "success"{
                
                let data = dic.objectForKey("data") as! [NSDictionary]
                print(data)
                sensors.removeAll()
                for i in 0...data.count - 1{
                    a.greenhouseId = data[i].objectForKey("greenhouse_id") as! NSNumber
                    a.sensor_id = data[i].objectForKey("sensor_id") as! String
                    a.plant_name = data[i].objectForKey("plant_name") as! String
                    a.temperature = Double(data[i].objectForKey("temperature") as! String)!
                    a.hnmidity = Double(data[i].objectForKey("humidity") as! String)!
                    a.start_time = data[i].objectForKey("start_time") as! String
                    sensors.append(a)
                    
                }
                
                temperatureValue.text = String(sensors[sensorId].temperature)
                hnmidityValue.text = String(sensors[sensorId].hnmidity)
                
            }else{
                let errorMessage = dic.objectForKey("error") as! String
                print(errorMessage)
                
                
                
            }
            
            
        }
        catch{
            
            print("网络问题")
            
        }

    
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToSensorList"{
            let SL = segue.destinationViewController as! SensorListViewController
            SL.sensorId = self.sensorId
            SL.id = self.id
        
        }else if segue.identifier == "gotoForm"{
        
            let form = segue.destinationViewController as! FormViewController
            form.id = self.id
            form.sensorId = self.sensorId
        
        }
    }
    
}
