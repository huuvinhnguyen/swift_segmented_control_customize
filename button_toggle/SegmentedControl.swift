//
//  SegmentedControl.swift
//  button_toggle
//
//  Created by chuyendo on 9/5/21.
//

import Foundation
import UIKit

@IBDesignable
public class SegmentedControl: UIControl {
    
    static let bottomLineThumbViewHeight: CGFloat = 8.0
    static let bottomLineSpacing: CGFloat = 20
    
    @IBInspectable public var animationDuration: CGFloat = 0.3
    
    public var titlesFont: UIFont? {
        didSet {
            updateView()
        }
    }
    
    public var selectedSegmentIndex = 0
    {
        didSet {
            self.setSelectedIndex(to: selectedSegmentIndex)
        }
    }
    
    public var roundedControl: Bool = true {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 8.0 {
        didSet {
            updateView()
        }
    }
    
    
    
    @IBInspectable public var selectedColor: UIColor = .red {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable public var unselectedColor: UIColor = .lightGray {
        didSet {
            updateView()
        }
    }
    
    
    @IBInspectable internal var buttonTitles: [String] = [] {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable public var padding: CGFloat =  0 {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable public var spacing: CGFloat =  10 {
        didSet {
            self.updateView()
        }
    }
    
    public var isBottomLineShown: Bool = true {
        didSet {
            self.updateView()
        }
    }
    
    internal var buttons = [UIButton]()
    
    internal var thumbView: UIView = {
        return UIView()
    }()
    
    private func resetViews() {
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func updateView() {
        
        resetViews()
        self.clipsToBounds = false
        addSubview(thumbView)
        
        setButtonsWithText()
        layoutButtonsOnStackView()
    }
    
    public func setSegmentedWith<T>(items: T) {
        if let collection = items as? [String] {
            self.buttonTitles = collection
        }
    }
    
    private func layoutButtonsOnStackView() {
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.spacing = spacing
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillEqually
        addSubview(sv)
        
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: topAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SegmentedControl.bottomLineSpacing),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    private func setButtonsWithText() {
        
        guard !self.buttonTitles.isEmpty else { return }
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = titlesFont
            button.setTitleColor(unselectedColor, for: .normal)
            button.layer.borderColor = unselectedColor.cgColor
            button.layer.borderWidth = borderWidth
            button.layer.cornerRadius = roundedControl ? (frame.height - SegmentedControl.bottomLineSpacing) / 2 : 1.0
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
            //set the one that we want to show as selected by default
        }
        buttons[selectedSegmentIndex].setTitleColor(selectedColor, for: .normal)
        buttons[selectedSegmentIndex].layer.borderColor = selectedColor.cgColor
    }
    
    override public func layoutSubviews() {
          super.layoutSubviews()
          setThumbView()

      }
    
    private func setThumbView() {

          let lineViewHeight = isBottomLineShown ? SegmentedControl.bottomLineThumbViewHeight : bounds.height - padding * 2
          let thumbViewWidth =  (bounds.width / CGFloat(buttons.count)) - padding * 2 - spacing / 2
          let thumbViewPositionX = padding
          let thumbViewPositionY = isBottomLineShown ? bounds.height - lineViewHeight - padding : (bounds.height - lineViewHeight) / 2
          
          thumbView.frame = CGRect(x: thumbViewPositionX, y: thumbViewPositionY, width: thumbViewWidth, height: lineViewHeight)
          thumbView.layer.cornerRadius = roundedControl ? lineViewHeight / 2 : 1.0
        thumbView.backgroundColor = selectedColor
      }
    
    private func setFrameForButtonAt(index: Int) -> CGRect {
           
           var frame = CGRect.zero
           
           let buttonHeight = (bounds.height - padding * 2)
           let buttonWidth = buttonHeight
           let thumbViewPositionY = (bounds.height - buttonHeight) / 2

           let firstElementPositionX = self.padding
           let lastElemetPositionX = bounds.width - thumbView.frame.width - padding

           let thumbViewAreaTotalWidth = bounds.width / CGFloat(buttons.count)
           let startingPointAtIndex = thumbViewAreaTotalWidth *  CGFloat(index)

           let originXForNextItem = (thumbViewAreaTotalWidth - thumbView.bounds.width) / 2
           
           let selectedStartPositionForNotEquallyFill = startingPointAtIndex + originXForNextItem
           
           if index == 0 {
               frame = CGRect(x: firstElementPositionX, y: thumbViewPositionY, width: buttonWidth, height: buttonHeight)
           } else if index == self.buttons.count - 1 {
               frame = CGRect(x: lastElemetPositionX, y: thumbViewPositionY, width: buttonWidth, height: buttonHeight)
           } else {
               frame = CGRect(x: selectedStartPositionForNotEquallyFill, y: thumbViewPositionY, width: buttonWidth, height: buttonHeight)
           }
           return frame
       }
}

import Foundation
import UIKit

extension SegmentedControl {

    internal func performAction() {
        sendActions(for: .valueChanged)
    }
    

    @objc internal func buttonTapped(button: UIButton) {
        
        for (btnIndex, btn) in self.buttons.enumerated() {
            if btn == button {
                selectedSegmentIndex = btnIndex
            }
        }
        self.performAction()
    }
    
    @objc internal func setSelectedIndex(to index: Int) {
        let selectedBtn = self.buttons[index]
        
        for (btnIndex, btn) in self.buttons.enumerated() {
            
                        btn.setTitleColor(unselectedColor, for: .normal)
            btn.layer.borderColor = unselectedColor.cgColor

                        if btn == selectedBtn {
                            moveThumbView(at: btnIndex)
                            btn.setTitleColor(selectedColor, for: .normal)
                            btn.layer.borderColor = selectedColor.cgColor

                        }
        }
    }
    
    private func moveThumbView(at index: Int) {
        
        let selectedStartPosition = index == 0 ? self.padding : bounds.width / CGFloat(buttons.count) *  CGFloat(index) + self.padding + spacing / 2
        UIView.animate(withDuration: TimeInterval(self.animationDuration), animations: {
            self.thumbView.frame.origin.x = selectedStartPosition
        })
    }
}
