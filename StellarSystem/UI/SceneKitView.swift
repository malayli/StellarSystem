//
//  SceneKitView.swift
//  StellarSystem
//
//  Created by Malik, Alayli on 2019/10/21.
//  Copyright © 2019 Malik Alayli. All rights reserved.
//

import SwiftUI

struct SceneKitView : UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        guard let mainView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()?.view else {
            return UIView()
        }
        return mainView
    }

    func updateUIView(_ view: UIView, context: Context) {
    }
}
