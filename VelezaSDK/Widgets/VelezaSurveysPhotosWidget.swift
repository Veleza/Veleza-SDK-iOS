//
//  VelezaSurveysPhotos.swift
//  Veleza
//
//  Created by Vytautas Povilaitis on 12/11/2018.
//  Copyright © 2018 Veleza. All rights reserved.
//

import Foundation

public class VelezaSurveysPhotosWidget: VelezaWidget {
    
    @IBInspectable public var padding: CGFloat = 20.0 {
        didSet {
            postGrid.padding = padding
            footerWidthConstraint?.constant = padding * -2
            surveysWidthConstraint?.constant = padding * -2
        }
    }
    
    @IBInspectable public var imageRows: Int = 1 {
        didSet {
            postGrid.rows = imageRows
        }
    }
    
    @IBInspectable public var imageSpacing: CGFloat = 10 {
        didSet {
            postGrid.spacing = imageSpacing
        }
    }
    
    @IBInspectable public var visibleSurveys: Int = 4 {
        didSet {
            surveysView.visibleSurveys = visibleSurveys
        }
    }
    
    var postGrid = VelezaPostGrid()
    var surveysView = VelezaSurveysListView()
    
    weak var surveysWidthConstraint: NSLayoutConstraint?
    weak var footerWidthConstraint: NSLayoutConstraint?
    
    override func request() {
        let path = String(format: "widgets/%@/surveys_photos/%@", VelezaSDK.clientId!, identifier!)
        let params = [
            "rows": String(imageRows),
        ]
        VelezaAPIRequest(withMethod: "GET", path: path, params: params).execute(onSuccess: { (_, _, response) in
            if let identifier = response["identifier"] as? String, let widget = response["widget_name"] as? String {
                self.trackingData["widget"] = widget
                self.trackingData["identifier"] = identifier
                if let data = response["data"] as? [String: Any] {
                    if let trackData = data["trackData"] as? [String: Any] {
                    
                        trackData.forEach {
                            if let value = $1 as? String {
                                self.trackingData[$0] = value
                            }
                        }
                    
                        if trackData["state"] as? String == "show" {
                            VelezaSDK.amplitude?.logEvent("Widget - Create", withEventProperties: self.trackingData)
                            self.setup(data: data)
                            return
                        }
                    }
                }

                VelezaSDK.amplitude?.logEvent("Widget - Create", withEventProperties: self.trackingData)
                self.delegate?.velezaWidget(self, shouldBeDisplayed: false)
                return
            }
            
            VelezaSDK.amplitude?.logEvent("Widget - Error", withEventProperties: self.trackingData)
            self.delegate?.velezaWidget(self, shouldBeDisplayed: false)
        }) { (error) in
            VelezaSDK.amplitude?.logEvent("Widget - Error", withEventProperties: [
                "error" : error.debugDescription,
            ])
            self.delegate?.velezaWidget(self, shouldBeDisplayed: false)
        }
    }
    
    func setup(data: [String: Any]) {
        super.setup()
        
        var hasPosts = false
        if let dataSource = data["posts_api"] as? [String: Any] {
            if let totalString = dataSource["total"] as? String, let total = Int(totalString), total > 0 {
                if let path = dataSource["path"] as? String, let scope = dataSource["scope"] as? String, let model = dataSource["model"] as? String {
                    hasPosts = true
                    
                    postGrid.trackingData = trackingData
                    postGrid.apiPath = path
                    postGrid.apiScope = scope
                    postGrid.apiModel = model
                    postGrid.total = total
                    postGrid.setup()
                    postGrid.layoutDelegate = self
                    addSubview(postGrid)
                    postGrid.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
                    postGrid.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
                    postGrid.topAnchor.constraint(equalTo: topAnchor).isActive = true
                }
            }
        }
        
        var hasSurveys = false
        if let surveys = data["answers"] as? [Any], surveys.count > 0 {
            hasSurveys = true
            
            surveysView.trackingData = trackingData
            surveysView.visibleSurveys = visibleSurveys
            surveysView.surveys = surveys
            surveysView.layoutDelegate = self
            addSubview(surveysView)
            surveysView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            if hasPosts {
                surveysView.topAnchor.constraint(equalTo: postGrid.bottomAnchor, constant: 20).isActive = true
            }
            else {
                surveysView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
            }
            
            surveysWidthConstraint = surveysView.widthAnchor.constraint(equalTo: widthAnchor, constant: padding * -2)
            surveysWidthConstraint!.isActive = true
        }
        
        if !hasPosts && !hasSurveys {
            self.delegate?.velezaWidget(self, shouldBeDisplayed: false)
            return
        }
        
        if let lang = data["lang"] as? [String: Any] {
            if let footer = lang["ratings_and_images_from"] as? String {
                self.footer.text = footer
            }
        }
        addSubview(footer)
        footer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        footer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        footer.topAnchor.constraint(equalTo: surveysView.bottomAnchor, constant: 10).isActive = true

        footerWidthConstraint = footer.widthAnchor.constraint(equalTo: widthAnchor, constant: padding * -2)
        footerWidthConstraint!.isActive = true
        
        self.delegate?.velezaWidget(self, shouldBeDisplayed: true)
        self.delegate?.velezaWidget(needsLayoutUpdateFor: self)
    }
    
}
