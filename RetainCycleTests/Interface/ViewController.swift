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




    @IBAction func pushA(_ sender: Any) {
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




    @IBAction func pushF(_ sender: Any) {
        let vc = ViewController.makeFromStoryboard()
        vc.setupF()
        present(vc, animated: true, completion: nil)
    }




    @IBAction func pushG(_ sender: Any) {
        let vc = ViewController.makeFromStoryboard()
        vc.setupG()
        present(vc, animated: true, completion: nil)
    }




    @IBAction func back(_ sender: Any) {
        print(CFGetRetainCount(self))
        dismiss(animated: true, completion: nil)
        aClosure()
    }




    @IBAction func next(_ sender: Any) {
        let vc = ViewController.makeFromStoryboard()
        present(vc, animated: true, completion: nil)
    }




    @IBAction func backImportantThing(_ sender: Any) {
        dismiss(animated: true) {
            SuperImportantThingDoer.shared.doTheImportantThing {
                print("This is important: \(self.myString)")
            }
        }
    }




    @IBAction func backImportantThingCL(_ sender: Any) {
        dismiss(animated: true) { [myString] in
            SuperImportantThingDoer.shared.doTheImportantThing {
                print("This is important: \(myString)")
            }
        }
    }




    @IBAction func backImportantThingWeak(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            SuperImportantThingDoer.shared.doTheImportantThing {
                print("This is important: \(self?.myString ?? "")")
            }
        }
    }




    @IBAction func doThingBeforeDismiss(_ sender: Any) {
        SuperImportantThingDoer.shared.doTheImportantThing { [weak self] in
            print("This is important: \(self?.myString ?? "")")
            self?.dismiss(animated: true, completion: nil)
        }
    }




    @IBAction func doThingClosure(_ sender: Any) {
        SuperImportantThingDoer.shared.doThing() { result in
            print(result)
            self.dismiss(animated: true, completion: nil)
        }
    }




    @IBAction func doThingClosureWeak(_ sender: Any) {
        SuperImportantThingDoer.shared.doThing() { [weak self] result in
            print(result)
            self?.dismiss(animated: true, completion: nil)
        }
    }




    class func makeFromStoryboard() -> ViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
    }

    var thing: SomeObject = SomeObject()
}

extension ViewController {
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
            navC: self.navigationController,
            smelf: self
        )
        print(CFGetRetainCount(theStuffIWant as CFTypeRef))

        aClosure = {
            print(theStuffIWant.view)
            theStuffIWant.navC?.navigationItem.title = "blah"
        }
    }




    func setupG() {

        aClosure = { [view = self.view, navC = self.navigationController] in
            view?.layer.cornerRadius = 3.0
            navC?.navigationItem.title = "blah"
        }
    }
}
/*
 Even though self isn’t referenced in the outer closure, a strong reference to self is created because Swift does not “look ahead” to see if the nested
 closures describe a strong or weak reference to self. The Swift compiler creates a strong reference because self is referenced by the nested closure
 when [weak self] is specified, which leads to a retain cycle.
 */
