//
//  FocusTimerModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/23.
//

import Foundation

class FocusTimerModel: TimerModel {
    override init(id: Int64?, userId: Int64?, seq: Int, type: String?, name: String) {
        super.init(id: id, userId: userId, seq: seq, type: type, name: name)
    }
    
    static func toDTO(model: FocusTimerModel) -> FocusTimerDTO {
        return FocusTimerDTO(id: model.id, userId: model.userId, seq: model.seq, type: model.type, name: model.name)
    }
    
    static func from(dto: FocusTimerDTO) -> FocusTimerModel {
        return FocusTimerModel(id: dto.id, userId: dto.userId, seq: dto.seq, type: dto.type, name: dto.name)
    }
}
