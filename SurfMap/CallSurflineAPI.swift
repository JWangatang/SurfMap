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
    }

    func add_data(data: NSDictionary) -> Void {
        let id = Int((data["id"] as! NSString).intValue)
        self.dicts.append(data)
        self.surf_max.updateValue(extract_Surf_data(dataKey: "surf_max", dict: data, surfdata: self), forKey: id)
        self.surf_min.updateValue(extract_Surf_data(dataKey: "surf_min", dict: data, surfdata: self), forKey: id)
        self.coordinates.updateValue(extract_lat_lon_data(dict: data, surfdata: self), forKey: id)
    }
}


func get_surfline_data(spot_id: UInt32, surfdata: SurfData) -> Void {
    let api_call: String = "https://api.surfline.com/v1/forecasts/\(spot_id)?"
    Alamofire.request(api_call).responseJSON { response in
        let JSON = response.result.value as! NSDictionary
        surfdata.add_data(data: JSON)
    }
}


func extract_Surf_data(dataKey: String, dict: NSDictionary, surfdata: SurfData) -> [[Float]] {
    /*
     Return dictionary with Int as key and Array of Arrays containing Floats as values.

     For surf_max as dataKey:
        dict[id][0] is an Array containing surf height in feet for today at 4am, 10am, 4pm, and 10pm.
        dict[id][1] is for the next day and so on.
     */
    let data_dict = dict["Surf"] as! NSDictionary
    let data = data_dict[dataKey] as! [[Float]]

    return data
}

func extract_lat_lon_data(dict: NSDictionary, surfdata: SurfData) -> (Float, Float) {
    /*
     Return dictionary with Int as keys and Tuple(latitude, longitude) as values.
     */
    let lat = (dict["lat"] as! NSString).floatValue
    let lon = (dict["lon"] as! NSString).floatValue

    return (lat, lon)
}
