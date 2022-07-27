//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 이준혁 on 2022/07/26.
//

import UIKit

class WriteDiaryViewController: UIViewController {

    @IBOutlet var txtTitle: UITextField!
    @IBOutlet var txtviewContent: UITextView!
    @IBOutlet var txtDate: UITextField!
    @IBOutlet var btnConfirm: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?    // DatePicker에서 설정된 Date를 저장하는 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        self.btnConfirm.isEnabled = false
    }
    
    private func configureContentsTextView() {
        
        // 0.0에서 1.0 사이의 값을 넣어주어야 하기 때문에 255를 나누는 것이다.
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0) // 색상을 설정할 땐 UIColor
        
        self.txtviewContent.layer.borderColor = borderColor.cgColor // layer관련 색상은 cgColor로 설정해야한다.
        self.txtviewContent.layer.borderWidth = 0.5     // 보더 굵기
        self.txtviewContent.layer.cornerRadius = 5.0    // 코너 둥글게
    }
    
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date  // 날짜만 나오게
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged) // 현재 ViewController에서 사용하므로 self, valueChanged는 값이 변경될 때 호출.
        self.datePicker.locale = Locale(identifier: "ko-KR")
        self.txtDate.inputView = self.datePicker
    }
    
    private func configureInputField() {
        self.txtviewContent.delegate = self
        self.txtTitle.addTarget(self, action: #selector(txtTitleDidChange(_:)), for: .editingChanged)
        self.txtDate.addTarget(self, action: #selector(txtDateDidChange(_:)), for: .editingChanged)
    }
    
    private func validateInputField() {
        self.btnConfirm.isEnabled = !(self.txtTitle.text?.isEmpty ?? true) && !(self.txtDate.text?.isEmpty ?? true) && !self.txtviewContent.text.isEmpty
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formmater = DateFormatter() // 날짜왜 텍스트를 변환하는 역할
        formmater.dateFormat = "yyyy년 MM월 dd일(EEEEE)"  // E가 5번이면 '월' 형식으로 나옴.
        formmater.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        self.txtDate.text = formmater.string(from: datePicker.date)
        self.txtDate.sendActions(for: .editingChanged)  // 날짜가 변경될 때마다 editingChanged가 된다.
    }
    
    @objc private func txtTitleDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func txtDateDidChange(_ textfield: UITextField) {
        self.validateInputField()
    }
    
    @IBAction func tapConfirm(_ sender: UIBarButtonItem) {
    }
    
    // 빈 화면을 누를 때 키보드나, 데이트피커를 닫음.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension WriteDiaryViewController: UITextViewDelegate {
    
    // txtView의 텍스트가 입력될 때마다 호출
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}
