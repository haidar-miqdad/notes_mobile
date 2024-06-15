import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes_app/data/model/response/all_notes_model.dart';

import '../../../data/datasources/note_remote_datasource.dart';

part 'all_notes_event.dart';
part 'all_notes_state.dart';

class AllNotesBloc extends Bloc<AllNotesEvent, AllNotesState> {
  final NoteRemoteDatasource remote;
  AllNotesBloc(
    this.remote,
  ) : super(AllNotesInitial()) {
    on<GetAllNotes>((event, emit) async {
      emit(AllNotesLoading());
      final result = await remote.getAllNotes();
      result.fold(
        (error) => emit(
          AllNotesFailed(
            message: error,
          ),
        ),
        (success) => emit(
          AllNotesSuccess(
            data: success,
          ),
        ),
      );
    });
  }
}
