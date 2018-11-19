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
    
    
    @IBAction func setWidgetPadding(sender: UISegmentedControl) {
        widget?.padding = CGFloat(sender.selectedSegmentIndex * 20)
    }

    @IBAction func setPhotoRowCount(sender: UISegmentedControl) {
        widget?.imageRows = sender.selectedSegmentIndex + 1
    }

    @IBAction func setPhotoSpacing(sender: UISegmentedControl) {
        widget?.imageSpacing = CGFloat(sender.selectedSegmentIndex * 10)
    }

    @IBAction func setSurveyCount(sender: UISegmentedControl) {
        widget?.visibleSurveys = (sender.selectedSegmentIndex + 1) * 2
    }

}

