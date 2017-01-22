//
//  MapVC.swift
//  SurfMap
//
//  Created by Jonathan Wang on 1/21/17.
//  Copyright © 2017 JonathanWang. All rights reserved.
//

import UIKit
import ArcGIS

class MapVC: UIViewController {
    
    @IBOutlet var mapView: AGSMapView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    var portal : AGSPortal!
    
    var surfline_data = SurfData()
    var day_index = 0
    var time_index = 0
    //var adj_time = 0
    let month_days = [1:31, 2:28, 3:31, 4:30, 5:31, 6:30, 7:31, 8:31, 9:30, 10:31, 11:30, 12:31]
    let wave_hour = [4, 10, 16, 22]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.mapView.touchDelegate = self
        
        // Do any additional setup after loading the view.
        self.portal = AGSPortal(url: URL(string: "http://www.arcgis.com")!, loginRequired: false)
        self.portal.credential = AGSCredential(user: "jonathanzwang", password: "sbhacks2017")
        self.portal.load { (error) in
            if error == nil {
                // check the portal item loaded and print the modified date
                if self.portal.loadStatus == AGSLoadStatus.loaded {
                    //let user = self.portal.user
                    //print(user?.fullName!)
                    let mapUrlString = "http://jonathanzwang.maps.arcgis.com/home/webmap/viewer.html?webmap=bb43628b2e1d4a81b26868e7845a58ce"
                    self.mapView.map = AGSMap(url: NSURL(string: mapUrlString)! as URL)
                    //AGSMap(basemapType: .imageryWithLabels, latitude: 34.4140,  longitude: -119.8489, levelOfDetail: 16)
                    self.populateMapView()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTime () {
        let hour = wave_hour[self.time_index]
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        var year =  components.year
        var month = components.month
        var day = components.day
        
        let currentHour = Calendar.current.component(.hour, from: Date())
        var time_difference = 0
        if (currentHour > 19) {
            time_difference = 3
        } else if (currentHour > 13) {
            time_difference = 2
        } else if (currentHour > 7) {
            time_difference = 1
        }
        
        if (time_difference > 0) {
            self.time_index = self.time_index + time_difference
            if (self.time_index > 3) {
                self.day_index += 1
                self.time_index -= 4
            }
        }
        
        day! += self.day_index
        
        if(day! > month_days[month!]!) {
            day = day! % month_days[month!]!
            month! += 1
            if(month! > 12) {
                year! += 1
            }
        }
        self.dateLabel.text = "Day:     " + String(month!) + "/" + String(day!) + "/" + String(year!)
        self.timeLabel.text = "Time:     " + String(hour) + ":00"
    }

    @IBAction func slider_changed(_ sender: UISlider) {
        get_date_time_idices(slider_num: Int(sender.value))
        self.mapView.graphicsOverlays.removeAllObjects()
        populateMapView()
    }
    
    func get_date_time_idices(slider_num: Int) {
        self.day_index = slider_num / 4
        self.time_index = slider_num % 4
    }
    
    func wave_size(id: Int) -> AGSPictureMarkerSymbol {
        let max: Double = surfline_data.surf_max[id]![day_index][time_index]
        let min: Double = surfline_data.surf_min[id]![day_index][time_index]
        let size: Double = (max + min) / 2
        if size < 2.0 {
            return AGSPictureMarkerSymbol(image: #imageLiteral(resourceName: "water_drop"))
        } else if size < 4.0 {
            return AGSPictureMarkerSymbol(image: #imageLiteral(resourceName: "triple_drop"))
        } else {
            return AGSPictureMarkerSymbol(image: #imageLiteral(resourceName: "wave"))
        }
    }
    
    func populateMapView () {
        updateTime()
        // Create points and text for beach name labels
        var beach_points_and_symbols = [(AGSPoint, AGSPictureMarkerSymbol)]()
        for (id, (lat, long)) in surfline_data.coordinates {
            let beach_point = AGSPointMakeWGS84(lat, long)
            let beach_symbol = wave_size(id: Int(id))
            beach_symbol.height = 30
            beach_symbol.width = 30
            beach_points_and_symbols.append(beach_point, beach_symbol)
        }

        //greate a graphic with the symbol
        var beach_graphics = [AGSGraphic]()
        for (beach_point, beach_symbol) in beach_points_and_symbols {
            beach_graphics.append(AGSGraphic(geometry: beach_point, symbol: beach_symbol))
        }
        
        let surfline_overlay = AGSGraphicsOverlay()
        
        //add all the graphics here
        for graphic_ in beach_graphics {
            surfline_overlay.graphics.add(graphic_)
        }
        
        //add the overlay to the map
        self.mapView.graphicsOverlays.add(surfline_overlay)
    }
    

    
    // MARK:   Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "Details Segue") {
            let dest = segue.destination as! DetailsVC
            /*
            dest.beach_name =
            dest.surf_max =
            dest.surf_min =
            dest.wind_direction_speed =
 */
        }
    }
    

}
