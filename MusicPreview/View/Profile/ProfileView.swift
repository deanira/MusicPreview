//
//  ProfileView.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 07/11/26.
//

import SwiftUI

struct ProfileView: View {
  @StateObject var viewModel: ProfileViewModel = ProfileViewModel(profileUseCase: Injection.sharedInstance.provideProfileUseCase())

  @State private var isEditing = false
  @State private var draftName = ""
  @State private var draftBio = ""

  private var canSave: Bool {
    !draftName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  var body: some View {
    Group {
      if isEditing {
        editForm
      } else {
        profileInfo
      }
    }
    .navigationTitle("Profile")
    .navigationBarBackButtonHidden(isEditing)
    .toolbar {
      if isEditing {
        ToolbarItem(placement: .topBarLeading) {
          Button("Cancel") {
            withAnimation(.easeInOut(duration: 0.3)) {
              isEditing = false
            }
          }
        }
      }
      ToolbarItem(placement: .topBarTrailing) {
        Button(action: toolbarTapped) {
          Image(systemName: isEditing ? "checkmark" : "pencil.line")
            .foregroundStyle(.blue)
        }
        .disabled(isEditing && !canSave)
      }
    }
    .onAppear { viewModel.load() }
    .alert("Something went wrong",
           isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
           )) {
             Button("OK", role: .cancel) {}
           } message: {
             Text(viewModel.errorMessage ?? "")
           }
  }

  private var profileInfo: some View {
    VStack(alignment: .leading, spacing: 16) {
      if let profile = viewModel.profile {
        VStack(alignment: .leading, spacing: 4) {
          Text("Name")
            .font(.caption)
            .foregroundStyle(.secondary)
          Text(profile.displayName)
            .font(.title2.bold())
        }
        VStack(alignment: .leading, spacing: 4) {
          Text("Bio")
            .font(.caption)
            .foregroundStyle(.secondary)
          Text(profile.bio.isEmpty ? "-" : profile.bio)
        }
        Spacer()
      } else {
        ContentUnavailableView(
          "No profile info yet",
          systemImage: "person.crop.circle.badge.plus",
          description: Text("Tap the pencil icon to fill in your profile.")
        )
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
  }

  private var editForm: some View {
    Form {
      Section("Name") {
        TextField("Display name", text: $draftName)
          .textInputAutocapitalization(.words)
      }
      Section("Bio") {
        TextField("Tell us about yourself", text: $draftBio, axis: .vertical)
          .lineLimit(3...6)
      }
    }
  }

  // MARK: - Actions
  private func toolbarTapped() {
    if isEditing {
      let updated = ProfileEntity(
        displayName: draftName.trimmingCharacters(in: .whitespacesAndNewlines),
        bio: draftBio.trimmingCharacters(in: .whitespacesAndNewlines),
        avatarFileName: viewModel.profile?.avatarFileName
      )
      viewModel.save(updated) {
        withAnimation(.easeInOut(duration: 0.3)) {
          isEditing = false
        }
      }
    } else {
      draftName = viewModel.profile?.displayName ?? ""
      draftBio = viewModel.profile?.bio ?? ""
      withAnimation(.easeInOut(duration: 0.3)) {
        isEditing = true
      }
    }
  }
}
