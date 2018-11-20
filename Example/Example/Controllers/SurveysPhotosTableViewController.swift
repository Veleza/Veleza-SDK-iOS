//
//  SurveysPhotosTableViewController.swift
//  Example
//
//  Created by Vytautas Povilaitis on 20/11/2018.
//  Copyright © 2018 Veleza. All rights reserved.
//

import Foundation
import VelezaSDK

class SurveysPhotosTableViewController: UITableViewController {
    
    var widgetCell: SurveysPhotosTableViewWidgetCell?
    var widgetIndexPath = IndexPath(row: 2, section: 1)
    var widgetIsLoaded = false
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section + 1)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == widgetIndexPath && widgetIsLoaded {
            return widgetCell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = "Section \(indexPath.section + 1) Row \(indexPath.row + 1)"
        return cell
    }
    
}


extension SurveysPhotosTableViewController: VelezaWidgetDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        widgetCell = self.tableView.dequeueReusableCell(withIdentifier: "WidgetCell", for: widgetIndexPath) as? SurveysPhotosTableViewWidgetCell
        
        widgetCell?.widget?.delegate = self
        widgetCell?.widget?.identifier = "00689304051019"
    }
    
    func velezaWidget(_ widget: VelezaWidget, shouldBeDisplayed: Bool) {
        if widgetIsLoaded != shouldBeDisplayed {
            widgetIsLoaded = shouldBeDisplayed
            
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [widgetIndexPath], with: UITableView.RowAnimation.automatic)
            self.tableView.endUpdates()
        }
    }

    func velezaWidget(needsLayoutUpdateFor widget: VelezaWidget) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
}


class SurveysPhotosTableViewWidgetCell: UITableViewCell {
    
    @IBOutlet var widget: VelezaSurveysPhotosWidget?

}

