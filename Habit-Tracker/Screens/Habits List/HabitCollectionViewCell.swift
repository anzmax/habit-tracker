import UIKit

final class HabitCollectionViewCell: UICollectionViewCell {
    
    var habit: Habit?
    var progressCell: ProgressCollectionViewCell?
    
    static let id = "HabitCollectionViewCell"
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = ""
        return label
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = ""
        return label
    }()
    
    lazy var colorButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.gray
        return label
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.text = "Счетчик: 0".localized
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(colorButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(counterLabel)
    }
    
    func setupCell() {
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.cornerRadius = 10
        contentView.isUserInteractionEnabled = true
        contentView.clipsToBounds = true
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentView.heightAnchor.constraint(equalToConstant: 130),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 220),
            nameLabel.heightAnchor.constraint(equalToConstant: 21),
            
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1),
            timeLabel.widthAnchor.constraint(equalToConstant: 220),
            timeLabel.heightAnchor.constraint(equalToConstant: 21),
            
            
            colorButton.widthAnchor.constraint(equalToConstant: 38),
            colorButton.heightAnchor.constraint(equalToConstant: 38),
            colorButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 46),
            colorButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            counterLabel.widthAnchor.constraint(equalToConstant: 188),
            counterLabel.heightAnchor.constraint(equalToConstant: 18),
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
//MARK: - ACTIONS
    
    func update(with habit: Habit, progressCell: ProgressCollectionViewCell?) {
        self.habit = habit
        self.progressCell = progressCell
        
        nameLabel.text = habit.name
        timeLabel.text = habit.dateString
        dateLabel.text = habit.isAlreadyTakenToday ? "Сегодня выполнено".localized : "Еще не выполнено".localized
        colorButton.tintColor = habit.color
        nameLabel.textColor = habit.color
        
        if habit.isAlreadyTakenToday {
            colorButton.isSelected = true
        }
        
        let counter = habit.trackDates.count
        counterLabel.text = "\(NSLocalizedString("Counter", comment: "")): \(counter)"
    }
    
    @objc func colorButtonTapped() {
        colorButton.isSelected.toggle()
        
        if let habit = habit {
            HabitsStore.shared.track(habit)
            progressCell?.update()
        }
    }
}
