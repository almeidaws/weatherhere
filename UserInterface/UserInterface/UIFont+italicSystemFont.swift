//
//  UIFont+italic.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 10/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit

extension UIFont {
    func italicSystemFont() -> UIFont {
        return .italicSystemFont(ofSize: fontDescriptor.pointSize)
    }
}
