import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes_app/data/datasources/auth_remote_datasource.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRemoteDataSource remote;

  LogoutBloc(this.remote) : super(LogoutInitial()) {
    on<LogoutButtonPressed>((event, emit) async {
      emit(LogoutLoading());
      final response = await remote.logout();
      response.fold(
        (error) => emit(LogoutFailed(message: error)),
        (success) => emit(LogoutSuccess()),
      );
    });
  }
}
