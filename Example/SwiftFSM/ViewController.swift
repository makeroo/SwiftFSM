//
//  ViewController.swift
//  SwiftFSM
//
//  Created by Ciprian Caba on 08/01/2015.
//  Copyright (c) 2015 Ciprian Caba. All rights reserved.
//

import UIKit
import SwiftFSM

class ViewController: UIViewController {
  
  fileprivate let fsm = SwiftFSM<TurnstileState, TurnstileTransition>(id: "TurnstileFSM", willLog: false)
  
  @IBOutlet var stateTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    stateTextView.isEditable = false
    
    // add new states and get a reference to them so you can map handlers and define transitions
    let locked = fsm.addState(.Locked)
    
    // Define an inline onEnter handler
    locked.onEnter = { (transition: TurnstileTransition) -> Void in
      self.append("Entered the \(self.fsm.currentState) state with the \(transition) transition")
    }
    
    // Define as many transitions to any states (including itself)
    locked.addTransition(.Push, to: .Locked)
    locked.addTransition(.Coin, to: .Unlocked)
    
    
    let unlocked = fsm.addState(.Unlocked)
    
    // Define handlers as reference
    unlocked.onEnter = handleUnlocked
    // Listen to onExit event
    unlocked.onExit = handleUnlockedExit
    
    unlocked.addTransition(.Coin, to: .Unlocked)
    unlocked.addTransition(.Push, to: .Locked)
    
    // Start the fsm in a specific state.. Please note that this will not trigger the initial onEnter callback
    fsm.startFrom(.Locked)
  }
  
  func handleUnlocked(_ transition: TurnstileTransition) {
    append("Entered the \(self.fsm.currentState) state with the \(transition) transition")
  }
  
  func handleUnlockedExit(_ transition: TurnstileTransition) {
    append("Turnstile fsm exited the Unlocked state with the \(transition) transition")
  }
  
  func append(_ message: String) {
    guard let text = self.stateTextView.text else {
        return
    }
    stateTextView.text = "\(text)\n\(message)"
    stateTextView.scrollRangeToVisible(NSMakeRange(stateTextView.text.characters.count - 1, 1))
  }
  
  @IBAction func onCoin(_ sender: AnyObject) {
    if let _ = fsm.transitionWith(.Coin) {
      // state change happened
    } else {
      // transition was not valid
    }
  }
  
  @IBAction func onPush(_ sender: AnyObject) {
    fsm.transitionWith(.Push)
  }
}

