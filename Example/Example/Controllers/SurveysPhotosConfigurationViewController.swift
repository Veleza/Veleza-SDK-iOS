//
//  ViewController.swift
//  Example
//
//  Created by Vytautas Povilaitis on 19/11/2018.
//  Copyright © 2018 Veleza. All rights reserved.
//

import UIKit
import VelezaSDK

class SurveysPhotosConfigurationViewController: UIViewController {
    
    @IBOutlet var widget: VelezaSurveysPhotosWidget?

    @IBAction func setPhotoRowCount(sender: UISegmentedControl) {
        widget?.imageRows = sender.selectedSegmentIndex + 1
    }

}

