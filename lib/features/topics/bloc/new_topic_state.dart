part of 'new_topic_bloc.dart';

class NewTopicState extends Equatable {
  const NewTopicState({
    this.status = FormzStatus.pure,
    this.name = const Name.pure(),
    this.description = const Description.pure(),
    this.newTopic,
  });

  final FormzStatus status;
  final Name name;
  final Description description;
  final ChatTopicDto? newTopic;

  NewTopicState copyWith({
    FormzStatus? status,
    Name? name,
    Description? description,
    ChatTopicDto? newTopic,
  }) {
    return NewTopicState(
      status: status ?? this.status,
      name: name ?? this.name,
      description: description ?? this.description,
      newTopic: newTopic ?? this.newTopic,
    );
  }

  @override
  List<Object?> get props => [
        status,
        name,
        description,
        newTopic,
      ];
}
