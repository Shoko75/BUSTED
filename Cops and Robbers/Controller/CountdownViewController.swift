//
//  CountdownViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-02-22.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit
import Lottie

protocol CountdownDelegate {
    func startGame()
}

class CountdownViewController: UIViewController {

    @IBOutlet weak var animationUIView: UIView!
    @IBOutlet var timeLabel: UILabel!
    
    let animationView = AnimationView()
    var timer:Timer?
    var timeLeft = 30
    var countdownDelegate: CountdownDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playAnimation()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }

    @objc func onTimerFires()
    {
        timeLeft -= 1
        timeLabel.text = "\(timeLeft)"

        if timeLeft <= 0 {
            self.dismiss(animated: true) {
                self.countdownDelegate?.startGame()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {

        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.loop,
                           completion: { (finished) in
                            if finished {
                                print("Animation Complete")
                            } else {
                                print("Animation cancelled")
                            }
        })
    }
    
    func playAnimation() {
        let animation = Animation.named("timer")
        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.animation = animation

        animationView.contentMode = .scaleAspectFit

        self.animationUIView.addSubview(animationView)

    }
}
