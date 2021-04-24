//
//  TypeDto.swift
//  64Collection-MacOS
//
//  Created by Hanyu Yang on 2021/4/21.
//

import Foundation

class TypeDto {
    var name: String
    var imgUrls: [String]
    var category: String
    var objectId: String
    var diecastBrand: String
    var make: Int
    
    public init (objectId: String, name: String, make: Int, diecastBrand: String, category: String, imgUrls: [String]) {
        self.objectId = objectId
        self.name = name
        self.make = make
        self.diecastBrand = diecastBrand
        self.category = category
        self.imgUrls = imgUrls
    }
}
