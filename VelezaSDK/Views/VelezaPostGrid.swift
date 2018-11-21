//
//  PostGrid.swift
//  Veleza
//
//  Created by Vytautas Povilaitis on 13/11/2018.
//  Copyright © 2018 Veleza. All rights reserved.
//

import Foundation
import PINRemoteImage
import DTPhotoViewerController

class VelezaPostGrid: UIView {

    var rows = 1 {
        didSet {
            render()
        }
    }
    
    var itemSize: CGFloat = round(UIScreen.main.bounds.size.width / 3) {
        didSet {
            render()
        }
    }
    
    var spacing: CGFloat = 10 {
        didSet {
            render()
        }
    }
    
    var padding: CGFloat = 20 {
        didSet {
            render()
        }
    }

    weak var layoutDelegate: VelezaWidgetLayoutDelegate?
    
    var apiT: String = String(Int(Date().timeIntervalSince1970 / 60))
    var apiGoal: String? = "engagement"
    var apiModel: String?
    var apiScope: String?
    var apiPath: String?

    var trackingData: [String: String] = [:]
    
    fileprivate var selectedImageIndex: Int = 0
    fileprivate var posts: [Any] = []
    fileprivate var pageSize = 10
    fileprivate var requestingPages: [Int: Bool] = [:]
    fileprivate var models: [String: [String: Any]] = [:]
    var total: Int = 0 {
        didSet {
            if posts.count < total {
                while posts.count < total {
                    posts.append([:])
                }
                render()
            }
        }
    }
    
    fileprivate var layout = UICollectionViewFlowLayout()
    fileprivate weak var collectionView: UICollectionView?
    fileprivate weak var heightConstraint: NSLayoutConstraint?
    
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        request(page: 0)
    
        let _rows = max(CGFloat(rows), 1.0)
        let _itemSize = max(itemSize, 80.0)
        
        heightConstraint = heightAnchor.constraint(equalToConstant: _rows * _itemSize + (_rows - 1) * spacing)
        heightConstraint?.isActive = true
        
        let cv = UICollectionView(frame: bounds, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(VelezaPostGridCell.self, forCellWithReuseIdentifier: "VelezaPostGridCell")
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        addSubview(cv)
        
        cv.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cv.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cv.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cv.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        collectionView = cv
        
        render()
    }
    
    fileprivate func render() {
        let _rows = max(CGFloat(rows), 1.0)
        let _itemSize = max(itemSize, 80.0)
        
        heightConstraint?.constant = _rows * _itemSize + (_rows - 1) * spacing
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: _itemSize, height: _itemSize)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        collectionView?.reloadData()
        
        layoutDelegate?.velezaWidgetNeedsLayoutUpdate()
    }
    
    fileprivate func request(page: Int) {
        if let requestingPage = requestingPages[page], requestingPage {
            return
        }
        
        requestingPages[page] = true
        
        let offset = page * pageSize
        let params = [
            "_t" : apiT,
            "goal" : apiGoal!,
            "model" : apiModel!,
            "scope" : apiScope!,
            "offset" : String(offset),
            "limit" : String(pageSize),
        ]
        VelezaAPIRequest(withMethod: "GET", path: apiPath!, params: params).execute(onSuccess: {
            (models, items, response) in
            
            if let totalString = response["total"] as? String, let total = Int(totalString) {
                self.total = total
            }
            
            models.forEach {
                if let model = $0 as? [String: Any] {
                    if let id = model["id"] as? String {
                        self.models[id] = model
                    }
                }
            }
            
            for i in 0..<items.count {
                if i + offset >= self.posts.count {
                    break
                }
                if let id = items[i] as? String {
                    if let postModel = self.models[id] {
                        if let imageId = postModel["image"] as? String {
                            if let imageModel = self.models[imageId] {
                                self.posts[i + offset] = imageModel
                            }
                        }
                    }
                }
            }
            
            self.render()
        }) { (error) in
            self.requestingPages[page] = false
        }
    }
}

extension VelezaPostGrid: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        request(page: Int(indexPath.item / pageSize))
        
        let item = posts[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VelezaPostGridCell",
                                                      for: indexPath) as! VelezaPostGridCell
        cell.post = item
        return cell
    }
}

extension VelezaPostGrid: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? VelezaPostGridCell, let image = cell.image {
            selectedImageIndex = indexPath.item
            
            var trackData: [String : String] = [
                "index" : String(selectedImageIndex),
                ]
            trackData += self.trackingData
            VelezaSDK.amplitude?.logEvent("Photos - Click thumbnail", withEventProperties: trackData)
            
            let viewController = VelezaPostViewerController(referencedView: cell, image: image)
            viewController.dataSource = self
            viewController.delegate = self
            window?.rootViewController?.present(viewController, animated: true, completion: nil)
        }
    }
}

extension VelezaPostGrid: DTPhotoViewerControllerDataSource {
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
        let indexPath = IndexPath(item: index, section: 0)
        if let cell = self.collectionView?.cellForItem(at: indexPath) {
            return cell
        }
        return nil
    }
    
    func numberOfItems(in photoViewerController: DTPhotoViewerController) -> Int {
        return posts.count
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        if let item = posts[index] as? [String: Any] {
            if let url = item["url"] as? String {
                
                if let cell = collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? VelezaPostGridCell {
                    imageView.image = cell.image
                }
                else {
                    imageView.image = nil
                }
                
                imageView.pin_setImage(from: URL(string: url))
                
                var trackData: [String : String] = [
                    "index" : String(index),
                ]
                trackData += self.trackingData
                VelezaSDK.amplitude?.logEvent("Photos - Open photo", withEventProperties: trackData)
            }
        }
    }
}

extension VelezaPostGrid: DTPhotoViewerControllerDelegate {

    func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: DTPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: selectedImageIndex, animated: false)
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, didScrollToPhotoAt index: Int) {
        selectedImageIndex = index
        if let collectionView = collectionView {
            let indexPath = IndexPath(item: selectedImageIndex, section: 0)
            if !collectionView.indexPathsForVisibleItems.contains(indexPath) {
                collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            }
        }
    }
    
}
