//
//  ViewController.swift
//  SoundBox
//
//  Created by QTS Mobile on 29/04/2024.
//

import UIKit
import AVFAudio

class LauchController: UIViewController {
    
    @IBOutlet var backgroundLauch: UIView!
    @IBOutlet weak var logoLauch: UIImageView!
    var player:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLogo()
    }
    
    func loadLogo(){
        logoLauch.image=UIImage.gifImageWithName("Sound Box")
        loadAudioLauch()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+6){
            let controller=self.storyboard!.instantiateViewController(withIdentifier: "TabBar")
            //Replace rootView
            UIApplication.shared.keyWindow?.rootViewController=controller
        }
        
    }
    func loadAudioLauch(){
        let url=URL(fileURLWithPath: Bundle.main.path(forResource: "intro", ofType: "mp3")!)
        do{
            player=try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        }
        catch{
            fatalError("Loi phat nhac")
        }
    }
    
}

