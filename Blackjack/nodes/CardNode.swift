import Foundation
import SceneKit
import UIKit
import CardsBase

class CardNode: SCNNode {
    
    private let cardWidth: CGFloat = 209
    private let cardHeight: CGFloat = 325
    private let padding: CGFloat = 20
    private let faceMaterial: SCNMaterial = SCNMaterial()
    
    override init() {
        super.init()
        
        let pX: Float = Float(padding/cardWidth)
        let pY: Float = Float(padding/cardHeight)
    
        var m = SCNMatrix4MakeScale(1 + pX, 1 + pY, 0)
        m = SCNMatrix4Translate(m, -pX/2, -pY/2, 0)
        
        let whiteMaterial = SCNMaterial()
        whiteMaterial.diffuse.contents = UIColor.white
        
        let shirtMaterial = SCNMaterial()
        let shirtImage = UIImage(named: "shirt.png")
        shirtMaterial.diffuse.contents = shirtImage
        shirtMaterial.diffuse.contentsTransform = m
        
        faceMaterial.diffuse.contents = UIImage(named: "diamonds_ace.png")
        faceMaterial.diffuse.contentsTransform = m
        
        let w = cardWidth
        let h = cardHeight
        
        let shape = SCNShape()
        shape.path = UIBezierPath(roundedRect: CGRect(x: -w/2, y: -h/2, width: w, height:h), byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width:8, height:8))
        shape.extrusionDepth = 1
        shape.chamferMode = SCNChamferMode.both
        shape.materials = [
            faceMaterial,
            shirtMaterial,
            whiteMaterial
        ]
        self.geometry = shape
    }
    func setFace(_ name: String) {
        self.faceMaterial.diffuse.contents = UIImage(named: name)
    }
    func setRandom() {
        self.faceMaterial.diffuse.contents = UIImage(named: Card(Rank.random(), Suit.random()).imageNamed)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("!")
    }
}
