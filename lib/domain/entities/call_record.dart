import 'package:equatable/equatable.dart';

/// 통화 타입
enum CallType {
  incoming, // 수신
  outgoing, // 발신
  missed, // 부재중
}

/// 통화 기록 엔티티
class CallRecord extends Equatable {
  final String id;
  final String contactId;
  final DateTime startTime;
  final DateTime? endTime;
  final Duration? duration;
  final CallType type;
  final String? audioFileUrl; // 녹음 파일
  final String? transcript; // 텍스트 변환 결과
  final CallAnalysis? analysis; // AI 분석 결과

  const CallRecord({
    required this.id,
    required this.contactId,
    required this.startTime,
    this.endTime,
    this.duration,
    required this.type,
    this.audioFileUrl,
    this.transcript,
    this.analysis,
  });

  @override
  List<Object?> get props => [
        id,
        contactId,
        startTime,
        endTime,
        duration,
        type,
        audioFileUrl,
        transcript,
        analysis,
      ];
}

/// 통화 분석 결과
class CallAnalysis extends Equatable {
  final String summary;
  final List<String> keyPoints;
  final String sentiment; // positive, neutral, negative
  final List<String> actionItems; // 할 일 목록
  final DateTime analyzedAt;

  const CallAnalysis({
    required this.summary,
    required this.keyPoints,
    required this.sentiment,
    required this.actionItems,
    required this.analyzedAt,
  });

  @override
  List<Object?> get props => [
        summary,
        keyPoints,
        sentiment,
        actionItems,
        analyzedAt,
      ];
}

