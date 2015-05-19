//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by ANISHA AGARWAL on 5/9/15.
//  Copyright (c) 2015 Anisha Agarwal. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: AnyObject) {
        playAudioWithRateAndPitch(0.5, pitch: 1.0)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithRateAndPitch(2.0, pitch:1.0)
    }
    
    func stopAllPlayers() {
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithRateAndPitch(rate: Float, pitch: Float) {
        stopAllPlayers()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.rate = rate
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAllPlayers()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithRateAndPitch(1.0, pitch:1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithRateAndPitch(1.0, pitch:-1000)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        stopAllPlayers()
        
        var echoNode = AVAudioUnitDelay()
        echoNode.delayTime = NSTimeInterval(0.1)
        audioEngine.attachNode(echoNode)
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.connect(audioPlayerNode, to: echoNode, format: nil)
        audioEngine.connect(echoNode, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler:nil)
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        stopAllPlayers()
        
        var reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset( AVAudioUnitReverbPreset.Cathedral)
        reverbNode.wetDryMix = 60

        audioEngine.attachNode(reverbNode)
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.connect(audioPlayerNode, to: reverbNode, format: audioFile.processingFormat)
        audioEngine.connect(reverbNode, to: audioEngine.outputNode, format: audioFile.processingFormat)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler:nil)
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
}
