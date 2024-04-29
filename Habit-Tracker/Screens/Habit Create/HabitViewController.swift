import UIKit

final class HabitViewController: UIViewController {
    
    let store = HabitsStore.shared
    var habit: Habit?
    
    init(habit: Habit? = nil) {
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.habit = Habit(name: "", date: Date(), color: .white)
        super.init(coder: coder)
    }
    
    var selectedColor: UIColor = .systemOrange {
        didSet {
            colorCircle.backgroundColor = selectedColor
        }
    }
    
    var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
        return view
    }()
    
    lazy var cancelBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Отмена".localized, style: .plain, target: self, action: #selector(cancelButtonTapped))
        button.tintColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
        return button
    }()
    
    lazy var saveBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Сохранить".localized, style: .plain, target: self, action: #selector(saveButtonTapped))
        button.tintColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
        
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "НАЗВАНИЕ".localized
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п.".localized
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.backgroundColor = .white
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var colorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ЦВЕТ".localized
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ВРЕМЯ".localized
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    var colorCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.backgroundColor = UIColor(red: 255/255, green: 159/255, blue: 79/255, alpha: 1)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var chooseTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Каждый день в ".localized
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    lazy var deleteHabitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить привычку".localized, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    
    lazy var timePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy var timeField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "1:00 AM"
        textField.textColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        addColorPickerGesture()
        
        if habit == nil {
            deleteHabitButton.isHidden = true
            title = "Создать".localized
        } else {
            title = "Править".localized
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let habit = self.habit {
            textField.text = habit.name
            colorCircle.backgroundColor = habit.color
        }
    }
    
    func setupViews() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = saveBarButton
        
        view.addSubview(topView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(textField)
        contentView.addSubview(colorLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(colorCircle)
        contentView.addSubview(chooseTimeLabel)
        contentView.addSubview(deleteHabitButton)
        contentView.addSubview(timePickerView)
        contentView.addSubview(timeField)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 60),
            
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 88),
            
            scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 21),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(equalToConstant: 74),
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            textField.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 46),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            textField.widthAnchor.constraint(equalToConstant: 310),
            textField.heightAnchor.constraint(equalToConstant: 22),
            
            colorLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 83),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorLabel.heightAnchor.constraint(equalToConstant: 18),
            
            timeLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 153),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.widthAnchor.constraint(equalToConstant: 47),
            timeLabel.heightAnchor.constraint(equalToConstant: 18),
            
            colorCircle.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 108),
            colorCircle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorCircle.widthAnchor.constraint(equalToConstant: 30),
            colorCircle.heightAnchor.constraint(equalToConstant: 30),
            
            chooseTimeLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 178),
            chooseTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            chooseTimeLabel.widthAnchor.constraint(equalToConstant: 120),
            chooseTimeLabel.heightAnchor.constraint(equalToConstant: 22),
            
            deleteHabitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            deleteHabitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            deleteHabitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            deleteHabitButton.heightAnchor.constraint(equalToConstant: 44),
            
            timePickerView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 215),
            timePickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timePickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            timePickerView.heightAnchor.constraint(equalToConstant: 216),
            
            timeField.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 178),
            timeField.leadingAnchor.constraint(equalTo: chooseTimeLabel.trailingAnchor, constant: 4),
            timeField.widthAnchor.constraint(equalToConstant: 86),
            timeField.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
//MARK: - ACTIONS
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func addNewHabit() {
        guard let timeString = timeField.text, !timeString.isEmpty else {
            let alertController = UIAlertController(title: "Время не выбрано".localized, message: "", preferredStyle: .alert)
            self.present(alertController, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alertController.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        guard selectedColor != .white else {
            let alertController = UIAlertController(title: "Цвет не выбран".localized, message: "", preferredStyle: .alert)
            self.present(alertController, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alertController.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        guard let habitName = textField.text, !habitName.isEmpty else {
            let alertController = UIAlertController(title: "Введите название".localized, message: "", preferredStyle: .alert)
            self.present(alertController, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alertController.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        if let timeString = timeField.text,
           let date = dateFormatter.date(from: timeString) {
            let newHabit = Habit( name: textField.text ?? "",
                                  date: date,
                                  color: selectedColor)
            store.habits.insert(newHabit, at: 0)
            
            if let tabbarVC = presentingViewController as? UITabBarController {
                if let navigationVC = tabbarVC.viewControllers?.first as? UINavigationController {
                    if let habitsVC = navigationVC.viewControllers.first as? HabitsViewController {
                        habitsVC.collectionView.reloadData()
                    }
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func updateHabit() {
        deleteHabitButton.isHidden = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        if let currentHabit = self.habit {
            store.habits.removeAll { $0.id == currentHabit.id }
            
            if let habitName = textField.text, !habitName.isEmpty,
               let timeString = timeField.text,
               let date = dateFormatter.date(from: timeString) {
                let newHabit = Habit(name: habitName,
                                     date: date,
                                     color: selectedColor)
                store.habits.insert(newHabit, at: 0)
                dismiss(animated: true)
            } else {
                let alertController = UIAlertController(title: "Введите название".localized, message: "", preferredStyle: .alert)
                self.present(alertController, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func saveButtonTapped() {
        
        switch self.habit {
        case .none:
            addNewHabit()
        case .some:
            updateHabit()
        }
    }
    
    @objc func showAlert() {
        
        let alertController = UIAlertController(
            title: NSLocalizedString("Delete habit", comment: ""),
            message: String(format: NSLocalizedString("Do you want to delete the habit %@", comment: ""), textField.text ?? ""),
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "Удалить".localized, style: .default) {_ in
            if let currentHabit = self.habit {
                self.store.habits.removeAll { $0.id == currentHabit.id }
                
                if let tabbarVC = self.presentingViewController as? UITabBarController {
                    
                    if let navigationVC = tabbarVC.viewControllers?.first as? UINavigationController {
                        navigationVC.popToRootViewController(animated: true)
                    }
                }
            }
            self.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена".localized, style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
}

//MARK: - EXTENSIONS

extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func addColorPickerGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorCircleTapped))
        colorCircle.addGestureRecognizer(tapGesture)
    }
    
    @objc func colorCircleTapped() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = selectedColor
        present(colorPicker, animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        textField.textColor = selectedColor
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        textField.textColor = selectedColor
    }
}

extension HabitViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return 12
        } else if component == 1 {
            return 60
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return "\(row % 12 + 1)"
        } else if component == 1 {
            return String(format: "%02d", row)
        } else {
            return row == 0 ? "AM" : "PM"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updatePickerButtonTitle()
    }
    
    private func updatePickerButtonTitle() {
        let hourComponent = timePickerView.selectedRow(inComponent: 0) % 12 + 1
        let minuteComponent = String(format: "%02d", timePickerView.selectedRow(inComponent: 1))
        let amPmComponent = timePickerView.selectedRow(inComponent: 2) == 0 ? "AM" : "PM"
        
        let timeString = "\(hourComponent):\(minuteComponent) \(amPmComponent)"
        timeField.text = timeString
    }
}

