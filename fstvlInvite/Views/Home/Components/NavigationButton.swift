//
//  Navigation button.swift
//  fstvlInvite
//
//  Created by Quan on 24/12/2021.
//

import SwiftUI

struct NavigationButton: View {
    var body: some View {
        NavigationLink(destination: ARCameraView()){
            VStack {
                Image(systemName: "camera")
                    .font(.system(size: 32))
                    .frame(width: 56, height: 56)
                    .foregroundColor(.white)
                Text("Start scanning")
            }
        }
        .padding(.bottom, 40.0)
    }
}

struct Navigation_button_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButton()
    }
}
