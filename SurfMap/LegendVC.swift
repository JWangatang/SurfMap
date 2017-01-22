//
//  LegendVC.swift
//  SurfMap
//
//  Created by Jonathan Wang on 1/22/17.
//  Copyright © 2017 JonathanWang. All rights reserved.
//

import UIKit

class LegendVC: UIViewController {

    @IBOutlet var bigWaveLabel: UILabel!
    @IBOutlet var mediumWaveLabel: UILabel!
    @IBOutlet var smallWaveLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigWaveLabel.text = "🌊 Big Wave (>4 ft)"
        mediumWaveLabel.text = "💦 Medium Wave (2 - 4 ft)"
        smallWaveLabel.text = "💧 Small Wave (< 2 ft)"
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
