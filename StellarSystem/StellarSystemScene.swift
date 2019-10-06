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
        
        // Sun-group
        
        let sunGroupNode = SCNNode()
        sunGroupNode.castsShadow = false
        sunGroupNode.position = SCNVector3Make(0, 0, 0)
        contentNode.addChildNode(sunGroupNode)
        
        sunGroupNode.addChildNode(SunLightNode(angle: -Float(Double.pi/2)))
        sunGroupNode.addChildNode(SunLightNode(angle: -Float(Double.pi/4)))
        sunGroupNode.addChildNode(SunLightNode(angle: -Float(Double.pi/8)))
        sunGroupNode.addChildNode(SunLightNode(angle: 0))
        
        let sunNode = SphereNode("sun", radius: 1.5, lightningModel: .constant, duration: 20.0)
        sunGroupNode.addChildNode(sunNode)
        
        // Mercury-group (will contain the Earth, and the Moon)
        let mercuryRotationNode = planetRotationNode()
        let mercuryGroupNode = planetGroupNode(sphereNode: SphereNode("mercury", radius: 0.4), position: SCNVector3Make(3, 0, 0))
        mercuryRotationNode.addChildNode(mercuryGroupNode)
        sunGroupNode.addChildNode(mercuryRotationNode)
        
        // Venus-group (will contain the Earth, and the Moon)
        let venusRotationNode = planetRotationNode(angle: Float(Double.pi/8))
        let venusGroupNode = planetGroupNode(sphereNode: SphereNode("venus", radius: 0.9), position: SCNVector3Make(6, 0, 0))
        venusRotationNode.addChildNode(venusGroupNode)
        sunGroupNode.addChildNode(venusRotationNode)
        
        // Earth-group (will contain the Earth, and the Moon)
        let earthRotationNode = planetRotationNode(angle: Float(Double.pi/4))
        let earthGroupNode = planetGroupNode(sphereNode: SphereNode("earth", castsShadow: true, radius: 1.0), position: SCNVector3Make(10, 0, 0))
        let moonNode = SatelliteNode("moon")
        earthGroupNode.addChildNode(satelliteRotationNode(satelliteNode: moonNode))
        earthRotationNode.addChildNode(earthGroupNode)
        sunGroupNode.addChildNode(earthRotationNode)
        
        // Mars-group (will contain the Earth, and the Moon)
        let marsRotationNode = planetRotationNode(angle: Float(Double.pi/2))
        let marsGroupNode = planetGroupNode(sphereNode: SphereNode("mars", radius: 0.8), position: SCNVector3Make(16, 0, 0))
        marsRotationNode.addChildNode(marsGroupNode)
        sunGroupNode.addChildNode(marsRotationNode)
    }
}

private final class SunLightNode: SCNNode {
    convenience init(angle: Float) {
        self.init()
        castsShadow = false
        light = SCNLight()
        light?.castsShadow = true
        light?.type = .spot
        light?.color = UIColor.white
        light?.spotInnerAngle = 0
        light?.spotOuterAngle = 90
        position = SCNVector3(0, 0, 0)
        orientation = SCNQuaternion(0, 0, 0, 0)
        addAnimation(duration: 20.0, from: NSValue(scnVector4: SCNVector4Make(0, 1, 0, angle)), to: NSValue(scnVector4: SCNVector4Make(0, 1, 0, angle + Float(Double.pi) * 2.0)), key: "sun light rotation")
    }
}

private final class SphereNode: SCNNode {
    convenience init(_ imageName: String,
    castsShadow: Bool = false,
    radius: CGFloat,
    lightningModel: SCNMaterial.LightingModel = .lambert,
    duration: CFTimeInterval = 4.0) {
        self.init()
        geometry = SCNSphere(radius: radius)
        geometry?.firstMaterial?.diffuse.contents = UIImage(named: imageName)
        self.castsShadow = castsShadow
        position = SCNVector3Make(0, 0, 0)
        geometry?.firstMaterial?.lightingModel = lightningModel
        addAnimation(duration: duration, from: NSValue(scnVector4: SCNVector4Make(0, 1, 0, 0)), to: NSValue(scnVector4: SCNVector4Make(0, 1, 0, Float(Double.pi) * 2.0)), key: "sphere \(imageName) rotation")
    }
}

private final class SatelliteNode: SCNNode {
    convenience init(_ imageName: String) {
        self.init()
        geometry = SCNSphere(radius: 0.5)
        geometry?.firstMaterial?.diffuse.contents = UIImage(named: imageName)
        castsShadow = true
        position = SCNVector3Make(2, 0, 0)
        geometry?.firstMaterial?.lightingModel = .lambert
        addAnimation(duration: 4.0, from: NSValue(scnVector4: SCNVector4Make(0, 1, 0, 0)), to: NSValue(scnVector4: SCNVector4Make(0, 1, 0, Float(Double.pi) * 2.0)), key: "satellite rotation")
    }
}

private extension StellarSystemScene {
    private func planetGroupNode(sphereNode: SCNNode, position: SCNVector3) -> SCNNode {
        let planetGroupNode = SCNNode()
        planetGroupNode.castsShadow = false
        planetGroupNode.position = position
        planetGroupNode.addChildNode(sphereNode)
        return planetGroupNode
    }
    
    private func planetRotationNode(angle: Float = 0.0) -> SCNNode {
        let planetRotationNode = SCNNode()
        planetRotationNode.castsShadow = false
        planetRotationNode.position = SCNVector3(0, 0, 0)
        planetRotationNode.addAnimation(duration: 20, from: NSValue(scnVector4: SCNVector4Make(0, 2, 1, angle)), to: NSValue(scnVector4: SCNVector4Make(0, 2, 1, angle + Float(Double.pi) * 2.0)), key: "planet rotation around the sun")
        return planetRotationNode
    }
}

private extension StellarSystemScene {
    private func satelliteRotationNode(satelliteNode: SCNNode) -> SCNNode {
        // Moon-rotation (center of rotation of the Moon around the Earth)
        let satelliteRotationNode = SCNNode()
        satelliteRotationNode.castsShadow = false
        satelliteRotationNode.addChildNode(satelliteNode)
        // Rotate the satellite around the earth
        satelliteRotationNode.addAnimation(duration: 20.0, from: NSValue(scnVector4: SCNVector4Make(0, 2, 1, 0)), to: NSValue(scnVector4: SCNVector4Make(0, 2, 1, Float(Double.pi) * 2.0)), key: "satellite rotation around earth")
        return satelliteRotationNode
    }
}

private extension StellarSystemScene {
    private func borgNode(position p: SCNVector3) -> SCNNode {
        let node = SCNNode()
        node.position = p
        node.geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        
        if let noiseImage = UIImage(named: "noise") {
            node.geometry?.firstMaterial?.setValue(SCNMaterialProperty(contents: noiseImage), forKey: "noiseTexture")
        }
        
        node.geometry?.firstMaterial?.shaderModifiers = [.fragment: appearingFragmentShader]
        
        let revealAnimation = CABasicAnimation(keyPath: "revealage")
        revealAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        revealAnimation.beginTime = CACurrentMediaTime() + 5
        revealAnimation.duration = 2.5
        revealAnimation.fromValue = 0.0
        revealAnimation.toValue = 1.0
        revealAnimation.fillMode = .forwards
        revealAnimation.isRemovedOnCompletion = false
        
        let scnRevealAnimation = SCNAnimation(caAnimation: revealAnimation)
        node.geometry?.firstMaterial?.addAnimation(scnRevealAnimation, forKey: "Reveal")
        
        node.castsShadow = false
        node.geometry?.firstMaterial?.lightingModel = .constant
        node.addAnimation(duration: 20.0, from: NSValue(scnVector4: SCNVector4Make(0, 1, 0, 0)), to: NSValue(scnVector4: SCNVector4Make(0, 1, 0, Float(Double.pi) * 2.0)), key: "borg rotation")
        return node
    }
}

private extension SCNNode {
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
