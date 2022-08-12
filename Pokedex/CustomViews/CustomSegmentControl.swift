import UIKit

class CustomSegmentControl: UISegmentedControl {
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        let segmentStringSelected: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0),
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        let segmentStringHighlited: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0),
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0.5694641471, blue: 1, alpha: 1)
        ]
        
        setTitleTextAttributes(segmentStringHighlited, for: .normal)
        setTitleTextAttributes(segmentStringSelected, for: .selected)
        setTitleTextAttributes(segmentStringHighlited, for: .highlighted)
        
        layer.masksToBounds = true
        selectedSegmentTintColor = .clear
        
        //corner radius
        let cornerRadius = bounds.height / 2
        let maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = maskedCorners
        
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex),
           let foregroundImageView = subviews[foregroundIndex] as? UIImageView {
            foregroundImageView.image = UIImage()
            foregroundImageView.clipsToBounds = true
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.backgroundColor = #colorLiteral(red: 0, green: 0.5694641471, blue: 1, alpha: 1)
            
            foregroundImageView.layer.cornerRadius = bounds.height / 2 + 4
            foregroundImageView.layer.maskedCorners = maskedCorners
        }
        
        for i in 0...(self.numberOfSegments-1)  {
            let backgroundSegmentView = subviews[i]
            //it is not enogh changing the background color. It has some kind of shadow layer
            backgroundSegmentView.isHidden = true
        }
    }
}

extension UIImage {
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.init(data: image.pngData()!)!
    }
}
