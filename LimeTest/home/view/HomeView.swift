import UIKit

class HomeView : UIView {
    
    var searchView: SearchView = {
        let view = SearchView()
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor(red: 0.25, green: 0.26, blue: 0.28, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var switchView: SwitchView = {
        let view = SwitchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
 
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 15)
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.backgroundColor = UIColor(red: 0.14, green: 0.14, blue: 0.15, alpha: 1)
        cv.showsVerticalScrollIndicator = false
        cv.register(ChannelCollectionViewCell.self, forCellWithReuseIdentifier: "ChannelCollectionViewCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    func setupView() {
        backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.22, alpha: 1)
        setupSubviews()
        setupLayout()
        setupTapGesture()
    }

    private func setupSubviews() {
        addSubview(searchView)
        addSubview(switchView)
        addSubview(collectionView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            searchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            searchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            searchView.heightAnchor.constraint(equalToConstant: 48),
            
            switchView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            switchView.leadingAnchor.constraint(equalTo: leadingAnchor),

            collectionView.topAnchor.constraint(equalTo: switchView.bottomAnchor, constant: 6),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
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
