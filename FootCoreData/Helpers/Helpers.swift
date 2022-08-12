//
//  Helpers.swift
//  FootCoreData
//
//  Created by Max on 29.07.2022.
//

import UIKit

typealias EmptyBlock = ()->()
typealias ResultBlock = (Bool)->()

class Helpers: NSObject {

}

extension UIViewController {
    class func loadFromStoryboard(name: String) -> Self? {
        let sb = UIStoryboard(name: name, bundle: nil)
        let vc = sb.instantiateViewController(identifier: String(describing: self)) as? Self
        return vc
    }
}

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}
