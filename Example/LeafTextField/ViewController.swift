//
//  ViewController.swift
//  LeafTextField
//
//  Created by 46310414 on 02/09/2022.
//  Copyright (c) 2022 46310414. All rights reserved.
//

import UIKit
import LeafTextField

class ViewController: UIViewController {

  @IBOutlet weak var textField: LeafTextField!

  override func viewDidLoad() {
        super.viewDidLoad()
    textField.delegate = self
    textField.setImage(UIImage(named: "pikases"), UIImage(named: "pikases-leaf"))
    textField.imageSize = 24
    textField.animationSpeed = 0.5
    textField.springAnimation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

