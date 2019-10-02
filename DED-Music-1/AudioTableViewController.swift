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
var reverb1: AKReverb!
var reverb2: AKReverb!
var file: AKAudioFile!
var hpFilter: AKHighPassFilter!
var lpFilter: AKLowPassFilter!
var pitchShifter: AKPitchShifter!
var chorus: AKChorus!
var delayIsOn: Bool = true
var myNode: AKNode!
var reverb1PickerData: [String] = [String]()

var isPlaying : Bool = false
//var myAudioEngine = AudioEngine()

           let fatten = AKOperationEffect(pitchShifter) { input, parameters in

               let time = parameters[0]
               let mix = parameters[1]

               let fatten = "\(input) dup \(1 - mix) * swap 0 \(time) 1.0 vdelay \(mix) * +"

               return AKStereoOperation(fatten)
           }


class AudioTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reverb1PickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return reverb1PickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        switch reverb1PickerData[row] {
         case "Cathedral":
             reverb1.loadFactoryPreset(.cathedral)
             reverb2.loadFactoryPreset(.cathedral)
         case "Large Hall":
             reverb1.loadFactoryPreset(.largeHall)
             reverb2.loadFactoryPreset(.largeHall)
         case "Large Hall 2":
             reverb1.loadFactoryPreset(.largeHall2)
             reverb2.loadFactoryPreset(.largeHall2)
         case "Large Room":
             reverb1.loadFactoryPreset(.largeRoom)
             reverb2.loadFactoryPreset(.largeRoom)
         case "Large Room 2":
             reverb1.loadFactoryPreset(.largeRoom2)
             reverb2.loadFactoryPreset(.largeRoom2)
         case "Medium Chamber":
             reverb1.loadFactoryPreset(.mediumChamber)
             reverb2.loadFactoryPreset(.mediumChamber)
         case "Medium Hall":
             reverb1.loadFactoryPreset(.mediumHall)
         case "Medium Hall 2":
             reverb1.loadFactoryPreset(.mediumHall2)
             reverb2.loadFactoryPreset(.mediumHall2)
         case "Medium Hall 3":
             reverb1.loadFactoryPreset(.mediumHall3)
             reverb2.loadFactoryPreset(.mediumHall3)
         case "Medium Room":
             reverb1.loadFactoryPreset(.mediumRoom)
             reverb2.loadFactoryPreset(.mediumRoom)
         case "Plate":
             reverb1.loadFactoryPreset(.plate)
             reverb2.loadFactoryPreset(.plate)
         case "Small Room":
             reverb1.loadFactoryPreset(.smallRoom)
             reverb2.loadFactoryPreset(.smallRoom)
         default:
             break
         }
    }
    
    
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
        delay.feedback = Double((sender ).value)
        print(delay.feedback, " feedback")
    }
    
    @IBOutlet weak var LiveKnobReverb1: LiveKnob!
    
    
    @IBAction func LiveKnobReverb1(_ sender: UISlider) {
        reverb1.dryWetMix = Double((sender ).value)
        print(reverb1.dryWetMix, " reverb1")
    }
    
    @IBOutlet weak var LiveKnobReverb2: LiveKnob!
    
    
    @IBAction func LiveKnobReverb2(_ sender: UISlider) {
        reverb2.dryWetMix = Double((sender ).value)
        print(reverb2.dryWetMix, " reverb2")
    }
    
    @IBOutlet weak var slider3: LiveKnob!
    
    @IBAction func slider3(_ sender: UISlider) {
        delay.dryWetMix = Double((sender as UISlider).value)
        print(delay.dryWetMix, " dryWetMix")
    }
    
    
    @IBOutlet weak var Reverb1PickerView: UIPickerView!
    
   // High Pass Filter
    @IBOutlet weak var freqHPFLabel: UILabel!
    
    @IBAction func highPassSlider(_ sender: UISlider) {
        hpFilter.cutoffFrequency = Double(Int(sender.value))
        freqHPFLabel.text = String(Int(sender.value)) + " Hz"
        print(String(Int(sender.value)))
    }
   
    @IBAction func resonanceHPFLiveKnob(_ sender: UISlider) {
        hpFilter.resonance = Double((sender as UISlider).value)
        print(hpFilter.resonance, " HP resonance")
    }
    
    // Low Pass Filter
    @IBOutlet weak var freqLPLabel: UILabel!
    
    @IBAction func lowPassSlider(_ sender: UISlider) {
        lpFilter.cutoffFrequency = Double(Int(sender.value))
        freqLPLabel.text = String(Int(sender.value)) + " Hz"
        print(String(Int(sender.value)))
    }
    
    @IBAction func resonanceLPFLiveKnob(_ sender: UISlider) {
        lpFilter.resonance = Double((sender as UISlider).value)
        print(lpFilter.resonance, " LP resonance")
    }
    
    // Pitch Shifter
    @IBOutlet weak var semitonesLabel: UILabel!
    
    @IBAction func semitoneSlider(_ sender: UISlider) {
        pitchShifter.shift = Double(Int(sender.value))
        semitonesLabel.text = String(Int(sender.value)) + " Semitones"
        print(String(Int(sender.value)))
    }
    
    // Start & Stop controls
    @IBAction func StartButton(_ sender: UIButton!) {
        if isPlaying == false {
            player.play()
            fatten.parameters = [0.3, 0.5]
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
        
        self.Reverb1PickerView.delegate = self
        self.Reverb1PickerView.dataSource = self
        
        reverb1PickerData = ["Small Room", "Medium Room", "Large Room", "Large Room 2", "Medium Hall", "Medium Hall 2", "Medium Hall 3", "Large Hall", "Large Hall 2", "Plate", "Medium Chamber", "Large Chamber", "Cathedral"]
                
        
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
          reverb1 = AKReverb(myNode)
//          reverb1.loadFactoryPreset(.cathedral)

          reverb2 = AKReverb(reverb1)
//          reverb2.loadFactoryPreset(.cathedral)

          hpFilter = AKHighPassFilter(reverb2)
//          hpFilter.cutoffFrequency = 100 // Hz
//          hpFilter.resonance = 0.5 // dB
          
          lpFilter = AKLowPassFilter(hpFilter)
//          lpFilter.cutoffFrequency = 200 // Hz
//          lpFilter.resonance = 0.5 // dB
          
          pitchShifter = AKPitchShifter(lpFilter)
//          pitchShifter.shift = -12
          
//          chorus = AKChorus(pitchShifter)
//  //        chorus.frequency = 400
//          chorus.depth = 0.1
//          chorus.feedback = 0.1
//          chorus.dryWetMix = 0.8
        
       
            
        
//          AudioKit.output = myNode
//          let rebalancedWithSource = AKBalancer(pitchShifter, comparator: player)
          AudioKit.output = fatten
//          AudioKit.output = rebalancedWithSource
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

