//
//  SensorListViewController.swift
//  MySmartAgriculture
//
//  Created by 王凯 on 16/5/23.
//  Copyright © 2016年 joyyog. All rights reserved.
//

import UIKit

class SensorListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var id:Int!
    var sensorId:Int!
    var refreshControl = UIRefreshControl()
    @IBAction func backToHome(sender: AnyObject) {
        self.performSegueWithIdentifier("backToHome", sender: self)
        
        sensors.removeAll()
    }
    @IBOutlet weak var greenName: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(nameString[id-1])
        greenName.setTitle("\(nameString[id-1])", forState: .Normal)
        greenName.layer.cornerRadius = 12
        greenName.enabled = false
        backButton.layer.cornerRadius = backButton.frame.width/2
        backButton.clipsToBounds = true
        
        refreshControl.addTarget(self, action: #selector(SensorListViewController.refreshData), forControlEvents: .ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "松开后自动刷新")
        tableView.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sensorCells") as! SensorCells
        cell.sensorName.text = sensors[indexPath.row].plant_name
        cell.sensorTem.text = "\(String(sensors[indexPath.row].temperature)) ℃"
        cell.sensorHnm.text = "\(String(sensors[indexPath.row].hnmidity)) %"

        let randomColor:Int = Int(arc4random_uniform(7))
        cell.buttonImage.backgroundColor = greenHouseColor(randomColor)
        cell.buttonImage.layer.cornerRadius = cell.buttonImage.frame.width/2
        cell.buttonImage.setTitle("\(indexPath.row+1)", forState: .Normal)
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        sensorId = indexPath.row
        self.performSegueWithIdentifier("toSensor", sender: self)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("ffffff")
        if segue.identifier == "toSensor"{
            let sensorView = segue.destinationViewController as! SensorView
            sensorView.sensorId = self.sensorId
            sensorView.id = self.id
            
            
            print("chuandile")
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
    
    
    
    func refreshData(){
    
        print("刷新")
        
        sensors.removeAll()
        
        
        do {
            
            let url:NSURL! = NSURL(string:"http://\(ip)/IAServer/Greenhouse/greenhouseInfo.php?greenhouse_id=\(keyString[id - 1])")
            let urlRequest:NSURLRequest = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 20)
            let data:NSData = try NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response)
            let dict:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            
            
            let dic = dict as! NSDictionary
            
            let token = dic.objectForKey("token") as! String?
            
            if token == "success"{
                
                let data = dic.objectForKey("data") as! [NSDictionary]
                for i in 0...data.count - 1{
                    a.greenhouseId = data[i].objectForKey("greenhouse_id") as! NSNumber
                    a.sensor_id = data[i].objectForKey("sensor_id") as! String
                    a.plant_name = data[i].objectForKey("plant_name") as! String
                    a.temperature = Double(data[i].objectForKey("temperature") as! String)!
                    a.hnmidity = Double(data[i].objectForKey("humidity") as! String)!
                    a.start_time = data[i].objectForKey("start_time") as! String
                    sensors.append(a)
                    
                }
                refreshControl.endRefreshing()
                tableView.reloadData()

            }else{
                let errorMessage = dic.objectForKey("error") as! String
                print(errorMessage)
                
                
                
            }
            
            
        }
        catch{
            
            print("网络问题")
            
        }
        
    

    
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
