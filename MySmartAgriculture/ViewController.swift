//
//  ViewController.swift
//  MySmartAgriculture
//
//  Created by 王凯 on 16/3/30.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

//var greenHouses = [greenHouse]()
var sensors = [Sensor]()
var keyString = [String]()
var keyString2 = [String]()
var nameString = [String]()

var a = Sensor(temperature:1.1,hnmidity: 1.1)
var userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
var number:Int = 1

var ip:String = "www.lynnfly.cn"
var pn:String = "http://\(ip)/IAServer/UserMan/login.php"

var phoneNumber:String!
var password:String!

var response:NSURLResponse?

var error:NSError?




class ViewController: UIViewController,UITextFieldDelegate {

    
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButton2: UIButton!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var wrongText: UILabel!
    
    var backgroundButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 228/255, green: 229/255, blue: 198/255, alpha: 1)
        
        loginView.hidden = true
        
        loginButton.layer.cornerRadius = 12
        loginButton2.layer.cornerRadius = 12
        
        loginButton.addTarget(self, action: #selector(ViewController.goToLogin), forControlEvents: .TouchUpInside)
        
        loginButton2.addTarget(self, action: #selector(ViewController.login), forControlEvents: .TouchUpInside)
        
        
        
        phoneNumberText.delegate = self
        passwordText.delegate = self
        
        wrongText.textColor = UIColor.redColor()
        wrongText.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLogin(){
        backgroundButton = UIButton(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.height))
        backgroundButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        self.view.addSubview(backgroundButton)
        self.view.bringSubviewToFront(backgroundButton)
        
        wrongText.hidden = true
        loginView.hidden = false
        self.view.bringSubviewToFront(loginView)
        backgroundButton.addTarget(self, action: #selector(ViewController.back), forControlEvents: .TouchUpInside)
        
        self.loginView.layer.setAffineTransform(CGAffineTransformMakeScale(0.1, 0.1))
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.loginView.layer.setAffineTransform(CGAffineTransformMakeScale(1.1, 1.1))
            }) { (finished:Bool) -> Void in
                self.loginView.layer.setAffineTransform(CGAffineTransformIdentity)
        }
    
        print(self.view.frame.width)
        print(self.view.frame.height)
        



        
    }
    
    func back(){
        self.backgroundButton.hidden = true
        self.loginView.hidden = true
        
    }
    
    func login(){
        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.loginButton2.setTitle("正在登录...", forState: .Normal)
//                            })
        phoneNumber = phoneNumberText.text
        password = passwordText.text
        wrongText.hidden = true
        
        
        phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
        password = password.stringByReplacingOccurrencesOfString(" ", withString: "")
       // connectHttp()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),{
            self.connectHttp()
        
        })
        dispatch_async(dispatch_get_main_queue(), {
            self.loginButton2.setTitle("正在登录...", forState: .Normal)
            self.loginButton2.enabled = false
        
        })
        
    
    }
    
    func connectHttp(){
        
        do {
            print("\(phoneNumber)sd")
            let url:NSURL! = NSURL(string:"\(pn)?username=\(phoneNumber)&password=\(password)")
            let urlRequest:NSURLRequest = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 10)
            let data:NSData = try NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response)
            let dict:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
     
            
            
            let dic = dict as! NSDictionary
            
            let token = dic.objectForKey("token") as! String?
            
            if token == "success"{
//                print(token)
//                var houses = dic.objectForKey("data") as! [String]
//                for i in houses{
//                    greenHouses.append(a)
//                    print(i)
//                    print(greenHouses.count)
//                   
//                }
//                self.performSegueWithIdentifier("loginSuccess", sender: self)
                
          
                
                let data = dic.objectForKey("data") as! NSArray
                print(data)
//                for key in data.keyEnumerator(){
//                    keyString.append(String(key))
//                    nameString.append(String(data.objectForKey(String(key))!))
//                    greenHouses.append(a)
//                    print(String(key))
//                    print(String(data.objectForKey(String(key))!))
//                
//                }
                for i in 0...data.count - 1{
                    let information = data[i] as! NSDictionary
                    let greenhouse_id = information.objectForKey("greenhouse_id") as! NSNumber
                    keyString.append(String(greenhouse_id))
                    let greenhouse_name = information.objectForKey("greenhouse_name") as! NSString
                    nameString.append(String(greenhouse_name))
                    //sensors.append(a)
                }
                
                
                self.performSegueWithIdentifier("loginSuccess", sender: self)
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), {
                    let errorMessage = dic.objectForKey("error") as! String
                    print(errorMessage)
                    self.wrongText.text = errorMessage
                    self.wrongText.hidden = false
                    self.loginButton2.setTitle("login", forState: .Normal)
                    self.loginButton2.enabled = true
                })
                
                //self.loginButton2.setTitle("login", forState: .Normal)
                
                
            }
            
            
        }
        catch{
//            self.loginButton2.setTitle("login", forState: .Normal)
            print("网络问题")
            
//            wrongText.text = "网络问题"
//            wrongText.hidden = false
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.wrongText.text = "网络问题"
                self.wrongText.hidden = false
                self.loginButton2.setTitle("login", forState: .Normal)
                self.loginButton2.enabled = true
            })
            
            
        }
        
    }


    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        view.endEditing(true)
    }
   

}

