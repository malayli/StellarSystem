//
//  MainView.swift
//  StellarSystem
//
//  Created by Malik, Alayli on 2019/10/21.
//  Copyright © 2019 Malik Alayli. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        SceneKitView().overlay(
            VStack {
                Spacer()
                Text("Stellar System")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(16)
            }
        ).edgesIgnoringSafeArea(.all)
    }
}
