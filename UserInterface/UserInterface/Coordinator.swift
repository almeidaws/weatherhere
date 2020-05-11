//
//  Coordinator.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 10/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit
import Services

class Coordinator<Interactions>: Service where Interactions: RawRepresentable {
    func present(_ destination: Interactions, from origin: UIViewController) {
        fatalError("Must be overrided.")
    }
    func dismiss() {
        fatalError("Must be overrided.")
    }
}
