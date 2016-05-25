//
//  FormViewController.swift
//  MySmartAgriculture
//
//  Created by 王凯 on 16/5/25.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class FormViewController: UIViewController,UITextFieldDelegate {

    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var deletePlant: UITextField!
    
    @IBOutlet weak var addPlant: UITextField!
    
    @IBOutlet weak var startTime: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var waitView: UIView!
    
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
   
    
    @IBOutlet weak var grayButton: UIButton!
    
    @IBAction func done(sender: AnyObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue(), {
                self.waitView.hidden = false
                self.grayButton.hidden = false
                self.indicatorView.startAnimating()
            })
            self.connectHttp()
        }
        
        
    }
    
    @IBAction func back(sender: AnyObject) {
        
        self.performSegueWithIdentifier("back", sender: self)
        
    }

    
    
    var id:Int!
    var sensorId:Int!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waitView.hidden = true
        grayButton.hidden = true
        deletePlant.placeholder = sensors[sensorId].plant_name
        deletePlant.enabled = false
        
        titleLabel.layer.cornerRadius = 12
        titleLabel.clipsToBounds = true
        doneButton.layer.cornerRadius = 12
        doneButton.clipsToBounds = true
        backButton.layer.cornerRadius = 12
        backButton.clipsToBounds = true
        
    }
    
    
    
    
    
    
    
    
    
    func connectHttp(){
        
        do {
            print(addPlant.text!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
    
            let url:NSURL! = NSURL(string:"http://\(ip)/IAServer/Greenhouse/newPlant.php?sensor_id=\(sensors[sensorId].sensor_id)&plant_name=\(addPlant.text!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)&start_time=\(startTime.text!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)")
            print(url)
            let urlRequest:NSURLRequest = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 10)
            let data:NSData = try NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response)
            let dict:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            
            print("qqwqwqwq")
            let dic = dict as! NSDictionary
            
            let token = dic.objectForKey("token") as! String?
            
            if token == "success"{
                print("success")

                sensors[sensorId].plant_name = addPlant.text!
                sensors[sensorId].start_time = startTime.text!
                addPlant.text = nil
                startTime.text = nil
                dispatch_async(dispatch_get_main_queue(), {
                    self.waitView.hidden = true
                    self.grayButton.hidden = true
                    self.indicatorView.stopAnimating()
                })
                
                
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
        if segue.identifier == "back"{
        
            let sensor = segue.destinationViewController as! SensorView
            sensor.id = self.id
            sensor.sensorId = self.sensorId
        
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
