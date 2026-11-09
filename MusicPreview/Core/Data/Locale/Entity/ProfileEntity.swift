//
//  ProfileEntity.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 09/11/26.
//

import Foundation

struct ProfileEntity: Codable, Equatable {
    var displayName: String
    var bio: String
    var avatarFileName: String?
}
