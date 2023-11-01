import UIKit

class HomeViewController: UIViewController {
    
    lazy var mainView: HomeView = {
        let view = HomeView()
        view.collectionView.dataSource = self
        view.collectionView.delegate = self
        view.searchView.delegate = self
        view.switchView.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var networcManager = NetworkManager()
    
    private lazy var searchText: String? = nil
    
    private lazy var allChannels: [Channel] = []
    
    private lazy var favouritesChannels: [Channel] = Defaults.favourites.value ?? [] {
        didSet {
            Defaults.favourites.value = favouritesChannels
        }
    }
    
    private lazy var resultChannels: [Channel] = [] {
        didSet {
            mainView.collectionView.reloadData()
        }
    }
    
    var isSelectedAll = true

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupView()
        getChannels()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    private func getChannels() {
        networcManager.getChannels() { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let channels):
                    self?.allChannels = channels.channels
                    self?.resultChannels = channels.channels
                case .failure(let error): print(error.localizedDescription)
                }
            }
        }
    }

    func setResultChannels() {
        let channels = isSelectedAll ? allChannels : favouritesChannels
        if let searchText = searchText, searchText != "" {
            resultChannels = channels.filter({ $0.name.contains(searchText)})
        } else {
            resultChannels = channels
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        resultChannels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCollectionViewCell", for: indexPath) as! ChannelCollectionViewCell
        let channel = resultChannels[indexPath.row]
        if let _ = favouritesChannels.filter({ $0.id == channel.id }).first {
            cell.isFavourite = true
        } else {
            cell.isFavourite = false
        }
        cell.setup(channel: channel)
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = UIScreen.main.bounds.width - 31
        let cellHight = CGFloat(76)
        return CGSize(width: cellWidth , height: cellHight)
    }
}

extension HomeViewController: SearchViewDelegate {
    func searchTextFieldDidChange(searchText: String?) {
        self.searchText = searchText
        setResultChannels()
    }
}

extension HomeViewController: SwitchViewDelegate {
    func switchTapped(isSelectedAll: Bool) {
        self.isSelectedAll = isSelectedAll
        setResultChannels()
    }
}

extension HomeViewController: ChannelCollectionViewCellDelegate {
    func favouriteButtonTapped(channel: Channel, isFavourite: Bool) {
        if isFavourite {
            self.favouritesChannels.append(channel)
        } else {
            let newFavouritesChannels = favouritesChannels.filter({ $0.id != channel.id })
            favouritesChannels = newFavouritesChannels
        }
    }
    
    func channelTapped(channel: Channel) {
        mainView.searchView.searchTextField.resignFirstResponder()
        let vc = PlayerViewController(channel: channel)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

