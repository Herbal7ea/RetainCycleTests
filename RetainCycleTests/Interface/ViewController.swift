//
//  ViewController.swift
//  RetainCycleTests
//
//  Created by Eric Parker on 3/29/18.
//  Copyright © 2018 Eric Parker. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Thingable {

    var aClosure: (() -> Void) = { }

    let myString: String = "So Much String"

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        print("I did not leak!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    func setupA() {
        aClosure = {
            UIView.animate(withDuration: 0.2) {
                self.view.backgroundColor = UIColor.green
            }
        }
    }

    func setupB() {
        aClosure = {
            UIView.animate(withDuration: 0.2) {
                print("Hello")
            }
        }
    }

    func setupC() {

        aClosure = {
            UIView.animate(withDuration: 0.2) { [weak self] in
                print("heyo")
            }
        }
    }

    func setupD() {
        aClosure = { [weak self] in
            UIView.animate(withDuration: 0.2) {
                self?.view.backgroundColor = UIColor.green
            }
        }
    }

    func setupE() {
        aClosure = {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.view.backgroundColor = UIColor.green
            }
        }
    }

    func setupF() {

        let theStuffIWant = (
            view: self.view,
            navC: self.navigationController
        )

        aClosure = {
            print(theStuffIWant.view)
            theStuffIWant.navC?.navigationItem.title = "blah"
        }
    }

    func setupG() {

        let theStuffIWant = (
            view: self.view,
            navC: self.navigationController
        )

        aClosure = { [view = self.view, navC = self.navigationController] in
            print(theStuffIWant.view)
            theStuffIWant.navC?.navigationItem.title = "blah"
        }
    }

    @IBAction func go(_ sender: Any) {
        let vc = ViewController.makeFromStoryboard()
        vc.setupA()
        present(vc, animated: true, completion: nil)
    }

    @IBAction func pushB(_ sender: Any) {
        let vc = ViewController.makeFromStoryboard()
        vc.setupB()
        present(vc, animated: true, completion: nil)
    }


    @IBAction func pushC(_ sender: Any) {
        let vc = ViewController.makeFromStoryboard()
        vc.setupC()
        present(vc, animated: true, completion: nil)
    }

    @IBAction func pushD(_ sender: Any) {
        let vc = ViewController.makeFromStoryboard()
        vc.setupD()
        present(vc, animated: true, completion: nil)
    }

    @IBAction func pushE(_ sender: Any) {
        let vc = ViewController.makeFromStoryboard()
        vc.setupE()
        present(vc, animated: true, completion: nil)
    }

    @IBAction func back(_ sender: Any) {
        print(CFGetRetainCount(self))
        dismiss(animated: true, completion: nil)
    }

    class func makeFromStoryboard() -> ViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
    }
}


/*
 Even though self isn’t referenced in the outer closure, a strong reference to self is created because Swift does not “look ahead” to see if the nested
 closures describe a strong or weak reference to self. The Swift compiler creates a strong reference because self is referenced by the nested closure
 when [weak self] is specified, which leads to a retain cycle.
 */
