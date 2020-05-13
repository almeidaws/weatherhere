//
//  String+localized.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 13/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "Without comments")
    }
}
