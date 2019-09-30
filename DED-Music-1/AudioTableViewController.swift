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
import LiveKnob

// Declare your nodes as instance variables
var player: AKPlayer!
var delay: AKDelay!
var reverb: AKReverb!
var reverb2: AKReverb!
var file: AKAudioFile!
var hpFilter: AKHighPassFilter!
var lpFilter: AKLowPassFilter!
var pitchShifter: AKPitchShifter!
var chorus: AKChorus!
var delayIsOn: Bool = true
var myNode: AKNode!

var isPlaying : Bool = false
//var myAudioEngine = AudioEngine()

class AudioTableViewController: UITableViewController {

    
    @IBAction func DelayOnOffSwitch(_ sender: UISwitch) {
        if sender.isOn {
            delayIsOn = true
            myNode = delay
            print("IBAction delay is on")
        } else {
            delayIsOn = false
            myNode = player
            print("IBAction delay is off")
            delay.dryWetMix = 0
        }
        
//            delay = AKDelay(player)
//
//        // Set the parameters of the delay here
//            delay.time = 0.2 // seconds
//            delay.feedback = 0.5 // Normalized Value 0 - 1
//            delay.dryWetMix = 0.5 // Normalized Value 0 - 1
    }
    
    
    @IBOutlet weak var LiveKnobDelay1: LiveKnob!
    
    @IBAction func LiveKnobDelay1(_ sender: UISlider) {
        delay.time = Double((sender as UISlider).value)
        print(delay.time, " time")
    }
    
    @IBOutlet weak var LiveKnobDelay2: LiveKnob!
    
    @IBAction func LiveKnobDelay2(_ sender: UISlider) {
        delay.feedback = Double((sender as! UISlider).value)
        print(delay.feedback, " feedback")
    }
    
    
    @IBOutlet weak var slider3: LiveKnob!
    
    @IBAction func slider3(_ sender: UISlider) {
        delay.dryWetMix = Double((sender as UISlider).value)
        print(delay.dryWetMix, " dryWetMix")
    }
    
    @IBAction func StartButton(_ sender: UIButton!) {
        if isPlaying == false {
            player.play()
            isPlaying = true
//            player.isLooping = true
        }
    }

    
    @IBAction func StopButton(_ sender: Any) {
        if isPlaying == true {
            player.stop()
            isPlaying = false
 //           player.isLooping = false
        }
    }
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        // Do any additional setup after loading the view.
    
//        play()        updateButton()

//        let engine = AudioEngine()
//        myAudioEngine.player.play()
          // Set up a player to the loop the file's playback
          do {
              file = try AKAudioFile(readFileName: "77_ECHOBEAT_02_C.wav")
          } catch {
              AKLog("File Not Found")
              return
          }
          player = AKPlayer(audioFile: file)
          player.isLooping = true

          if delayIsOn == true {
              print("Delay On")
  //        // Connect the audio player to a delay effect
              delay = AKDelay(player)
            
          // Set the parameters of the delay here
              delay.time = 0.1 // seconds
              delay.feedback = 0.5 // Normalized Value 0 - 1
 //             delay.dryWetMix = 0.5 // Normalized Value 0 - 1
  
              myNode = delay
          } else {
  
              print("Delay Off")
              myNode = player
          }
          
          // Continue adding more nodes as you wish, for example, reverb:
          reverb = AKReverb(myNode)
          reverb.loadFactoryPreset(.largeHall2)

          reverb2 = AKReverb(reverb)
          reverb2.loadFactoryPreset(.cathedral)

          hpFilter = AKHighPassFilter(reverb2)
          hpFilter.cutoffFrequency = 100 // Hz
          hpFilter.resonance = 0.5 // dB
          
          lpFilter = AKLowPassFilter(hpFilter)
          lpFilter.cutoffFrequency = 200 // Hz
          lpFilter.resonance = 0.5 // dB
          
          pitchShifter = AKPitchShifter(lpFilter)
          pitchShifter.shift = 24
          
          chorus = AKChorus(pitchShifter)
  //        chorus.frequency = 400
          chorus.depth = 0.1
          chorus.feedback = 0.1
          chorus.dryWetMix = 0.8
          
  //        AudioKit.output = myNode
          AudioKit.output = pitchShifter
          do {
              try AudioKit.start()
          } catch {
              AKLog("AudioKit did not start!")
          }
      
        delayIsOn = true

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

