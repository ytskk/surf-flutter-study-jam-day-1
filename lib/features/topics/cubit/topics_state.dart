part of 'topics_cubit.dart';

abstract class TopicsState extends Equatable {
  const TopicsState();

  @override
  List<Object> get props => [];
}

class TopicsInitial extends TopicsState {
  @override
  List<Object> get props => [];
}

class TopicsLoadInProgress extends TopicsState {}

class TopicsLoadSuccess extends TopicsState {
  const TopicsLoadSuccess({required this.topics});

  final List<ChatTopicDto> topics;

  @override
  List<Object> get props => [topics];
}

class TopicsLoadFailure extends TopicsState {
  const TopicsLoadFailure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
