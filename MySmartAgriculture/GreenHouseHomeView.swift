//
//  GreenHouseHomeView.swift
//  MySmartAgriculture
//
//  Created by 王凯 on 16/3/30.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit




class GreenHouseHomeView: UIViewController,UIScrollViewDelegate{

    var buttons = [UIButton]()
    var buttonNumber:Int!
    var number = 1
    var scrollView = UIScrollView()
    
    var timer2:NSTimer!
    var time = 0
    
    var timer = NSTimer()
    
    @IBOutlet weak var exitButton: UIButton!
    

    @IBAction func exit(sender: UIButton) {
        sensors.removeAll()
        keyString.removeAll()
        keyString2.removeAll()
        nameString.removeAll()
        userDefault.setObject(nil, forKey: "identifier")
        userDefault.setObject(nil, forKey: "password")
        
        
    }
   
    @IBOutlet weak var grayButton: UIButton!

    @IBOutlet weak var waitView: UIView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var resultView: UIView!
    
    
    override func viewDidLoad() {
        
        print(nameString)
        print(keyString)
        super.viewDidLoad()
        grayButton.hidden = true
        waitView.hidden = true
        resultView.hidden = true
        
        view.backgroundColor = UIColor(red: 228/255, green: 229/255, blue: 198/255, alpha: 1)
        
        
        exitButton.layer.cornerRadius = exitButton.frame.width/2
        exitButton.clipsToBounds = true
        
    
        
        
        scrollView.frame = CGRectMake(0, view.frame.height/10 + 15, view.frame.width, view.frame.height)
       // scrollView.backgroundColor = UIColor(red: 228/255, green: 229/255, blue: 198/255, alpha: 1)
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.frame.width,height: view.frame.height)
        view.addSubview(scrollView)
        //scrollView.addSubview(exitButton)

        
        dispatch_async(dispatch_get_main_queue()) {
            self.createHouses()
            
            self.view.bringSubviewToFront(self.grayButton)
            self.view.bringSubviewToFront(self.waitView)
            self.view.bringSubviewToFront(self.resultView)
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(GreenHouseHomeView.buttonAction), userInfo: nil, repeats: true)
            
            self.timer.fire()
        }
        
        
        

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    func createHouses(){
        

        if nameString.count > 0{
            
            for i in 1...nameString.count{
                if i == 1{
                let greenHouseButton = UIButton(frame:CGRectMake(view.frame.width/20, CGFloat((i-1)) * (view.frame.height/10 + 15),view.frame.width*9/10,view.frame.height/10))
                greenHouseButton.backgroundColor = UIColor.whiteColor()
                greenHouseButton.setTitle("\(i)", forState: .Normal)
                greenHouseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
//                greenHouseButton.setTitle("\(keyString[i - 1])", forState: .Normal)
                greenHouseButton.tintColor = UIColor.whiteColor()
                scrollView.addSubview(greenHouseButton)
                
                let showHouseButton = UIButton(frame:CGRectMake(10,greenHouseButton.frame.height/8,greenHouseButton.frame.height*3/4,greenHouseButton.frame.height*3/4))
                let randomColor:Int = Int(arc4random_uniform(7))
                showHouseButton.backgroundColor = greenHouseColor(randomColor)
                showHouseButton.layer.cornerRadius = showHouseButton.frame.width/2
                showHouseButton.setTitle("\(i)", forState: .Normal)
                greenHouseButton.addSubview(showHouseButton)
                
                let showHouseLabel = UILabel(frame:CGRectMake(greenHouseButton.frame.width/4,greenHouseButton.frame.height/8,greenHouseButton.frame.width/2,greenHouseButton.frame.height*3/4))
//              showHouseLabel.text = "house \(i)"
                showHouseLabel.text = nameString[i-1]
                showHouseLabel.textColor = UIColor.blackColor()
                showHouseLabel.textAlignment = .Center
                greenHouseButton.addSubview(showHouseLabel)
                greenHouseButton.layer.setAffineTransform(CGAffineTransformMakeScale(0.1, 0.1))
                
                greenHouseButton.addTarget(self, action: #selector(GreenHouseHomeView.gotoSensorList(_:)), forControlEvents: .TouchUpInside)
                    
                buttons.append(greenHouseButton)
                }else{
                
                    let greenHouseButton = UIButton(frame:CGRectMake(self.view.frame.width/20,CGFloat((i-2)) * (view.frame.height/10 + 15),view.frame.width*9/10,view.frame.height/10))
                    greenHouseButton.backgroundColor = UIColor.whiteColor()
                    greenHouseButton.setTitle("\(i)", forState: .Normal)
                    greenHouseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
//                    greenHouseButton.setTitle("\(keyString[i - 1])", forState: .Normal)
                    greenHouseButton.tintColor = UIColor.whiteColor()
                    scrollView.addSubview(greenHouseButton)
                    
                    let showHouseButton = UIButton(frame:CGRectMake(10,greenHouseButton.frame.height/8,greenHouseButton.frame.height*3/4,greenHouseButton.frame.height*3/4))
                    let randomColor:Int = Int(arc4random_uniform(7))
                    showHouseButton.backgroundColor = greenHouseColor(randomColor)
                    showHouseButton.layer.cornerRadius = showHouseButton.frame.width/2
                    showHouseButton.setTitle("\(i)", forState: .Normal)
                    greenHouseButton.addSubview(showHouseButton)
                    
                    let showHouseLabel = UILabel(frame:CGRectMake(greenHouseButton.frame.width/4,greenHouseButton.frame.height/8,greenHouseButton.frame.width/2,greenHouseButton.frame.height*3/4))
//                  showHouseLabel.text = "house \(i)"
                    showHouseLabel.text = nameString[i-1]
                    showHouseLabel.textColor = UIColor.blackColor()
                    showHouseLabel.textAlignment = .Center
                    greenHouseButton.addSubview(showHouseLabel)
                    greenHouseButton.addTarget(self, action: #selector(GreenHouseHomeView.gotoSensorList(_:)), forControlEvents: .TouchUpInside)
                    buttons.append(greenHouseButton)
                    
                    if (40 + CGFloat((i-1)) * (view.frame.height/10 + 15) + view.frame.height/10) > view.frame.height {
                    
                        scrollView.contentSize = CGSize(width: view.frame.width,height: (view.frame.height/10 + 15 + CGFloat((i-1)) * (view.frame.height/10 + 15) + view.frame.height/10) + 15)
                    }
                }
                
                
                
            
            }
        
        }
        
        
    }
    
    
    func randomX() ->CGFloat{
        let randomX = CGFloat(arc4random_uniform(UInt32(self.view.frame.width-self.view.frame.width/6))) + self.view.frame.width/12
        
        return randomX
    
    }
    func randomY() ->CGFloat{
    
        let randomY = CGFloat(arc4random_uniform(UInt32(self.view.frame.height-self.view.frame.width/6))) + self.view.frame.width/12
        
        return randomY
    }
    

    func greenHouseColor(value: Int) -> UIColor {
        switch value {
        case 0:
            return UIColor(red: 238.0/255.0, green: 228.0/255.0, blue: 218.0/255.0, alpha: 1.0)
        case 1:
            return UIColor(red: 237.0/255.0, green: 224.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        case 2:
            return UIColor(red: 242.0/255.0, green: 177.0/255.0, blue: 121.0/255.0, alpha: 1.0)
        case 3:
            return UIColor(red: 245.0/255.0, green: 149.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        case 4:
            return UIColor(red: 246.0/255.0, green: 124.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        case 5:
            return UIColor(red: 246.0/255.0, green: 94.0/255.0, blue: 59.0/255.0, alpha: 1.0)
        case 6:
            return UIColor(red: 237.0/255.0, green: 207.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        default:
            return UIColor.whiteColor()
        }
    }
    
    
    func buttonAction(){
    
        
        if number == 2{
            print("wqwqwqwqwqw")
            UIView.animateWithDuration(1, delay: 1, options: .CurveLinear, animations: {
                self.buttons[0].layer.setAffineTransform(CGAffineTransformMakeScale(1, 1))
                }, completion: nil)
            
            if buttons.count > 1{
        
                for i in 2...buttons.count{
                
                    UIView.animateWithDuration(1, delay: NSTimeInterval(1.5 - Double(i)*0.15), options: .TransitionNone, animations: {
                        self.buttons[i - 1].frame = CGRectMake(self.view.frame.width/20,CGFloat((i-1)) * (self.view.frame.height/10 + 15),self.view.frame.width*9/10,self.view.frame.height/10)
                        }, completion: nil)
                
                }
            
            
        
            }
        
         timer.invalidate()
        }
        
        number += 1
        print("asdadsfasfsdfad    \(number)")
        
        
        
    
    }
    
    
    func gotoSensorList(a:UIButton){
    
        
        buttonNumber = Int(a.currentTitle!)
        
        print("ppppp\(buttonNumber)")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            dispatch_async(dispatch_get_main_queue(), {
                self.grayButton.hidden = false
                self.waitView.hidden = false
                self.indicator.startAnimating()
            })
            self.connectHttp(self.buttonNumber)
        }
        
        
    

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSensorList"{
        let sensor = segue.destinationViewController as! SensorListViewController
            sensor.id = buttonNumber
        }
        
        
    }
    
    
    
    func connectHttp(buttonNumber2:Int){
        
        do {
            print(keyString[buttonNumber2 - 1])
            let url:NSURL! = NSURL(string:"http://\(ip)/IAServer/Greenhouse/greenhouseInfo.php?greenhouse_id=\(keyString[buttonNumber2 - 1])")
            let urlRequest:NSURLRequest = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 20)
            let data:NSData = try NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response)
            let dict:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            
            print("qqwqwqwq")
            let dic = dict as! NSDictionary
            
            let token = dic.objectForKey("token") as! String?
            
            if token == "success"{
                
                let data = dic.objectForKey("data") as! [NSDictionary]
                print(data)
                
//                for key in data.keyEnumerator(){
//                    
//                    houseInfo.append(String(data.objectForKey(String(key))!))
//                    
//                    print(String(key))
//                    print(String(data.objectForKey(String(key))!))
//                    
//                }
                for i in 0...data.count - 1{
                    a.greenhouseId = data[i].objectForKey("greenhouse_id") as! NSNumber
                    a.sensor_id = data[i].objectForKey("sensor_id") as! String
                    a.plant_name = data[i].objectForKey("plant_name") as! String
                    a.temperature = Double(data[i].objectForKey("temperature") as! String)!
                    a.hnmidity = Double(data[i].objectForKey("humidity") as! String)!
                    a.start_time = data[i].objectForKey("start_time") as! String
                    sensors.append(a)
                
                }
//                let temInfo = data.objectForKey("temperature") as? NSString
//                let hnmInfo = data.objectForKey("humidity") as? NSString
//                houseInfo.removeAll()
//                houseInfo.append(String(temInfo!))
//                houseInfo.append(String(hnmInfo!))
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.waitView.hidden = true
                    self.grayButton.hidden = true
                    self.indicator.stopAnimating()
                    self.performSegueWithIdentifier("toSensorList", sender: self)
                })
                
            }else{
                let errorMessage = dic.objectForKey("error") as! String
                print(errorMessage)
                
                
                
            }
            
            
        }
        catch{
            
            dispatch_async(dispatch_get_main_queue(), {
                self.waitView.hidden = true
                self.grayButton.hidden = true
                self.indicator.stopAnimating()
                
                self.resultView.hidden = false
                self.timer2 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(GreenHouseHomeView.show), userInfo: nil, repeats: true)
            })
            print("网络问题")
            
        }
        
    }

    
    func show(){
        
        if time == 1{
            
            
            self.resultView.hidden = true
            self.timer2.invalidate()
            
            time = 0
        }
        time += 1
    
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
