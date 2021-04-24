//
//  BrandDto.swift
//  64Collection-MacOS
//
//  Created by Hanyu Yang on 2021/4/20.
//

import Foundation

class BrandDto {
    
    var brandId: String
    var name: String
    var imgUrl: String
    var country: String
    
    public init (id: String, name: String, imgUrl: String, country: String) {
        self.brandId = id
        self.name = name
        self.imgUrl = imgUrl
        self.country = country
    }
}
