//
//  ViewController.swift
//  pomodoroTimer
//
//  Created by 이준혁 on 2022/07/31.
//

import UIKit
import AudioToolbox

enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {

    @IBOutlet var lblTimer: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnStart: UIButton!
    @IBOutlet var imgPomodoro: UIImageView!
    
    // 타이머에 저장된 시간을 초 단위로 저장한다.
    var duration = 60
    var timerStatus: TimerStatus = .end
    var timer: DispatchSourceTimer?
    var currentSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStartButton()
    }
    
    func configureStartButton() {
        self.btnStart.setTitle("시작", for: .normal)
        self.btnStart.setTitle("일시정지", for: .selected)
    }
    
    func setTimerInfoViewVisible(isHidden: Bool) {
        if isHidden {
            UIView.animate(withDuration: 0.5, animations: {
                self.lblTimer.alpha = 0
                self.progressView.alpha = 0
                self.datePicker.alpha = 1
                self.imgPomodoro.transform = .identity
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.lblTimer.alpha = 1
                self.progressView.alpha = 1
                self.datePicker.alpha = 0
            })
        }
//        self.lblTimer.isHidden = isHidden
//        self.progressView.isHidden = isHidden
        
        self.btnStart.isSelected = !isHidden
        self.btnCancel.isEnabled = !isHidden
        self.datePicker.isHidden = !isHidden
    }
    
    func startTimer() {
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)    // UI 를 수정해야 하므로 .main(ios에서 오직 한 개만 존재하는 스레드)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else { return }   // self가 strong 레퍼런스가 되도록 해준다.
                self.currentSeconds -= 1
//                debugPrint(self.currentSeconds)
                let hour = self.currentSeconds / 3600
                let minutes = (self.currentSeconds % 3600) / 60
                let seconds = (self.currentSeconds % 3600) % 60
                self.lblTimer.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
                
                self.progressView.progress = Float(self.currentSeconds) / Float(self.duration)
//                debugPrint(self.progressView.progress)
                
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.imgPomodoro.transform = CGAffineTransform(rotationAngle: .pi)  // 180도 회전
                })
                UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                    self.imgPomodoro.transform = CGAffineTransform(rotationAngle: .pi * 2)  // 360도 회전
                })
                
                if self.currentSeconds <= 0 {
                    self.stopTimer()
                    AudioServicesPlaySystemSound(1005)  // 1005 =-> 알람소리 iphonedev.wiki 참고
                }
            })
            self.timer?.resume()
        }
    }
    
    func stopTimer() {
        // 일시정지 상태에서 nil을 대입하면 에러가 난다. 그렇기에 resume()메서드를 사용해야 한다.
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        self.timerStatus = .end
        self.setTimerInfoViewVisible(isHidden: true)
        self.timer?.cancel()
        self.timer = nil    // 타이머를 종료할 때 nil을 사용하여 해제시켜야 메모리를 소모하지 않는다.
    }

    @IBAction func tapCancel(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause:
            self.stopTimer()
        default:
            break
        }
    }
    
    @IBAction func tapStart(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration) // 2분 -> 120초와 같이 저장해줌.
//        debugPrint(self.duration)
        
        switch self.timerStatus {
        case .end:
            self.currentSeconds = self.duration
            self.timerStatus = .start
            self.setTimerInfoViewVisible(isHidden: false)
            self.startTimer()
        case .start:
            self.timerStatus = .pause
            self.btnStart.isSelected = false
            self.timer?.suspend()   // 타이머 일시정지
        case .pause:
            self.timerStatus = .start
            self.btnStart.isSelected = true
            self.timer?.resume()
        }
    }
    
}

