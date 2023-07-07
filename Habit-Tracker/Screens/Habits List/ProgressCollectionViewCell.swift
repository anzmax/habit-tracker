import UIKit

final class ProgressCollectionViewCell: UICollectionViewCell {
    
    private var habitsStore = HabitsStore.shared
    
    static let id = "ProgressCollectionViewCell"
    
    let progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Все получится!"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    private let progressView: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.trackTintColor = .lightGray
        view.progressTintColor = .systemPurple
        return view
    }()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.text = ""
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
        contentView.addSubview(progressLabel)
        contentView.addSubview(progressView)
        contentView.addSubview(percentageLabel)
    }
    
    func setupCell() {
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentView.heightAnchor.constraint(equalToConstant: 60),
            
            progressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            progressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            progressLabel.widthAnchor.constraint(equalToConstant: 216),
            progressLabel.heightAnchor.constraint(equalToConstant: 18),
            
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            progressView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 38),
            progressView.heightAnchor.constraint(equalToConstant: 7),
            
            percentageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            percentageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            percentageLabel.widthAnchor.constraint(equalToConstant: 95),
            percentageLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
//MARK: - ACTIONS
    
    public func update() {
        progressView.progress = habitsStore.todayProgress
        percentageLabel.text = "\(habitsStore.todayProgress * 100)%"
    }
}


