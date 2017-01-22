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
    
    let waves = ["💧", "💦", "🌊"]

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
        //use Late/Long here
        let point = AGSPointMakeWGS84(34.4140, -119.8489)
        
        //create the symbol (depending on wave size)
        let symbol = AGSTextSymbol(text: waves[0], color: UIColor(red: 0, green: 0, blue: 200/255, alpha: 1), size: 15, horizontalAlignment: AGSHorizontalAlignment.center, verticalAlignment: AGSVerticalAlignment.middle)

        //greate a graphic with the symbol
        let graphic = AGSGraphic(geometry: point, symbol: symbol)
        
        //create an overlay for the map
        let overlay = AGSGraphicsOverlay()
        
        //add all the graphics here
        overlay.graphics.add(graphic)
        
        //add the overlay to the map
        self.mapView.graphicsOverlays.add(overlay)
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
