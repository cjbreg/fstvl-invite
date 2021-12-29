//
//  InfoContent.swift
//  fstvlInvite
//
//  Created by Quan on 24/12/2021.
//

import SwiftUI

struct InfoContent: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 32))
                .frame(width: 56, height: 56)
                .foregroundColor(.yellow)
            
            Text("We recommend scanning your invite card in a well lit environment ")
                .multilineTextAlignment(.center)
            
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray, lineWidth: 2))
        .padding(.horizontal)
    }
}

struct InfoContent_Previews: PreviewProvider {
    static var previews: some View {
        InfoContent()
    }
}
