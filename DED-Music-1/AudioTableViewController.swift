//
//  ViewController.swift
//  DED-Music-1
//
//  Created by David Dorgan on 9/28/19.
//  Copyright © 2019 DED Software. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

//var myAudioEngine = AudioEngine()

class AudioTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
//        play()
        
        let engine = AudioEngine()
        engine.player.play()
    
    }

    func play() {
        let oscillator = AKOscillator()
        oscillator.frequency = random(in: 220...880)
        oscillator.rampDuration = 0.5

        let envelope = AKAmplitudeEnvelope(oscillator)
        envelope.attackDuration = 0.01
        envelope.decayDuration = 0.9
        envelope.sustainLevel = 0.9
        envelope.releaseDuration = 0.9
  
        let reverb = AKReverb(oscillator)
        reverb.dryWetMix = 0.5
        
//    AudioKit.output = envelope
    AudioKit.output = reverb
    try! AudioKit.start()
    
    oscillator.start()
//    oscillator.frequency = random(in: 220...880)
    sleep(3)
    oscillator.stop()
    
    }
    
}

