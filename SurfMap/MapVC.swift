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
    var portal : AGSPortal!
    
    var surfline_data = SurfData()
    let waves = ["💧", "💦", "🌊"]
    var day_index = 0
    var time_index = 0

    @IBAction func slider_changed(_ sender: UISlider) {
        (self.day_index, self.time_index) = get_date_time_idices(slider_num: Int(sender.value))
        self.mapView.graphicsOverlays.removeAllObjects()
        populateMapView()
    }
    
    func get_date_time_idices(slider_num: Int) -> (Int, Int) {
        let day_index = slider_num / 4
        let time_index = slider_num % 4

        return (day_index, time_index)
    }
    
    func wave_size(id: Int) -> String {
        let max: Double = surfline_data.surf_max[id]![day_index][time_index]
        let min: Double = surfline_data.surf_min[id]![day_index][time_index]
        let size: Double = (max + min) / 2
        if size < 2.0 {
            return waves[0]
        } else if size < 4.0 {
            return waves[1]
        } else {
            return waves[2]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func populateMapView () {
        // Create points and text for beach name labels
        var beach_points_and_symbols = [(AGSPoint, AGSTextSymbol)]()
        for (id, (lat, long)) in surfline_data.coordinates {
            let beach_point = AGSPointMakeWGS84(lat, long)
            let beach_symbol = AGSTextSymbol(text: wave_size(id: Int(id)), color: UIColor(red: 0, green: 0, blue: 200/255, alpha: 1), size: 15, horizontalAlignment: AGSHorizontalAlignment.center, verticalAlignment: AGSVerticalAlignment.middle)
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
    

    /*
    // MARK:   Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
