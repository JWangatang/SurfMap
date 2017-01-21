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
    var dicts: Array<NSDictionary> = []

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


func get_Surf_data(dataKey: String, surfdata: SurfData) -> [Int : [[Float]]] {
    var Surf_data = [Int : [[Float]]]()
    for dict in surfdata.dicts {
        let id = (dict["id"] as! NSString).intValue
        let data_dict = dict["Surf"] as! NSDictionary
        let data = data_dict[dataKey] as! [[Float]]
        Surf_data[Int(id)] = data
    }
    return Surf_data
}
