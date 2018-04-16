//
//  Thing.swift
//  RetainCycleTests
//
//  Created by Eric Parker on 3/29/18.
//  Copyright © 2018 Eric Parker. All rights reserved.
//

import UIKit

protocol Thingable: class {

}

class SomeObject: NSObject {
    var a = "blah"
    var aVC: UIViewController?

    var thingClosure: (() -> Void)?

    weak var delegate: Thingable?

    func doNoescapeClosure(completion: (() -> Void)) {
        aVC?.view.setNeedsLayout()
        completion()
    }

    func doEscapingClosure(completion: @escaping (()-> Void)) {
        self.thingClosure = completion
    }
}
