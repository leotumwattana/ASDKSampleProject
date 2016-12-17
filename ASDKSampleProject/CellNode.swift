//
//  CellNode.swift
//  ASDKSampleProject
//
//  Created by Leo Tumwattana on 17/12/2016.
//  Copyright © 2016 Stay Sorted Inc. All rights reserved.
//

import UIKit
import AsyncDisplayKit

private enum Params {
    
    static let titleAttributes:[String: Any] = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15),
            NSForegroundColorAttributeName: UIColor.white
        ]
    
    static let subtitleAttributes:[String: Any] = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 13),
        NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.65)
    ]
    
}

final class CellNode: ASCellNode {
    
    
    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .orange
            } else {
                backgroundColor = .purple
            }
            transitionLayout(withAnimation: true, shouldMeasureAsync: true, measurementCompletion: nil)
        }
    }

    
    var title:String? {
        didSet {
            
            guard let title = title else {
                titleNode.attributedText = nil
                setNeedsLayout()
                return
            }
            
            guard title != oldValue else { return }
            
            let text = NSAttributedString(
                string: title,
                attributes: Params.titleAttributes)
            
            titleNode.attributedText = text
            setNeedsLayout()
            
        }
    }
    
    var subtitle:String? {
        didSet {
            
            guard let subtitle = subtitle else {
                subtitleNode.attributedText = nil
                setNeedsLayout()
                return
            }
            
            guard subtitle != oldValue else { return }
            
            let text = NSAttributedString(
                string: subtitle,
                attributes: Params.subtitleAttributes)
            
            subtitleNode.attributedText = text
            setNeedsLayout()
        }
    }
    
    var subtitle2:String? {
        didSet {
            
            guard let subtitle2 = subtitle2 else {
                subtitle2Node.attributedText = nil
                return
            }
            
            guard subtitle2 != oldValue else { return }
            
            let text = NSAttributedString(
                string: subtitle2,
                attributes: Params.subtitleAttributes)
            
            subtitle2Node.attributedText = text
            setNeedsLayout()
        }
    }
    
    // MARK: - TextKit
    private lazy var textStorage:NSTextStorage = {
        return NSTextStorage()
    }()
    
    private lazy var components:ASTextKitComponents = {
        
        let layoutManager = NSLayoutManager()
        
        return ASTextKitComponents(
            textStorage: self.textStorage,
            textContainerSize: CGSize.zero,
            layoutManager: layoutManager)
        
    }()
    
    private lazy var placeholderComponents:ASTextKitComponents = {
        
        let layoutManager = NSLayoutManager()
        
        let comp = ASTextKitComponents(
            textStorage: self.textStorage,
            textContainerSize: CGSize.zero,
            layoutManager: layoutManager)
        
        return comp
        
    }()
    
    // MARK: Subnodes
    lazy var titleNode:ASEditableTextNode = {
        
        let node = ASEditableTextNode(
            textKitComponents: self.components,
            placeholderTextKitComponents: self.placeholderComponents)
        
        node.maximumLinesToDisplay = 6
        node.clipsToBounds = true
        node.backgroundColor = .red
        
        return node
        
    }()
    
    private lazy var subtitleNode:ASTextNode = {
        
        let node = ASTextNode()
        node.backgroundColor = .green
        return node
        
    }()
    
    private lazy var subtitle2Node:ASTextNode = {
        
        let node = ASTextNode()
        node.backgroundColor = .blue
        return node
        
    }()
    
    private lazy var imageNode:ASImageNode = {
        
        let node = ASImageNode()
        node.contentMode = .scaleAspectFit
        node.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        return node
        
    }()
    
    private lazy var buttonNode:ASButtonNode = {
        
        let node = ASButtonNode()
        
        let title = NSAttributedString(
            string: "This is a button",
            attributes: Params.subtitleAttributes)
        
        node.setAttributedTitle(title, for: ASControlState())
        node.backgroundColor = .cyan
        
        return node
        
    }()
    
    // MARK: - Init
    override init() {
        super.init()
        neverShowPlaceholders = true
        automaticallyManagesSubnodes = true
    }
    
    // MARK: - Lifecycle
    override func didLoad() {
        super.didLoad()
        titleNode.textView.isScrollEnabled = false
    }
    
    // MARK: - Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        imageNode.style.width = ASDimensionMake(53)
        imageNode.style.height = ASDimensionMake(50)
        
        titleNode.style.width = ASDimensionMake(UIScreen.main.bounds.width)
        
        let subtitlesStack = ASStackLayoutSpec.vertical()
        subtitlesStack.spacing = 4
        subtitlesStack.children = []
        
        let subtitleAndButtonStack = ASStackLayoutSpec.horizontal()
        subtitleAndButtonStack.direction = .horizontal
        subtitleAndButtonStack.spacing = 4
        subtitleAndButtonStack.justifyContent = .start
        subtitleAndButtonStack.alignItems = .center
        subtitleAndButtonStack.children = [subtitlesStack]
        
        if let subtitle = subtitle, !subtitle.isEmpty {
            subtitleNode.style.flexShrink = 1
            subtitlesStack.children?.append(subtitleNode)
        }
        
        if isSelected {
            subtitle2Node.style.alignSelf = .start
            subtitle2Node.style.maxWidth = ASDimensionMake(UIScreen.main.bounds.width / 2)
            subtitle2Node.style.flexShrink = 1
            subtitlesStack.children?.append(subtitle2Node)
        }
        
        let spacer = ASLayoutSpec()
        spacer.style.flexBasis = ASDimensionMake(1)
        spacer.style.flexGrow = 1
        spacer.style.flexShrink = 1
        
        subtitleAndButtonStack.children?.append(spacer)
        subtitleAndButtonStack.children?.append(buttonNode)
        
        let titleSubtitleStack = ASStackLayoutSpec.vertical()
        titleSubtitleStack.spacing = 8
        titleSubtitleStack.children = [titleNode, subtitleAndButtonStack]
        
        let horizontal = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .start,
            alignItems: .center,
            children: [imageNode, titleSubtitleStack])
        
        let content = ASInsetLayoutSpec(
            insets: UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8),
            child: horizontal)
        
        return content
        
    }
    
    // MARK: - Transition
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        
        let finalFrame = context.finalFrame(for: subtitle2Node)
        
        self.subtitle2Node.view.frame = finalFrame.offsetBy(dx: -finalFrame.size.width, dy: 0)
        self.subtitle2Node.view.alpha = 0
        
        let initRepeatFrame = context.initialFrame(for: buttonNode)
        let finalRepeatFrame = context.finalFrame(for: buttonNode)
        
        //buttonNode.view.frame = initRepeatFrame
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                //self.buttonNode.view.frame = finalRepeatFrame
                self.subtitle2Node.view.frame = finalFrame
                self.subtitle2Node.view.alpha = 1
            },
            completion: { finished in
                context.completeTransition(true)
        })
        
    }

    // MARK: - Configure
    func configure(title:String?, subtitle:String?, subtitle2:String?) {
        self.title = title
        self.subtitle = subtitle
        self.subtitle2 = subtitle2
    }
    
}
