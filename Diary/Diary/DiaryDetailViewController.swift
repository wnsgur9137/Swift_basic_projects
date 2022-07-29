//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 이준혁 on 2022/07/26.
//

import UIKit

// delegate를 사용하여 통신을 할 경우 1:1만 가능하다. (즐겨찾기에서도 사용하기 위해 아래 Delegate는 사용하지 않는다.)
// 삭제가 일어날 때 ViewController에 전달하여 각각 화면에서 삭제됨을 위함.
//protocol DiaryDetailViewDelegate: AnyObject {
//    func didSelectDelete(indexPath: IndexPath)
//    func didSelectStar(indexPath: IndexPath, isStar: Bool)
//}

class DiaryDetailViewController: UIViewController {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var txtViewContents: UITextView!
    @IBOutlet var lblDate: UILabel!
    
    var btnStar: UIBarButtonItem?
    
//    weak var delegate: DiaryDetailViewDelegate?
    
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(starDiaryNotification(_:)),
                                               name: NSNotification.Name("starDiary"),
                                               object: nil)
    }
    
    private func configureView() {
        guard let diary = self.diary else { return }
        self.lblTitle.text = diary.title
        self.txtViewContents.text = diary.contents
        self.lblDate.text = self.dateToString(date: diary.date)
        self.btnStar = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapBtnStar))
        self.btnStar?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.btnStar?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.btnStar
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "Ko_KR")
        return formatter.string(from: date)
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        // post에서 보낸 객체를 가져온다.
        guard let diary = notification.object as? Diary else { return }
        self.diary = diary
        self.configureView()
    }
    
    @objc func starDiaryNotification(_ notifiation: Notification) {
        guard let starDiary = notifiation.object as? [String: Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        guard let diary = self.diary else { return }
        
        if diary.uuidString == uuidString {
            self.diary?.isStar = isStar
            self.configureView()
        }
    }
    
    @IBAction func btnEdit(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        viewController.diaryEditorMode = .edit(indexPath, diary)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editDiaryNotification(_:)),
                                               name: NSNotification.Name("editDiary"),
                                               object: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func btnDelete(_ sender: UIButton) {
        guard let uuidString = self.diary?.uuidString else { return }
        
        // Delegate 사용하지 않기에 주석처리.
//        self.delegate?.didSelectDelete(indexPath: indexPath)
        NotificationCenter.default.post(name: NSNotification.Name("deleteDiary"),
                                        object: uuidString,
                                        userInfo: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapBtnStar() {
        guard let isStar = self.diary?.isStar else { return }

        if isStar {
            self.btnStar?.image = UIImage(systemName: "star")
        } else {
            self.btnStar?.image = UIImage(systemName: "star.fill")
        }
        self.diary?.isStar = !isStar
        NotificationCenter.default.post(name: NSNotification.Name("starDiary"),
                                        object: [
                                            "diary": self.diary,
                                            "isStar": self.diary?.isStar ?? false,
                                            "uuidString": diary?.uuidString
                                        ],
                                        userInfo: nil)
        
        // Delegate를 통한 통신을 사용하지 않기에 주석처리.
//        self.delegate?.didSelectStar(indexPath: indexPath, isStar: self.diary?.isStar ?? false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
