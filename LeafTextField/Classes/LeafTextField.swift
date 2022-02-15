//
//  LeafTextFied.swift
//  LeafTextField
//
//  Created by hoseung Lee on 2022/02/08.
//

import UIKit

@IBDesignable
open class LeafTextField: UITextField {

  private struct AnimationState {
    enum State {
      case inactive
      case active
    }

    var state: State = .inactive
    var withAnimate: Bool = true

    mutating func runActive(withAnimate: Bool = true) {
      state = .active
      self.withAnimate = withAnimate
    }

    mutating func stopActive(withAnimate: Bool = true) {
      state = .inactive
      self.withAnimate = withAnimate
    }
  }

  private var animationState = AnimationState() {
    didSet {
      switch animationState.state {
        case .inactive:
          inactiveAnimation(withAnimation: animationState.withAnimate)
        case .active:
          activeAnimation(withAnimation: animationState.withAnimate)
      }
    }
  }

  @IBInspectable

  /// ImageOffset
  ///   <-- - {image}  + -->
  public var animateImageOffset: CGFloat = 0 {
    didSet {
      imageViewTrailingConstraint.constant = -animateImageOffset
    }
  }

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private var imageViewCenterConstraint: NSLayoutConstraint!
  private var imageViewWidthConstraint: NSLayoutConstraint!
  private var imageViewHeightConstraint: NSLayoutConstraint!
  private var imageViewTrailingConstraint: NSLayoutConstraint!

  @IBInspectable
  public var inactiveImage: UIImage?

  @IBInspectable
  public var activeImage: UIImage?


  @IBInspectable
  /// Animation Speed
  ///  Default is Double 0.7
  public var animationSpeed: Double = 0.7

  @IBInspectable

  /// SpringAnimation
  /// Default is true
  public var springAnimation: Bool = true

  @IBInspectable
  public var imageSize: CGFloat = 24 {
    didSet {
      imageViewWidthConstraint.constant = imageSize
      imageViewHeightConstraint.constant = imageSize
    }
  }

  private var viewWidth: CGFloat = 0

  public override init(frame: CGRect) {
    super.init(frame: frame)
    createView()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    createView()
  }

  /// Set Image
  /// - Parameters:
  ///   - inactiveImage: UIImage Inactive Image
  ///   - activeImage: UIImage Active Image
  public func setImage(_ inactiveImage: UIImage?, _ activeImage: UIImage?) {
    self.inactiveImage = inactiveImage != nil ? inactiveImage : UIImage(systemName: "star")
    self.activeImage = activeImage != nil ? activeImage : UIImage(systemName: "star.fill")
    updateImage()
  }

  private func updateImage() {
    if (text ?? "").isEmpty && imageViewCenterConstraint.isActive == true {
      imageView.image = inactiveImage
    } else {
      imageView.image = activeImage
    }
    setNeedsDisplay()
  }

  open override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    createView()
  }

  open override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)
    addTarget(self, action: #selector(didBeginEditing(_:)), for: .editingDidBegin)
    addTarget(self, action: #selector(didEndEditing(_:)), for: .editingDidEnd)
  }

  private func createView() {
    addSubview(imageView)
    imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    imageViewWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: imageSize)
    imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: imageSize)
    imageViewCenterConstraint = imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
    imageViewTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -animateImageOffset)
    imageViewCenterConstraint.isActive = true
    imageViewWidthConstraint.isActive = true
    imageViewHeightConstraint.isActive = true
    imageView.image = inactiveImage
    viewWidth = bounds.width
  }

  open override var text: String? {
    didSet {
      updateAfterDraw()
    }
  }

  private func updateAfterDraw() {
    if let text = text,
       (!text.isEmpty || isFirstResponder),
       animationState.state == .inactive {
      animationState.runActive(withAnimate: false)
    } else if animationState.state == .active{
      animationState.stopActive(withAnimate: false)
    }
  }

  open override func textRect(forBounds bounds: CGRect) -> CGRect {
    var bounds = bounds
    bounds.size.width -= (imageSize + animateImageOffset + 6)
    return bounds
  }

  open override func editingRect(forBounds bounds: CGRect) -> CGRect {
    var bounds = bounds
    bounds.size.width -= (imageSize + animateImageOffset + 6)
    return bounds
  }

  @objc private func didBeginEditing(_ sender: UITextField) {
    animationState.runActive()
  }

  @objc private func didEndEditing(_ sneder: UITextField) {
    animationState.stopActive()
  }

  private func activeAnimation(withAnimation: Bool = true) {
    guard imageViewCenterConstraint.isActive == true else { return }

    imageViewCenterConstraint.isActive = false
    imageViewTrailingConstraint.isActive = true
    if withAnimation {
      UIView.animate(
        withDuration: animationSpeed,
        delay: 0,
        usingSpringWithDamping: springAnimation ? 0.7 : 1,
        initialSpringVelocity: springAnimation ? 0.8 : 1,
        options: .transitionCurlUp) { [unowned self] in
        self.layoutIfNeeded()
      } completion: { [unowned self] _ in
        UIView.transition(
          with: imageView,
          duration: 0.2,
          options: .transitionCrossDissolve) {
          updateImage()
        }
      }
    } else {
      updateImage()
      layoutIfNeeded()
    }
  }

  private func inactiveAnimation(withAnimation: Bool = true) {
    guard (text ?? "").isEmpty else { return }
    imageViewTrailingConstraint.isActive = false
    imageViewCenterConstraint.isActive = true
    if withAnimation {
      UIView.animate(
        withDuration: animationSpeed,
        delay: 0,
        usingSpringWithDamping: springAnimation ? 0.7 : 1,
        initialSpringVelocity: springAnimation ? 0.8 : 1,
        options: .transitionCurlUp) { [unowned self] in
        layoutIfNeeded()
      } completion: { [unowned self] _ in
        UIView.transition(
          with: imageView,
          duration: 0.1,
          options: .transitionCrossDissolve) {
          updateImage()
        }
      }
    } else {
      layoutIfNeeded()
      updateImage()
    }
  }
}


