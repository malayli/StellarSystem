//
//  MainView.swift
//  StellarSystem
//
//  Created by Malik, Alayli on 2019/10/21.
//  Copyright © 2019 Malik Alayli. All rights reserved.
//

import SwiftUI

struct MainView: View {
    private let sceneKitView = SceneKitView()
    
    var body: some View {
        sceneKitView
        .overlay(
            VStack {
                Spacer()
                HStack {
                    MotionButton(completion: pause)
                        .buttonStyle(MotionButtonStyle())
                        .padding(16)
                    Spacer()
                }
            }
        )
        .overlay(
            VStack(alignment: .center) {
                Spacer()
                Text("Stellar System")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(16)
            }
        ).edgesIgnoringSafeArea(.all)
    }
    
    func pause() {
        sceneKitView.pause()
    }
}
