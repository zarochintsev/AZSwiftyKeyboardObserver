//
// AZSwiftyKeyboardObserverImpl.swift
// AZSwiftyKeyboardObserver
//
// MIT License
//
// Copyright (c) 2018-2019 Alex Zarochintsev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

public class AZSwiftyKeyboardObserverImpl {
  public var beginFrame: CGRect = .zero
  public var endFrame: CGRect = .zero
  public var animationDuration: TimeInterval = 0.0
  public var animationOptions: UIViewAnimationOptions = []
  public var observe: AZSwiftyKeyboardObserver.KeyboardEventHandler?
  
  // MARK: - Lifecycle
  public init() {}
  
  deinit {
    removedObservers()
  }
  
  // MARK: - Actions
  @objc private func keyboardWillShow(notification: Notification) {
    updateProperties(with: notification)
    observe?(self, .willShow)
  }
  
  @objc private func keyboardDidShow(notification: Notification) {
    updateProperties(with: notification)
    observe?(self, .didShow)
  }
  
  @objc private func keyboardWillHide(notification: Notification) {
    updateProperties(with: notification)
    observe?(self, .willHide)
  }
  
  @objc private func keyboardDidHide(notification: Notification) {
    updateProperties(with: notification)
    observe?(self, .didHide)
  }
  
  @objc private func keyboardWillChangeFrame(notification: Notification) {
    updateProperties(with: notification)
    observe?(self, .willChangeFrame)
  }
  
  @objc private func keyboardDidChangeFrame(notification: Notification) {
    updateProperties(with: notification)
    observe?(self, .didChangeFrame)
  }
}

// MARK: AZSwiftyKeyboardObserver
extension AZSwiftyKeyboardObserverImpl: AZSwiftyKeyboardObserver {
  public func registerObservers() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(
      self, selector: #selector(keyboardWillShow),
      name: .UIKeyboardWillShow, object: nil)
    notificationCenter.addObserver(
      self, selector: #selector(keyboardDidShow),
      name: .UIKeyboardDidShow, object: nil)
    notificationCenter.addObserver(
      self, selector: #selector(keyboardWillHide),
      name: .UIKeyboardWillHide, object: nil)
    notificationCenter.addObserver(
      self, selector: #selector(keyboardDidHide),
      name: .UIKeyboardDidHide, object: nil)
    notificationCenter.addObserver(
      self, selector: #selector(keyboardWillChangeFrame),
      name: .UIKeyboardWillChangeFrame, object: nil)
    notificationCenter.addObserver(
      self, selector: #selector(keyboardDidChangeFrame),
      name: .UIKeyboardDidChangeFrame, object: nil)
  }
  
  public func removedObservers() {
    NotificationCenter.default.removeObserver(self)
  }
}

// MARK: - Private Extension
private extension AZSwiftyKeyboardObserverImpl {
  func updateProperties(with notification: Notification) {
    guard
      let userInfo = notification.userInfo,
      let beginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
      let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
      let curveRawValue = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
      let animationCurve = UIViewAnimationCurve(rawValue: curveRawValue),
      let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
      else { return }
    
    self.beginFrame = beginFrame
    self.endFrame = endFrame
    self.animationDuration = animationDuration
    self.animationOptions = UIViewAnimationOptions(rawValue: UInt(animationCurve.rawValue << 16))
  }
}
