//
//  TaskRowViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/26.
//

import Foundation

class TaskViewModel: ObservableObject {
    
    let tasks: [TaskModel] = [
        TaskModel(id: UUID(), title: "수학 기본 개념 정리", description: "수학 기본 개념을 정리하고 이해하여 수학 문제를 잘 풀 수 있도록 합니다.", participants: ["img_science_teacher", "img_math_teacher", "img_english_teacher"], progress: 0.6, startDate: Date(), endDate: Date().addingTimeInterval(60 * 60 * 24 * 7), pokeCounts: [:]),
        TaskModel(id: UUID(), title: "영어 단어 외우기", description: "영어 단어를 매일 외워서 어휘력을 향상시킵니다.", participants: ["img_math_teacher", "img_korean_teacher"], progress: 0.8, startDate: Date(), endDate: Date().addingTimeInterval(60 * 60 * 24 * 7), pokeCounts: [:]),
        TaskModel(id: UUID(), title: "물리 공식 정리", description: "물리 공식을 정리하여 물리 문제를 풀 때 참조할 수 있도록 합니다.", participants: ["img_korean_teacher", "img_math_teacher", "img_math_teacher"], progress: 0.2, startDate: Date(), endDate: Date().addingTimeInterval(60 * 60 * 24 * 7), pokeCounts: [:]),
        TaskModel(id: UUID(), title: "화학 실험 준비", description: "화학 실험을 위한 준비를 철저히 하여 실험 결과를 잘 분석할 수 있도록 합니다.", participants: ["img_english_teacher", "img_math_teacher", "img_english_teacher", "img_korean_teacher"], progress: 0.5, startDate: Date(), endDate: Date().addingTimeInterval(60 * 60 * 24 * 7), pokeCounts: [:]),
        TaskModel(id: UUID(), title: "토익 시험 준비", description: "토익 시험을 준비하여 영어 능력을 증명할 수 있는 점수를 얻습니다.", participants: ["img_math_teacher", "img_english_teacher", "img_korean_teacher"], progress: 0.7, startDate: Date(), endDate: Date().addingTimeInterval(60 * 60 * 24 * 7), pokeCounts: [:]),
        TaskModel(id: UUID(), title: "국어 문장 구조 분석", description: "국어 문장 구조를 분석하여 문장 해석 능력을 향상시킵니다.", participants: ["img_math_teacher", "img_english_teacher", "img_english_teacher"], progress: 0.4, startDate: Date(), endDate: Date().addingTimeInterval(60 * 60 * 24 * 7), pokeCounts: [:]),
        TaskModel(id: UUID(), title: "지구과학 기후 변화 조사", description: "지구과학에서 기후 변화에 대한 조사를 하여 환경에 대한 이해를 높입니다.", participants: ["img_math_teacher", "img_english_teacher"], progress: 0.5, startDate: Date(), endDate: Date().addingTimeInterval(60 * 60 * 24 * 7), pokeCounts: [:]),
        TaskModel(id: UUID(), title: "역사 인물 연구", description: "한국 역사의 주요 인물들에 대해 연구하고 그 업적을 정리합니다.", participants: ["img_math_teacher", "img_english_teacher", "img_korean_teacher"], progress: 0.3, startDate: Date(), endDate: Date().addingTimeInterval(60 * 60 * 24 * 7), pokeCounts: [:]),
        TaskModel(id: UUID(), title: "생활 속 수학 문제 만들기", description: "생활 속에서 발생할 수 있는 수학 문제를 만들어 풀어봅니다.", participants: ["img_math_teacher", "img_english_teacher", "img_math_teacher"], progress: 0.9, startDate: Date(), endDate: Date().addingTimeInterval(60 * 60 * 24 * 7), pokeCounts: [:]),
    ]
}
