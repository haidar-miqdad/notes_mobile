import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/datasources/note_remote_datasource.dart';

part 'delete_note_event.dart';
part 'delete_note_state.dart';

class DeleteNoteBloc extends Bloc<DeleteNoteEvent, DeleteNoteState> {
  final NoteRemoteDatasource remote;
  DeleteNoteBloc(this.remote) : super(DeleteNoteInitial()) {
    on<DeleteNoteButtonPressed>((event, emit) async {
      emit (DeleteNoteLoading());
      final result = await remote.deleteNote(event.id);
      result.fold(
            (error) => emit(
          DeleteNoteFailed(
            message: error,
          ),
        ),
            (data) => emit(
          DeleteNoteSuccess(
            message: data,
          ),
        ),
      );
    });
  }
}
