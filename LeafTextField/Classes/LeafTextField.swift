//
//  LeafTextFied.swift
//  LeafTextField
//
//  Created by hoseung Lee on 2022/02/08.
//

import UIKit

@IBDesignable
open class LeafTextField: UITextField {

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private var imageViewCenterConstraint: NSLayoutConstraint!
  private var imageViewWidthConstraint: NSLayoutConstraint!
  private var imageViewHeightConstraint: NSLayoutConstraint!

  @IBInspectable
  public var inactiveImage: UIImage? = UIImage(systemName: "star")

  @IBInspectable
  public var activeImage: UIImage? = UIImage(systemName: "star.fill")


  @IBInspectable
  /// Animation Speed
  ///  Default is Double 0.7
  public var animationSpeed: Double = 0.7

  @IBInspectable

  /// SpringAnimation
  /// Default is true
  public var springAnimation: Bool = true

  private var trailingInset: CGFloat = 8
  private var viewWidth: CGFloat = 0

  public var imageSize: CGFloat = 24 {
    didSet {
      imageViewWidthConstraint.constant = imageSize
      imageViewHeightConstraint.constant = imageSize
    }
  }

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
    if (text ?? "").isEmpty && imageViewCenterConstraint.constant == 0 {
      imageView.image = inactiveImage
    } else {
      imageView.image = activeImage
    }
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
    imageViewCenterConstraint.isActive = true
    imageViewWidthConstraint.isActive = true
    imageViewHeightConstraint.isActive = true
    imageView.image = inactiveImage
  }

  open override func draw(_ rect: CGRect) {
    super.draw(rect)
    viewWidth = rect.width
  }

  open override func textRect(forBounds bounds: CGRect) -> CGRect {
    var bounds = bounds
    bounds.size.width -= (imageSize * 2)
    return bounds
  }

  open override func editingRect(forBounds bounds: CGRect) -> CGRect {
    var bounds = bounds
    bounds.size.width -= (imageSize * 2)
    return bounds
  }

  @objc private func didBeginEditing(_ sender: UITextField) {
    guard imageViewCenterConstraint.constant == 0 else { return }
    imageViewCenterConstraint.constant = (viewWidth / 2) - (imageSize + trailingInset)
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
  }

  @objc private func didEndEditing(_ sneder: UITextField) {
    guard (text ?? "").isEmpty else { return }
    imageViewCenterConstraint.constant = 0
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
  }
}


