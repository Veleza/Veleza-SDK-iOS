//
//  VelezaPostGridCell.swift
//  Veleza
//
//  Created by Vytautas Povilaitis on 13/11/2018.
//  Copyright © 2018 Veleza. All rights reserved.
//

import UIKit
import PINRemoteImage

class VelezaPostGridCell: UICollectionViewCell {
    
    fileprivate var imageView = UIImageView()
    
    var post: Any? {
        didSet {
            if let _post = post as? [String: Any] {
                setImage(url: _post["url"] as? String)
            }
        }
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    fileprivate func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.white
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = VelezaSDK.roundedCornerSize
        imageView.backgroundColor = VelezaSDK.colorSeparator
        addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func setImage(url: String?) {
        imageView.image = nil
        
        if url == nil {
            return
        }
        
        let sw = UIScreen.main.bounds.size.width
        let scale = UIScreen.main.scale
        
        var width = CGFloat(round(UIScreen.main.bounds.size.width / 3))
        
        let grid = sw / 8.0
        var gw = min(ceil(width / grid) * grid, sw)
        
        width *= scale
        gw *= scale
        
        var path = url!
        if (path.hasPrefix("http:")) {
            path = String(path[path.index(path.startIndex, offsetBy: 7)...])
        }
        if (path.hasPrefix("https:")) {
            path = String(path[path.index(path.startIndex, offsetBy: 8)...])
        }
        
        path = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) ?? ""
        
        imageView.pin_updateWithProgress = true
        
        let urls: [URL] = [
            URL(string: String(format: "https://images.weserv.nl/?url=%@&w=%d&sharp=0,0.7&q=75&output=jpg&il&bg=white", path, Int(width)))!,
            URL(string: String(format: "https://images.weserv.nl/?url=%@&w=%d&sharp=0,0.7&q=85&output=jpg&il&bg=white", path, Int(width)))!,
            URL(string: String(format: "https://images.weserv.nl/?url=%@&w=%d&sharp=0,0.7&q=95&output=jpg&il&bg=white", path, Int(width)))!
        ];
        
        imageView.pin_setImage(from: urls)
    }
    
}
