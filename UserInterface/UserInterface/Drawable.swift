//
//  Drawable.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 10/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation

protocol Drawable {
    var isDrawn: Bool { get }
    func makeConstraints()
    func stylizeViews()
    func createViewsHierarchy()
}

extension Drawable {
    func draw() {
        createViewsHierarchy()
        stylizeViews()
        makeConstraints()
    }
    
    func drawIfNeeded() { if !isDrawn { draw() } }
    
    func makeConstraints() { }
    func stylizeViews() { }
    func createViewsHierarchy() { }
}
