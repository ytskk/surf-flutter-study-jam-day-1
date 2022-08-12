import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_dto.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_send_dto.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/new_topic_description.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/new_topic_name.dart';
import 'package:surf_practice_chat_flutter/features/topics/repository/chat_topics_repository.dart';

part 'new_topic_event.dart';
part 'new_topic_state.dart';

class NewTopicBloc extends Bloc<NewTopicEvent, NewTopicState> {
  NewTopicBloc(this._chatTopicsRepository) : super(const NewTopicState()) {
    on<NameChanged>(_onNameChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<NewTopicSubmitted>(_onNewTopicSubmitted);
  }

  final IChatTopicsRepository _chatTopicsRepository;

  void _onNameChanged(NameChanged event, Emitter<NewTopicState> emit) {
    final Name name = Name.dirty(event.name);

    emit(
      state.copyWith(
        name: name,
        status: Formz.validate([
          name,
          state.description,
        ]),
      ),
    );
  }

  void _onDescriptionChanged(
      DescriptionChanged event, Emitter<NewTopicState> emit) {
    final Description description = Description.dirty(event.description);

    emit(
      state.copyWith(
        description: description,
        status: Formz.validate([
          state.name,
          description,
        ]),
      ),
    );
  }

  Future<void> _onNewTopicSubmitted(
    NewTopicSubmitted event,
    Emitter<NewTopicState> emit,
  ) async {
    log('form');
    if (state.status.isValidated) {
      log('validated');
      emit(
        state.copyWith(
          status: FormzStatus.submissionInProgress,
        ),
      );
      try {
        final ChatTopicSendDto newTopic = ChatTopicSendDto(
          name: state.name.value,
          description: state.description.value,
        );
        final response = await _chatTopicsRepository.createTopic(
          newTopic,
        );
        log('response: $response');
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            newTopic: response,
          ),
        );
      } catch (e) {
        print(e);
        emit(
          state.copyWith(
            status: FormzStatus.submissionFailure,
          ),
        );
      }
    }
  }
}
