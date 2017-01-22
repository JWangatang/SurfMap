//
//  DetailsVC.swift
//  SurfMap
//
//  Created by Jonathan Wang on 1/21/17.
//  Copyright © 2017 JonathanWang. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {

    let beach_name = String()
    let surf_max = [Int : [[Double]]]()
    let surf_min = [Int : [[Double]]]()
    let wind_direction_speed = [Int : ([[Int]], [[Double]])]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
