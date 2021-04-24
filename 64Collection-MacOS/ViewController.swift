//
//  ViewController.swift
//  64Collection-MacOS
//
//  Created by Hanyu Yang on 2021/4/20.
//

import Cocoa
import LeanCloud

class ViewController: NSViewController {

    @IBOutlet weak var brandCollectionView: NSCollectionView!
    @IBOutlet weak var typeTableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try LCApplication.default.set(
                id: "zTlkPQ6jIWwwgRc573R4xRty-9Nh9j0Va",
                key: "qSoQFc0lrd0HIVs3NJ90ax2j",
                serverURL: "https://ztlkpq6j.lc-cn-e1-shared.com")
        } catch {
            print(error)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.updateBrandCollectionView()
    }
    
    func updateBrandCollectionView() {
        self.brandCollectionView.deselectAll(self)
        LeanCloudService.shared.retrieveBrandsList(changeListener: self.brandCollectionView.reloadData)
    }
    
    func updateTypeTableView(selectedBrandId: String) {
        LeanCloudService.shared.retrieveTypesList(brandId: selectedBrandId, changeListener: self.typeTableView.reloadData)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func clearCollectionViewSelectionDisplay() {
        for item in self.brandCollectionView.visibleItems() {
            let collectionItem = item as! BrandCollectionViewItem
            collectionItem.view.layer?.backgroundColor = NSColor.clear.cgColor
        }
    }
    
    @IBAction func refreshButtonOnclick(_ sender: Any) {
        LeanCloudService.shared.clearCache()
        self.typeTableView.reloadData()
        self.clearCollectionViewSelectionDisplay()
        
        self.updateBrandCollectionView()
    }
    
}

extension ViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return LeanCloudService.shared.getBrandsCount()
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let collectionItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("BrandCollectionViewItem"), for: indexPath) as! BrandCollectionViewItem
        
        let brandDto = LeanCloudService.shared.getBrandAtIndex(index: indexPath.item)
        
        ImageUtils.shared.load(imageView: collectionItem.imageView!, from: brandDto.imgUrl)
        collectionItem.brandNameTextField.stringValue = brandDto.name
        collectionItem.brandCountryTextField.stringValue = brandDto.country
        collectionItem.view.wantsLayer = true
        collectionItem.view.layer?.cornerRadius = 3
        collectionItem.view.layer?.borderWidth = 1
        //view.layer.borderColor = borderColor
        //collectionItem.view.layer?.backgroundColor = NSColor.gray.cgColor
        
        return collectionItem
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        self.clearCollectionViewSelectionDisplay()
        let selectedItem = self.brandCollectionView.item(at: indexPaths.first!) as! BrandCollectionViewItem
        selectedItem.view.layer?.backgroundColor = NSColor.gray.cgColor
        self.updateTypeTableView(selectedBrandId: LeanCloudService.shared.getBrandAtIndex(index: indexPaths.first!.item).brandId)
    }
    
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        // print(LeanCloudService.shared.getTypesCount())
        return LeanCloudService.shared.getTypesCount()
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let typeDto = LeanCloudService.shared.getTypeAtIndex(index: row)
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "nameColumn") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "nameCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = typeDto.name
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "makeColumn") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "makeCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = String(typeDto.make)
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "categoryColumn") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "categoryCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = typeDto.category
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "diecastBrandColumn") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "diecastBrandCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = typeDto.diecastBrand
            return cellView
        }
        return nil
    }
}



