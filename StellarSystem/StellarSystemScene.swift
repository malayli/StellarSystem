import SceneKit

final class StellarSystemScene: SCNScene {
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init () {
        super.init()
        
        rootNode.castsShadow = false
        
        // Content Node
        let contentNode = SCNNode()
        contentNode.castsShadow = false
        rootNode.addChildNode(contentNode)
        
        // Earth-group (will contain the Earth, and the Moon)
        let _earthGroupNode = earthGroupNode(earthNode: earthNode)
        _earthGroupNode.addChildNode(moonRotationNode())
        contentNode.addChildNode(_earthGroupNode)
        
        //Earth-rotation (center of rotation of the Earth around the Sun)
        let _earthRotationNode = earthRotationNode(earthGroupNode: _earthGroupNode)
        
        // Sun-group
        
        let sunGroupNode = SCNNode()
        sunGroupNode.castsShadow = false
        sunGroupNode.position = SCNVector3Make(0, 0, 0)
        sunGroupNode.addChildNode(sunNode)
        sunGroupNode.addChildNode(sunLightNode(eulerAngles: SCNVector3Make(0, -Float(Double.pi/2), 0)))
        sunGroupNode.addChildNode(_earthRotationNode)
        contentNode.addChildNode(sunGroupNode)
    }
}

private extension StellarSystemScene {
    private var sunNode: SCNNode {
        let sunNode = SCNNode(radius: 1.5, imageName: "sun")
        sunNode.castsShadow = false
        sunNode.geometry?.firstMaterial?.lightingModel = .constant
        sunNode.addAnimation(duration: 20.0, from: NSValue(scnVector4: SCNVector4Make(0, 1, 0, 0)), to: NSValue(scnVector4: SCNVector4Make(0, 1, 0, Float(Double.pi) * 2.0)), key: "sun rotation")
        return sunNode
    }
    
    private func sunLightNode(eulerAngles: SCNVector3) -> SCNNode {
        let sunLightNode = SCNNode()
        sunLightNode.castsShadow = false
        sunLightNode.light = SCNLight()
        sunLightNode.light?.castsShadow = true
        sunLightNode.light?.type = .spot
        sunLightNode.light?.color = UIColor.white
        sunLightNode.light?.spotInnerAngle = 0
        sunLightNode.light?.spotOuterAngle = 90
        sunLightNode.position = SCNVector3(0, 0, 0)
        sunLightNode.orientation = SCNQuaternion(0, 0, 0, 0)
        
        sunLightNode.addAnimation(duration: 20.0, from: NSValue(scnVector4: SCNVector4Make(0, 1, 0, -Float(Double.pi/2))), to: NSValue(scnVector4: SCNVector4Make(0, 1, 0, -Float(Double.pi/2) + Float(Double.pi) * 2.0)), key: "sun rotation")
        return sunLightNode
    }
}

private extension StellarSystemScene {
    private var earthNode: SCNNode {
        let earthNode = SCNNode(radius: 1.0, imageName: "earth")
        earthNode.castsShadow = true
        earthNode.position = SCNVector3Make(0, 0, 0)
        earthNode.geometry?.firstMaterial?.lightingModel = .lambert
        earthNode.addAnimation(duration: 4.0, from: NSValue(scnVector4: SCNVector4Make(0, 1, 0, 0)), to: NSValue(scnVector4: SCNVector4Make(0, 1, 0, Float(Double.pi) * 2.0)), key: "earth rotation")
        return earthNode
    }
    
    private func earthGroupNode(earthNode: SCNNode) -> SCNNode {
        let earthGroupNode = SCNNode()
        earthGroupNode.castsShadow = false
        earthGroupNode.position = SCNVector3Make(5, 0, 0)
        earthGroupNode.addChildNode(earthNode)
        return earthGroupNode
    }
    
    private func earthRotationNode(earthGroupNode: SCNNode) -> SCNNode {
        let earthRotationNode = SCNNode()
        earthRotationNode.castsShadow = false
        earthRotationNode.addChildNode(earthGroupNode)
        
        earthRotationNode.position = SCNVector3(0, 0, 0)
        
        // Rotate the Earth around the Sun
        earthRotationNode.addAnimation(duration: 20, from: NSValue(scnVector4: SCNVector4Make(0, 2, 1, 0)), to: NSValue(scnVector4: SCNVector4Make(0, 2, 1, Float(Double.pi) * 2.0)), key: "earth rotation around the sun")
        
        return earthRotationNode
    }
}

private extension StellarSystemScene {
    private var moonNode: SCNNode {
        let moonNode = SCNNode(radius: 0.5, imageName: "moon")
        moonNode.castsShadow = true
        moonNode.position = SCNVector3Make(2, 0, 0)
        moonNode.geometry?.firstMaterial?.lightingModel = .lambert
        moonNode.addAnimation(duration: 4.0, from: NSValue(scnVector4: SCNVector4Make(0, 1, 0, 0)), to: NSValue(scnVector4: SCNVector4Make(0, 1, 0, Float(Double.pi) * 2.0)), key: "moon rotation")
        return moonNode
    }
    
    private func moonRotationNode() -> SCNNode {
        // Moon-rotation (center of rotation of the Moon around the Earth)
        let moonRotationNode = SCNNode()
        moonRotationNode.castsShadow = false
        moonRotationNode.addChildNode(moonNode)
        // Rotate the moon around the earth
        moonRotationNode.addAnimation(duration: 20.0, from: NSValue(scnVector4: SCNVector4Make(0, 2, 1, 0)), to: NSValue(scnVector4: SCNVector4Make(0, 2, 1, Float(Double.pi) * 2.0)), key: "moon rotation around earth")
        
        return moonRotationNode
    }
}

private extension SCNNode {
    convenience init(radius: CGFloat, imageName: String) {
        self.init()
        geometry = SCNSphere(radius: radius)
        geometry?.firstMaterial?.diffuse.contents = UIImage(named: imageName)
    }
    
    func addAnimation(beginTime: CFTimeInterval = 0.0, duration: CFTimeInterval, from: NSValue, to: NSValue, key: String) {
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.beginTime = beginTime
        animation.duration = duration
        animation.fromValue = from
        animation.toValue = to
        animation.repeatCount = .greatestFiniteMagnitude
        addAnimation(animation, forKey: key)
    }
}
