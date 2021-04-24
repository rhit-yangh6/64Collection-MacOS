//
//  ImageUtils.swift
//  64Collection-MacOS
//
//  Created by Hanyu Yang on 2021/4/20.
//

import Foundation
import Kingfisher

class ImageUtils {
    static let shared = ImageUtils()
    
    private init() {}
    
    func load(imageView: NSImageView, from url: String) {
        if let imgUrl = URL(string: url) {
            imageView.kf.setImage(with: imgUrl)
        }
    }
}
