//
//  ProfileView.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 07/11/26.
//

import SwiftUI

struct ProfileView: View {
  @StateObject var viewModel: ProfileViewModel = ProfileViewModel(profileUseCase: Injection.sharedInstance.provideProfileUseCase())

  var body: some View {
    VStack {

    }
    .navigationTitle("Profile")
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Image(systemName: "pencil.line")
          .foregroundStyle(.blue)
      }
    }
  }
}
