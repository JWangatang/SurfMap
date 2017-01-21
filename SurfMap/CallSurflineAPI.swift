//
//  CallSurflineAPI.swift
//  SurfMapMac
//
//  Created by Patrick Woo-Sam on 1/21/17.
//  Copyright © 2017 Patrick Woo-Sam. All rights reserved.
//

import Foundation
import Alamofire


class SurfData {
    let SB_spot_ids = ["Refugio": 4991, "El Capitan": 4993, "Sands": 4994, "Coal Oil Point": 4995,
                       "Campus Point": 4997, "Leadbetter": 4990, "Sandspit": 4998,
                       "Santa Barbara Harbor": 139341, "Hammond's": 4999,
                       "Carpenteria State Beach": 5001, "Tarpits": 5000, "Rincon": 4197]
    var dicts: Array<NSDictionary> = []
    var surf_max = [Int : [[Float]]]()
    var surf_min = [Int : [[Float]]]()
    var coordinates = [Int : (Float, Float)]()

    init() {
        // Find all JSON for the beaches in SB and place data into self.dicts
        for id in SB_spot_ids.values {
            get_surfline_data(spot_id: UInt32(id), surfdata: self)
        }
        self.surf_max = extract_Surf_data(dataKey: "surf_max", surfdata: self)
        self.surf_min = extract_Surf_data(dataKey: "surf_min", surfdata: self)
        self.coordinates = extract_lat_lon_data(surfdata: self)
    }

    func add_data(data: NSDictionary) -> Void {
        self.dicts.append(data)
    }
}


func get_surfline_data(spot_id: UInt32, surfdata: SurfData) -> Void {
    let api_call: String = "https://api.surfline.com/v1/forecasts/\(spot_id)?"
    Alamofire.request(api_call).responseJSON { response in
        let JSON = response.result.value as! NSDictionary
        surfdata.add_data(data: JSON)
    }
}


func extract_Surf_data(dataKey: String, surfdata: SurfData) -> [Int : [[Float]]] {
    /*
     Return dictionary with Int as key and Array of Arrays containing Floats as values.

     For surf_max as dataKey:
        dict[id][0] is an Array containing surf height in feet for today at 4am, 10am, 4pm, and 10pm.
        dict[id][1] is for the next day and so on.
     */
    var Surf_data = [Int : [[Float]]]()
    for dict in surfdata.dicts {
        let id = (dict["id"] as! NSString).intValue
        let data_dict = dict["Surf"] as! NSDictionary
        let data = data_dict[dataKey] as! [[Float]]
        Surf_data[Int(id)] = data
    }
    return Surf_data
}

func extract_lat_lon_data(surfdata: SurfData) -> [Int : (Float, Float)] {
    /*
     Return dictionary with Int as keys and Tuple(latitude, longitude) as values.
     */
    var lat_lon_data = [Int : (Float, Float)]()
    for dict in surfdata.dicts {
        let id = (dict["id"] as! NSString).intValue
        let lat = (dict["lat"] as! NSString).floatValue
        let lon = (dict["lon"] as! NSString).floatValue
        lat_lon_data[Int(id)] = (lat, lon)
    }
    return lat_lon_data
}
