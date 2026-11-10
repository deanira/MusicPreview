//
//  ProfileMapper.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 10/11/26.
//

struct ProfileMapper {
  static func mapProfileEntitiesToDomains(input: ProfileEntity) -> ProfileModel {
    return ProfileModel(displayName: input.displayName, bio: input.bio, avatarFileName: input.avatarFileName)
  }

  static func mapProfileDomainToEntity(input: ProfileModel) -> ProfileEntity {
    return ProfileEntity(displayName: input.displayName, bio: input.bio, avatarFileName: input.avatarFileName)
  }
}
