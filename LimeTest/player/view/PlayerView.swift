import UIKit
import AVFoundation

protocol PlayerViewDelegate: AnyObject {
    func backButtonTapped()
}

class PlayerView: UIView {
    
    private lazy var topGradientView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "TopBorder")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "LeftArrow"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var channelImageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var channelImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.textColor = UIColor.white
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var channelNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white.withAlphaComponent(0.8)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeLeftLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Settings"), for: .normal)
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var progressBar: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .white.withAlphaComponent(0.5)
        view.progress = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.isHidden = true
        tv.delegate = self
        tv.dataSource = self
        tv.layer.cornerRadius = 12
        tv.alwaysBounceVertical = false
        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
        tv.register(PlayerViewTableViewCell.self, forCellReuseIdentifier: "PlayerViewTableViewCell")
        tv.backgroundColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private var selectedVideoQuality: VideoQualityType = .auto
    
    private var timer: Timer?
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    weak var delegate: PlayerViewDelegate?
    
    func setupView() {
        setupSubviews()
        setupLayout()
    }
    
    private func setupSubviews() {
        addSubview(topGradientView)
        addSubview(backButton)
        addSubview(channelImageBackgroundView)
        addSubview(channelImageView)
        addSubview(descriptionLabel)
        addSubview(channelNameLabel)
        addSubview(timeLeftLabel)
        addSubview(settingsButton)
        addSubview(progressBar)
        addSubview(tableView)
    }
    
    private func setupLayout() {

        NSLayoutConstraint.activate([
            
            topGradientView.topAnchor.constraint(equalTo: topAnchor),
            topGradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topGradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topGradientView.heightAnchor.constraint(equalToConstant: 76),
            
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 32),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            
            channelImageBackgroundView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            channelImageBackgroundView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            channelImageBackgroundView.heightAnchor.constraint(equalToConstant: 44),
            channelImageBackgroundView.widthAnchor.constraint(equalToConstant: 44),
            
            channelImageView.centerXAnchor.constraint(equalTo: channelImageBackgroundView.centerXAnchor),
            channelImageView.centerYAnchor.constraint(equalTo: channelImageBackgroundView.centerYAnchor),
            channelImageView.heightAnchor.constraint(equalToConstant: 32),
            channelImageView.widthAnchor.constraint(equalToConstant: 32),
            
            descriptionLabel.topAnchor.constraint(equalTo: channelImageBackgroundView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: channelImageBackgroundView.trailingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            channelNameLabel.leadingAnchor.constraint(equalTo: channelImageBackgroundView.trailingAnchor, constant: 24),
            channelNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            channelNameLabel.bottomAnchor.constraint(equalTo: channelImageBackgroundView.bottomAnchor),
            
            timeLeftLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            timeLeftLabel.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor),
            timeLeftLabel.bottomAnchor.constraint(equalTo: progressBar.topAnchor, constant: -14),
            
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            settingsButton.bottomAnchor.constraint(equalTo: progressBar.topAnchor, constant: -10),
            settingsButton.heightAnchor.constraint(equalToConstant: 24),
            settingsButton.widthAnchor.constraint(equalToConstant: 24),
            
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            progressBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -29),
            
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: settingsButton.topAnchor, constant: -10),
            tableView.heightAnchor.constraint(equalToConstant: 200),
            tableView.widthAnchor.constraint(equalToConstant: 128),
        ])
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setProgress), userInfo: nil, repeats: true)

    }
    
    private func setupData(channel: Channel) {
        descriptionLabel.text = channel.current.title
        channelNameLabel.text = channel.name
        
        DispatchQueue.global().async { [weak self] in
            guard let url = URL(string: channel.image),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.channelImageView.image = image
            }
        }
        
        guard let url = URL(string: "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8") else { return }
        player = AVPlayer(url: url)
        player?.play()
        setupView()
    }
    
    init (channel: Channel) {
        super.init(frame: .zero)
        setupData(channel: channel)
    }
    
    @objc func setProgress() {
        guard let duration = player?.currentItem?.duration.seconds,
        let time = player?.currentItem?.currentTime().seconds,
        !duration.isNaN else { return }
        progressBar.progress = Float(time / duration)
        if (duration - time) / 60 > 1 {
            timeLeftLabel.text = "Осталось \(Int((duration - time) / 60)) минут"
        } else {
            timeLeftLabel.text = "Осталось \(Int(duration - time)) секунд"
        }
        if time >= duration {
            timer?.invalidate()
        }
    }

    @objc func backButtonTapped(sender: UIButton) {
        player = nil
        delegate?.backButtonTapped()
    }
    
    @objc func settingsButtonTapped(sender: UIButton) {
        self.tableView.isHidden = !self.tableView.isHidden
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Unsupported initializer, please use init()")
    }
}

extension PlayerView: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VideoQualityType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerViewTableViewCell", for: indexPath) as! PlayerViewTableViewCell
        let videoQuality = VideoQualityType.allCases[indexPath.row]
        cell.setup(videoQuality: videoQuality)
        if videoQuality == self.selectedVideoQuality {
            cell.isSelected()
        } else {
            cell.isNotSelected()
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension PlayerView: PlayerViewTableViewCellDelegate {
    func selectVideoQuality(videoQuality: VideoQualityType) {
        self.selectedVideoQuality = videoQuality
        self.tableView.reloadData()
    }
}
