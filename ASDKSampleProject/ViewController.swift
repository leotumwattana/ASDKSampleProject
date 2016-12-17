//
//  ViewController.swift
//  ASDKSampleProject
//
//  Created by Leo Tumwattana on 17/12/2016.
//  Copyright © 2016 Stay Sorted Inc. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ViewController: ASViewController<ASDisplayNode> {
    
    // MARK: - Properties
    lazy var itemTitles:[String] = {
        return [
            "Item A", "Item B", "Item C",
            "Item D", "Item E", "Item F",
            "Item G", "Item H", "Item I",
            "Item J", "Item K", "Item L",
            ]
    }()
    
    // MARK: - Subnodes
    lazy var collectionNode:ASCollectionNode = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
        let node = ASCollectionNode(collectionViewLayout: layout)
        node.backgroundColor = .clear
        node.dataSource = self
        node.delegate = self
        node.view.alwaysBounceVertical = true
        node.view.alwaysBounceHorizontal = false
        node.view.contentInset.top = 20
        node.allowsSelection = true
        node.allowsMultipleSelection = true
        node.allowsEdgeAntialiasing = true
        
        let params = ASRangeTuningParameters(leadingBufferScreenfuls: 3, trailingBufferScreenfuls: 2)
        node.setTuningParameters(params, for: .full, rangeType: .display)
        
        return node
        
    }()

    // MARK: - Init
    required init?(coder aDecoder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(node: ASDisplayNode())
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubnode(collectionNode)
    }
    
    // MARK: - Layout
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionNode.frame = view.bounds
    }

}

extension ViewController: ASCollectionDataSource {
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return itemTitles.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        let title = itemTitles[indexPath.row]
        let subtitle:String? = "Subtitle"
        
        let count = CGFloat(self.collectionNode(collectionNode, numberOfItemsInSection: 0))
        let percent = CGFloat(indexPath.row) / count
        
        let hue = 0.819 - (0.819 - 0.617) * percent
        let color = UIColor(hue: hue, saturation: 0.814, brightness: 0.507, alpha: 1)
        
        return {
            
            let cell = CellNode()
            cell.configure(title: title, subtitle: subtitle, subtitle2: "This is the second subtitle. Which can possibly be long and multilined.\nLike this second line.")
            cell.backgroundColor = color
            
            return cell
            
        }
        
    }
    
}

extension ViewController: ASCollectionViewDelegateFlowLayout {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        
        let width = UIScreen.main.bounds.size.width
        let cellHeight:CGFloat = 58
        let min = CGSize(width: width, height: cellHeight)
        let max = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        return ASSizeRange(min: min, max: max)
        
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        print("Selected: \(indexPath)")
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didDeselectItemAt indexPath: IndexPath) {
        print("Deselected: \(indexPath)")
    }
    
}

// MARK: - Misc
extension ViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
