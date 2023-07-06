import UIKit

final class HabitDetailsViewController: UIViewController {
    
    let habit: Habit
    let store = HabitsStore.shared
    private lazy var calendar: Calendar = Calendar.current
    
    var dates: [Date] {
        return store.dates
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
        return view
    }()
    
    var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
        return view
    }()
    
    lazy var changeBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(changeHabit))
        button.tintColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray5
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DateCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    
    init(habit: Habit) {
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
    }
    
    
    func setupViews() {
        view.backgroundColor = .systemGray5
        title = habit.name
        navigationItem.rightBarButtonItem = changeBarButton
        
        view.addSubview(topView)
        view.addSubview(bottomView)
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 88),
            
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 83),
            
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
    }
    
    @objc func changeHabit() {
        let habitVC = HabitViewController(habit: habit)
        let habitNav = UINavigationController(rootViewController: habitVC)
        present(habitNav, animated: true)
    }
}

//MARK: - EXTENSIONS

extension HabitDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let date = dates[indexPath.row]
        if store.habit(self.habit, isTrackedIn: date) == false {
            return 0
        }
        return UITableView.automaticDimension
    }
}

extension HabitDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath)
        let date = dates[indexPath.row]
        
        if store.habit(self.habit, isTrackedIn: date) {
            let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
            checkmarkImageView.tintColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
            checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
            
            cell.contentView.addSubview(checkmarkImageView)
            
            NSLayoutConstraint.activate([
                checkmarkImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                checkmarkImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
                checkmarkImageView.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
        
        if Calendar.current.isDateInToday(date) {
            cell.textLabel?.text = "Сегодня"
        } else if Calendar.current.isDateInYesterday(date) {
            cell.textLabel?.text = "Вчера"
        } else if Calendar.current.isDateInDayBeforeYesterday(date) {
            cell.textLabel?.text = "Позавчера"
        } else {
            cell.textLabel?.text = dateFormatter.string(from: date)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        let label = UILabel()
        label.frame = CGRect(x: 16, y: 0, width: tableView.frame.width - 32, height: 20)
        label.text = "АКТИВНОСТЬ"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
}

private extension Date {
    var dayBeforeYesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: Calendar.current.startOfDay(for: self)) ?? self
    }
}

private extension Calendar {
    func isDateInDayBeforeYesterday(_ date: Date) -> Bool {
        return isDate(date, equalTo: date.dayBeforeYesterday, toGranularity: .day)
    }
}
