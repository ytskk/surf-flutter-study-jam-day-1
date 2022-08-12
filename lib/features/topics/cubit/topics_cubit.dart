import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_dto.dart';
import 'package:surf_practice_chat_flutter/features/topics/repository/chat_topics_repository.dart';

part 'topics_state.dart';

class TopicsCubit extends Cubit<TopicsState> {
  TopicsCubit(this._chatTopicsRepository) : super(TopicsInitial());

  final IChatTopicsRepository _chatTopicsRepository;

  Future<void> getTopics() async {
    emit(TopicsLoadInProgress());

    final response = await _chatTopicsRepository.getTopics(
      topicsStartDate: DateTime.now().subtract(
        const Duration(days: 10),
      ),
    );

    final List<ChatTopicDto> topics = response.toList();

    emit(TopicsLoadSuccess(topics: topics));
  }
}
