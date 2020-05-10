//
//  UIFont+boldSystemFont.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 10/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit

extension UIFont {
    func boldSystemFont() -> UIFont {
        return .boldSystemFont(ofSize: fontDescriptor.pointSize)
    }
}
