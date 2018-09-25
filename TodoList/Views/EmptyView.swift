import UIKit

final class EmptyView: UIView {

    static let nibView: EmptyView = buildNib()
    
    @IBOutlet var label: UILabel! {
        didSet {
            label.text = NSLocalizedString("It's all a big black nothing", comment: "")
            label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
            label.textColor = .black
        }
    }
    
    @IBOutlet var iconImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white
    }
}
