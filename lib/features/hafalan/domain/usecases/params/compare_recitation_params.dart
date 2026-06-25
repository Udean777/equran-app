import 'package:equatable/equatable.dart';

class CompareRecitationParams extends Equatable {
  const CompareRecitationParams({
    required this.audioFilePath,
    required this.targetText,
    this.threshold = 75.0,
  });

  final String audioFilePath;
  final String targetText;
  final double threshold;

  @override
  List<Object?> get props => [audioFilePath, targetText, threshold];
}
