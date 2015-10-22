//
//  ViewController.swift
//  ConsumingJSON
//
//  Created by Trevor Nestman on 10/20/15.
//  Copyright © 2015 Trevor Nestman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextView: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityTempLabel: UILabel!
    @IBAction func getDataButtonClicked(sender: AnyObject) {
        getWeatherData("http://api.openweathermap.org/data/2.5/weather?q=\(cityNameTextView.text!)&APPID=616db91ad987939b66831bb8b6d3e9f4")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherData("http://api.openweathermap.org/data/2.5/weather?id=5781004&APPID=616db91ad987939b66831bb8b6d3e9f4")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getWeatherData(urlString: String) {
//        var url : NSURL = NSURL(string: urlString)!
//        let session = NSURLSession.sharedSession()
//        var task = session.dataTaskWithURL(url, completionHandler: {
//            (data, response, error) -> Void in
//            self.setLabels(data!)
//        })
//        task.resume()
//        
//        /*
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
                self.setLabels(data!) //Error here :fatal error: unexpectedly found nil while unwrapping ...
            })
        }
        
        task.resume()
        
    }
    
    func setLabels(weatherData: NSData){
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(weatherData, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
            print(json)
            
            if let name = json[("name")] as? String {
                cityNameLabel.text = name
            }
            
            if let main = json[("main")] as? NSDictionary {
                if let temp = main[("temp_max")] as? Double {
                    //convert kelvin to farenhiet
                    let ft = (temp * 9/5 - 459.67)
                    
                    let myString = ft.description
                    
                    cityTempLabel.text = myString
                    
                }
            }
            
            
        } catch let error as NSError {
            print(error)
        }
        
    }
}

