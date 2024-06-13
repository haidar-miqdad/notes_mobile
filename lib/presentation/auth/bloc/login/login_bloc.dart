import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes_app/data/datasources/auth_lokal_datasource.dart';
import 'package:notes_app/data/datasources/auth_remote_datasource.dart';
import 'package:notes_app/data/model/response/auth_response_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDataSource remote;

  LoginBloc(this.remote) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async{
      emit(LoginLoading());
      final response = await remote.login(event.email, event.password);
      response.fold(
              (l) => emit(LoginFailed(message: l)),
              (r) {
                AuthLocalDatasource().saveAuthData(r);
                emit(LoginSuccess(data: r));
              }
      );
    });
  }
}
