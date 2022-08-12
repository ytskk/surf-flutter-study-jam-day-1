part of 'new_topic_bloc.dart';

abstract class NewTopicEvent extends Equatable {
  const NewTopicEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends NewTopicEvent {
  const NameChanged({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class DescriptionChanged extends NewTopicEvent {
  const DescriptionChanged({required this.description});

  final String description;

  @override
  List<Object> get props => [description];
}

class NewTopicSubmitted extends NewTopicEvent {}
