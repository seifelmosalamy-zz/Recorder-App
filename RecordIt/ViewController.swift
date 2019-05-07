//
//  ViewController.swift
//  RecordIt
//
//  Created by Seif Elmosalamy on 10/30/18.
//  Copyright © 2018 Seif Elmosalamy. All rights reserved.

import UIKit
import AVFoundation
class ViewController: UIViewController, AVAudioRecorderDelegate,UITableViewDelegate, UITableViewDataSource{
    
    var recordingSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var numberOfRecords = 0 ;
    var audioPlayer:AVAudioPlayer!
        @IBOutlet weak var myTableView: UITableView!
        @IBOutlet weak var buttonLabel: UIButton!

    func StopRecordImage(){
        let yourImage: UIImage = UIImage(named: "stop.png")!
        buttonLabel.setImage(yourImage, for: .normal)
    }

    func StartRecordImage(){

        let yourImage: UIImage = UIImage(named: "mic.png")!
        buttonLabel.setImage(yourImage, for: .normal)
    }

    @IBAction func record(_ sender: Any) {

        //check if we have an active recorder
        if audioRecorder == nil
        {
            numberOfRecords+=1
            let fileName = getDirectory().appendingPathComponent("\(numberOfRecords).mp4")
            let settings = [ AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey:12000,AVNumberOfChannelsKey:1,AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue]
            do{
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self

                audioRecorder.record()
                buttonLabel.setTitle("Stop Recording", for: .normal)
                StopRecordImage()


            } catch {
                displayAlert(title: "Oops!", message: "Recording Failed")
            }
        }
        else
        {
//            stopping record
        audioRecorder.stop()
            audioRecorder=nil
            UserDefaults.standard.set(numberOfRecords,forKey: "mynumber")
            myTableView.reloadData()
            //buttonLabel.setTitle("Start Recording", for: .normal)
            StartRecordImage()


        }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //setting up session
        recordingSession = AVAudioSession.sharedInstance()
        if let number:Int = UserDefaults.standard.object(forKey: "myNumber") as? Int
        {
            numberOfRecords = number
        }
        AVAudioSession.sharedInstance().requestRecordPermission{(hasPermission) in
        
            if(hasPermission)
            {
                print("Accepted")
            }
        }
    }

 //function that gets path to directory
    //where are we going to save the recordings
    func getDirectory()->URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
//function that displays an alert
    func displayAlert(title:String, message:String)
    {
        let alert = UIAlertController(title:title,message:message,preferredStyle: .alert)

        alert.addAction(UIAlertAction(title:"Dismiss",style:.default,handler: nil))
        present(alert,animated: true, completion: nil)
        //setting up table of view


    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecords
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = String(indexPath.row+1)
        return cell!


    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = getDirectory().appendingPathComponent("\(indexPath.row + 1).mp4")
        do{
            audioPlayer = try AVAudioPlayer(contentsOf:path)
            audioPlayer.play()
        }
        catch{

    }
}


}
