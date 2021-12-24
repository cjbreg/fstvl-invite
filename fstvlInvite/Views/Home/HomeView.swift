//
//  HomeView.swift
//  fstvlInvite
//
//  Created by Quan on 24/12/2021.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack() {
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            Text("Slamstox AR").font(.largeTitle)
            
            Spacer()
            
            InfoContent().padding(.horizontal)
            
            Spacer()
            
            NavigationButton()
            
            
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
            
    }
}
