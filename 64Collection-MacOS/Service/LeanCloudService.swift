//
//  LeanCloudService.swift
//  64Collection-MacOS
//
//  Created by Hanyu Yang on 2021/4/20.
//

import Foundation
import LeanCloud

class LeanCloudService {
    
    var brandList: [BrandDto]?
    var typeList: [TypeDto]?
    
    static let shared = LeanCloudService()
    
    private init () {}
    
    func retrieveBrandsList(changeListener: (() -> Void)?) {
        self.brandList = [BrandDto]()
        let query = LCQuery(className: kClassBrand)
        query.whereKey(kKeyBrandName, .ascending)
        query.find { result in
            //self._objects = result.objects
            for obj in result.objects! {
                let brandName = obj.get(kKeyBrandName)?.stringValue ?? ""
                let brandCountry = obj.get(kKeyBrandCountry)?.stringValue ?? ""
                let brandImgUrl = obj.get(kKeyBrandImgUrl)?.stringValue ?? ""
                let brandId = obj.get(kKeyObjectId)?.stringValue ?? ""
                self.brandList?.append(BrandDto(id: brandId,
                                           name: brandName,
                                           imgUrl: brandImgUrl,
                                           country: brandCountry))
            }
            changeListener?()
        }
    }
    
    func retrieveTypesList(brandId: String, changeListener: (() -> Void)?) {
        self.typeList = [TypeDto]()
        let query = LCQuery(className: kClassType)
        query.whereKey(kKeyTypeBrandId, .equalTo(brandId))
        query.find { result in
            if result.objects == nil {
                changeListener?()
                return
            }
            for obj in result.objects! {
                let objectId = obj.get(kKeyObjectId)?.stringValue ?? ""
                let typeName = obj.get(kKeyTypeName)?.stringValue ?? ""
                let typeMake = obj.get(kKeyTypeMake)?.intValue ?? 0
                let typeDiecastBrand = obj.get(kKeyTypeDiecastBrand)?.stringValue ?? ""
                let typeCategory = obj.get(kKeyTypeCategory)?.stringValue ?? ""
                let typeImgUrls = (obj.get(kKeyTypePhotoUrls)?.arrayValue ?? []) as! [String]
                self.typeList?.append(TypeDto(objectId: objectId, name: typeName, make: typeMake, diecastBrand: typeDiecastBrand, category: typeCategory, imgUrls: typeImgUrls))
            }
            changeListener?()
        }
    }
    
    func getBrandsCount() -> Int {
        return self.brandList?.count ?? 0
    }
    
    func getBrandAtIndex(index: Int) -> BrandDto {
        return (self.brandList?[index])!
    }
    
    func getTypesCount() -> Int {
        return self.typeList?.count ?? 0
    }
    
    func getTypeAtIndex(index: Int) -> TypeDto {
        return (self.typeList?[index])!
    }
    
    func clearCache() {
        self.brandList = []
        self.typeList = []
    }
}
