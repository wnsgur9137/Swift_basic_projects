//
//  ViewController.swift
//  ToDoList
//
//  Created by 이준혁 on 2022/07/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var btnEdit: UIBarButtonItem! // strong(재사용을 위해)
    
    var btnDone: UIBarButtonItem?
    
    var tasks = [Task]() {
        didSet {
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(actionDoneButton))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks()
    }
    
    // #selector로 호출할 함수는 @objc가 무조건 필요하다.
    // objc 는 object-c 언어에서 인식이 가능하다.
    @objc func actionDoneButton() {
        self.navigationItem.leftBarButtonItem = self.btnEdit
        self.tableView.setEditing(false, animated: true)
    }

    @IBAction func actionEditButton(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else { return }
        self.navigationItem.leftBarButtonItem = self.btnDone
        self.tableView.setEditing(true, animated: true)
    }
    
    @IBAction func actionAddButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in // 클로저 본문에서 셀프 키워드를 사용할 경우 weak를 사용하지 않으면 메모리 누수가 발생할 수 있다.
            guard let title = alert.textFields?[0].text else { return }
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData()
        })
        let cancleButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancleButton)
        alert.addAction(registerButton)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력해 주십시오."
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveTasks() {
        let data = self.tasks.map {
            [
                "title": $0.title,
                "done": $0.done
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let done = $0["done"] as? Bool else { return nil}
            return Task(title: title, done: done)
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    // 무조건 필요
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    // 무조건 필요
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) // 지정된 재사용 식별자에 대한 재사용 가능한 테이블 뷰 셀 객체를 반환하고, 이를 테이블 뷰에 추가하는 메서드이다. 지정된 재사용 식별자는 withIndentifier을 의미한다. 큐를 사용하여 셀을 재사용하게 된다. (메모리 낭비를 방지하기 위해)
        let task = self.tasks[indexPath.row]
        if task.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.textLabel?.text = task.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)

        if self.tasks.isEmpty {
            self.actionDoneButton()
        }
    }
    
    // 아래 두 개는 편집 모드에서 셀을 재정의 하기 위해 사용
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 변경된 배열 인덱스 재정의
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)
        self.tasks = tasks
    }
}

extension ViewController: UITableViewDelegate {
    
    // 어떤 셀이 선택되었는지 알려주는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
