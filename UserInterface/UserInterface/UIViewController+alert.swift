//
//  UIViewController+alert.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(_ error: Error) {
        let ok = UIAlertAction(title: "Ok", style: .default)
        let alert = UIAlertController(title: "An error has occurred...", message: "\(error)", preferredStyle: .alert)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func alert(title: String? = nil, message: String? = nil) {
        let ok = UIAlertAction(title: "Ok", style: .default)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func alert(_ error: Error, retry: @escaping () -> Void) {
        let ok = UIAlertAction(title: "Ok", style: .default)
        let retry = UIAlertAction(title: "Retry", style: .default) { _ in retry() }
        let alert = UIAlertController(title: "An error has occurred...", message: "\(error)", preferredStyle: .alert)
        alert.addAction(ok)
        alert.addAction(retry)
        present(alert, animated: true, completion: nil)
    }
    
    func alert(title: String? = nil, message: String? = nil, no: @escaping () -> Void, yes: @escaping () -> Void) {
        let no = UIAlertAction(title: "No", style: .default) { _ in no() }
        let yes = UIAlertAction(title: "Yes", style: .default) { _ in yes() }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(no)
        alert.addAction(yes)
        present(alert, animated: true, completion: nil)
    }
}
