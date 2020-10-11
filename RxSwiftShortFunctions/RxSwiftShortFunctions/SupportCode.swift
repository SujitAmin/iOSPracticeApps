//
//  SupportCode.swift
//  RxSwiftShortFunctions
//
//  Created by SujitAmin on 11/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

public func exampleOf(description: String, action  : () -> Void) {
    print("\n--- Example of: ", description, "----")
    action()
}
