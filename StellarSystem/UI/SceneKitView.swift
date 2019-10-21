//
//  SceneKitView.swift
//  StellarSystem
//
//  Created by Malik, Alayli on 2019/10/21.
//  Copyright © 2019 Malik Alayli. All rights reserved.
//

import SwiftUI
import SceneKit

struct SceneKitView {
    private let sceneView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()?.view as? SCNView
    
    func pause () {
        guard let scnView = sceneView, let scene = scnView.scene else {
            return
        }
        scene.isPaused = !scene.isPaused
    }
}

extension SceneKitView : UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        guard let mainView = sceneView else {
            return UIView()
        }
        return mainView
    }

    func updateUIView(_ view: UIView, context: Context) {
    }
}
