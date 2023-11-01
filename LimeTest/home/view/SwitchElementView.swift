import UIKit

class SwitchElementView: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Все"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var border: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor(red: 0, green: 0.47, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func isNotSelected() {
        label.textColor = .white.withAlphaComponent(0.5)
        border.isHidden = true
    }
    
    func isSelected() {
        label.textColor = .white
        border.isHidden = false
    }
    
    func setupView() {
        setupSubviews()
        setupLayout()
    }
    
    private func setupSubviews() {
        backgroundColor = .clear
        addSubview(label)
        addSubview(border)
    }
    
    private func setupLayout() {

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
            
            border.leadingAnchor.constraint(equalTo: leadingAnchor),
            border.trailingAnchor.constraint(equalTo: trailingAnchor),
            border.bottomAnchor.constraint(equalTo: bottomAnchor),
            border.heightAnchor.constraint(equalToConstant: 2),
        ])
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Unsupported initializer, please use init()")
    }

}
