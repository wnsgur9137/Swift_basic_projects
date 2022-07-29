//
//  ViewController.swift
//  Diary
//
//  Created by 이준혁 on 2022/07/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    private var diaryList = [Diary]() {
        didSet {    // 다이어리 리스트 배열에 추가, 변경이 될 때마다 아래 코드를 실행.
            self.saveDiaryList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadDiaryList()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editDiaryNotification(_:)),
                                               name: NSNotification.Name("editDiary"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(starDiaryNotification(_:)),
                                               name: NSNotification.Name("starDiary"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deleteDiaryNotification(_:)),
                                               name: NSNotification.Name("deleteDiary"),
                                               object: nil)
    }
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)   // CollectionView의 좌, 우, 위, 아래의 간격이 각각 10이다.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == diary.uuidString }) else { return }
        self.diaryList[index] = diary
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String: Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
        self.diaryList[index].isStar = isStar
    }
    
    @objc func deleteDiaryNotification(_ notification: Notification) {
        guard let uuidString = notification.object as? String else { return }
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
        self.diaryList.remove(at: index)
        self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
            writeDiaryViewController.delegate = self
        }
    }
    
    /// 일기들을 UserDefaults에 딕셔너리 형태로 저장. (앱을 재실행 할 경우 남아있도록하기 위함)
    private func saveDiaryList() {
        let date = self.diaryList.map {
            [
                "uuidString": $0.uuidString,
                "title": $0.title,
                "contents": $0.contents,
                "date": $0.date,
                "isStar": $0.isStar
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(date, forKey: "diaryList")
    }
    
    
    /// UserDefaults에 저장된 값들을 가져옴.
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        self.diaryList = data.compactMap {
            guard let uuidString = $0["uuidString"] as? String else { return nil }
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            return Diary(uuidString: uuidString, title: title, contents: contents, date: date, isStar: isStar)
        }
        // 최신 날짜로 정렬하기 위한 코드
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending // 내림차순
        })
    }
    
    private func dateToString(date: Date) -> String { // Date타입을 String으로 바꿔준다.
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)" // ex) 22년 07월 28일(목)
        formatter.locale = Locale(identifier: "ko_KR")  // Date Format을 한국으로
        return formatter.string(from: date)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    // 필수 메서드 (지정된 섹션에 표시할 셀의 개수)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    // 필수 메서드 (컬렉션 뷰에 지정된 위치에 표시할 셀을 요청하는 메서드)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
        let diary = self.diaryList[indexPath.row]
        cell.lblTitle.text = diary.title
        cell.lblDate.text = self.dateToString(date: diary.date)  // diary.date는 Date타입이므로, 문자열로 변경해 준다.
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    // 셀의 사이즈를 설정하는 메서드
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, // 아이폰 화면의 너비를 2로 나눈 값에서 너비 값 좌 우 10씩이므로 20을 빼준다.
                      height: 200)
    }
}

extension ViewController: WriteDiaryViewDelegate {
    func didSelectReigster(diary: Diary) {
        self.diaryList.append(diary)
        
        // 최신 날짜로 정렬하기 위한 코드
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending // 내림차순
        })
        self.collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDelegate {
    
    // 셀이 선택되었을 경우 실행
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = self.diaryList[indexPath.row]   // 선택한 셀이 무엇인지
        viewController.diary = diary
        viewController.indexPath = indexPath
//        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)   // navigation 사용
    }
}

//extension ViewController: DiaryDetailViewDelegate {
//    func didSelectDelete(indexPath: IndexPath) {
//        self.diaryList.remove(at: indexPath.row)
//        self.collectionView.deleteItems(at: [indexPath])
//    }
//
//    func didSelectStar(indexPath: IndexPath, isStar: Bool) {
//        self.diaryList[indexPath.row].isStar = isStar
//    }
//}
