//
//  AutoLoginViewController.swift
//  MySmartAgriculture
//
//  Created by 王凯 on 16/6/6.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class AutoLoginViewController: UIViewController {

    
    @IBOutlet weak var waitView: UIView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var resultView: UIView!
    
    var timer:NSTimer!
    var time = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        waitView.hidden = true
        resultView.hidden = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.waitView.hidden = false
                self.indicator.startAnimating()
            })
            
            self.connectHttp()
            
        }
        
        
    }
    
    func connectHttp(){
        
        do {
            let phoneNumber = userDefault.objectForKey("identifier")
            let password = userDefault.objectForKey("password")
            print(phoneNumber)
            print(password)
            let url:NSURL! = NSURL(string:"http://\(ip)/IAServer/UserMan/login.php?username=\(phoneNumber!)&password=\(password!)")
            let urlRequest:NSURLRequest = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 10)
            let data:NSData = try NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response)
            let dict:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            
            
            let dic = dict as! NSDictionary
            
            let token = dic.objectForKey("token") as! String?
            
            if token == "success"{
                
                let data = dic.objectForKey("data") as! NSArray
                print(data)
                for i in 0...data.count - 1{
                    let information = data[i] as! NSDictionary
                    let greenhouse_id = information.objectForKey("greenhouse_id") as! NSNumber
                    keyString.append(String(greenhouse_id))
                    let greenhouse_name = information.objectForKey("greenhouse_name") as! NSString
                    nameString.append(String(greenhouse_name))
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.waitView.hidden = true
                    self.performSegueWithIdentifier("success", sender: self)
                })
                
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), {
                    let errorMessage = dic.objectForKey("error") as! String
                    print(errorMessage)
                    self.waitView.hidden = true
                    self.indicator.stopAnimating()
                    
                    self.resultView.hidden = false
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(UIAlertView.show), userInfo: nil, repeats: true)
            
                })
                
                
                
                
            }
            
            
        }
        catch{
            //            self.loginButton2.setTitle("login", forState: .Normal)
            print("网络问题")
            
            //            wrongText.text = "网络问题"
            //            wrongText.hidden = false
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.waitView.hidden = true
                self.indicator.stopAnimating()
                
                self.resultView.hidden = false
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(UIAlertView.show), userInfo: nil, repeats: true)
            })
            
            
        }
        
    }
    
    func show(){
        
        if time == 1{
            
            
            self.resultView.hidden = true
            self.timer.invalidate()
            self.performSegueWithIdentifier("fail", sender: self)
            
            time = 0
        }
        time += 1
        
    }
    
    
}
