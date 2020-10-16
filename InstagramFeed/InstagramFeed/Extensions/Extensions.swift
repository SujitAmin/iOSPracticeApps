//
//  Extensions.swift
//  InstagramFeed
//
//  Created by SujitAmin on 16/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import MBProgressHUD

extension UIViewController {
   public func showIndicator(withTitle title: String, and Description:String) {
      let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
      Indicator.label.text = title
      Indicator.isUserInteractionEnabled = false
      Indicator.detailsLabel.text = Description
      Indicator.show(animated: true)
   }
   public func hideIndicator() {
      MBProgressHUD.hide(for: self.view, animated: true)
   }
}
