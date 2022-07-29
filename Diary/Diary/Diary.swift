//
//  Diary.swift
//  Diary
//
//  Created by 이준혁 on 2022/07/28.
//

import Foundation

struct Diary {
    var uuidString: String  // 일기를 생성할 때마다 일기를 측정할 수 있는 고유한 아이디 값.
    var title: String   // 일기 제목
    var contents: String// 일기 내용
    var date: Date      // 일기 작성 날짜
    var isStar: Bool    // 즐겨찾기 여부
}
