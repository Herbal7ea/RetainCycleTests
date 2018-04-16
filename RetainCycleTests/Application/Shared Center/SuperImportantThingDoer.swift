//
//  SuperImportantThingDoer.swift
//  RetainCycleTests
//
//  Created by Eric Parker on 4/8/18.
//  Copyright © 2018 Eric Parker. All rights reserved.
//

import Foundation

class SuperImportantThingDoer: NSObject {

    // MARK: - Private Properties
    private var operations = [() -> Void]()
    private var timer: Timer?

    // MARK: - Static Internal Properties
    static let shared = SuperImportantThingDoer()


    // MARK: - Lifecycle
    override init() {
        super.init()
    }


    // MARK: - Internal API
    func doTheImportantThing(asyncClosure: @escaping () -> Void) {
        operations.append(asyncClosure)
        setTimer()
    }




    func doThing(completion: (String) -> Void) {
        completion("hi")
    }




    // MARK: - Private API
    private func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: false)
    }




    @objc private func timerElapsed() {
        for op in operations {
            op()
        }
        operations.removeAll()
        timer?.invalidate()
        timer = nil
    }
}
