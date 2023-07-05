import UIKit

class MainScreenViewController: UIViewController {
    
    var logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "logo")
        logo.layer.cornerRadius = 20
        logo.clipsToBounds = true
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    var myHabitsLabel: UILabel = {
        let label = UILabel()
        label.text = "MyHabits"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openTabBarControllerAfterDelay()
    }
    
    func openTabBarControllerAfterDelay() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            
            let habitsVC = HabitsViewController()
            let infoVC = InfoViewController()
            
            let habitsNav = UINavigationController(rootViewController: habitsVC)
            let habitsImage = UIImage(systemName: "rectangle.grid.1x2.fill")
            let habitsSelectedImage = UIImage(systemName: "rectangle.grid.1x2.fill")?.withTintColor(UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0), renderingMode: .alwaysOriginal)
            habitsNav.tabBarItem = UITabBarItem(title: "Привычки", image: habitsImage, selectedImage: habitsSelectedImage)
            habitsNav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)], for: .selected)
            
            let infoNav = UINavigationController(rootViewController: infoVC)
            let infoImage = UIImage(systemName: "info.circle.fill")
            let infoSelectedImage = UIImage(systemName: "info.circle.fill")?.withTintColor(UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0), renderingMode: .alwaysOriginal)
            infoNav.tabBarItem = UITabBarItem(title: "Информация", image: infoImage, selectedImage: infoSelectedImage)
            infoNav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)], for: .selected)
            
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [habitsNav, infoNav]
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = tabBarController
                window.makeKeyAndVisible()
            }
        }
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(logoImageView)
        view.addSubview(myHabitsLabel)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
            
            myHabitsLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
            myHabitsLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
}

