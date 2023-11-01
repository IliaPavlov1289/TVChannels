import UIKit

class PlayerViewController: UIViewController {

    lazy var mainView: PlayerView = {
        let view = PlayerView(channel: channel)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var channel: Channel

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }

    init(channel: Channel) {
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
