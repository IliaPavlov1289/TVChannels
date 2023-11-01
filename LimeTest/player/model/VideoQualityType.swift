enum VideoQualityType: CaseIterable {
    case hight, medium, low, easy, auto
    
    var description : String {
        switch self {
        case .hight: return "1080p"
        case .medium: return "720p"
        case .low: return "480p"
        case .easy: return "360p"
        case .auto: return "AUTO"
        }
    }
}
