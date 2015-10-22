//
//  ViewController.swift
//  ConsumingJSON
//
//  Created by Trevor Nestman on 10/20/15.
//  Copyright © 2015 Trevor Nestman. All rights reserved.
//
//  Todo:
//  I plan on adding iCore to this program and having a history of previously searched cities
//  I would also like to add a 5-7 day forecast
//  Better asthetics would be nice too
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextView: UITextField!
    @IBOutlet weak var cityDidLoadLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityTempLabel: UILabel!
    @IBAction func getDataButtonClicked(sender: AnyObject) {
        getWeatherData("http://api.openweathermap.org/data/2.5/weather?q=\(searchableCity(cityNameTextView.text!))&APPID=616db91ad987939b66831bb8b6d3e9f4")
        
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
    //searchableCity adjusts the user's input so it can make a proper request
    func searchableCity(city: String) -> String{
        return city.stringByReplacingOccurrencesOfString(" ", withString: "%20") //replace all spaces with %20
    }

    func getWeatherData(urlString: String) {

        let url = NSURL(string: urlString)
        print(url?.description)
        if url != nil{
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.setLabels(data!) //Error here :fatal error: unexpectedly found nil while unwrapping ...
                })
            }
            task.resume()
        }else{
            self.cityDidLoadLabel.text = "Error with sent paramaters"
        }
    }
    
    func setLabels(weatherData: NSData){
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(weatherData, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
            // this is nice to see in the console so we know what the json looking like
            print(json)

            if let codeError = json[("cod")] as? String{
                
                if codeError == "404"{
                    self.cityDidLoadLabel.text = "ERROR 404\nCity Not Found"
                }
            }else{
                self.cityDidLoadLabel.text = "City Loaded Successfully"
            }
            
            if let name = json[("name")] as? String {
                //Set the name by default
                self.cityNameLabel.text =  name
            
                //Now we'll try to get the country
                if let sys = json[("sys")] as? NSDictionary {
                    if let country = sys[("country")] as? String {
                        self.cityNameLabel.text = name + ", " + country
                    }
                }
            }
            
            if let main = json[("main")] as? NSDictionary {
                if let temp = main[("temp_max")] as? Double {
                    //convert kelvin to farenhiet
                    let ft = (temp * 9/5 - 459.67)
                    
                    let myString = Int(round(ft)).description
                    
                    self.cityTempLabel.text = myString + "°F"
                    
                }
            }
            
            
        } catch let error as NSError {
            print(error)
        }
        
    }
}

