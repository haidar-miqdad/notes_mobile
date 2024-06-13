import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes_app/data/model/request/register_request_model.dart';
import 'package:notes_app/data/model/response/auth_response_model.dart';

import '../../../../data/datasources/auth_remote_datasource.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRemoteDataSource remote;

  RegisterBloc(this.remote) : super(RegisterInitial()) {
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());
      final response = await remote.register(event.data);
      response.fold((l) => emit(RegisterFailed(message: l)),
          (r) => emit(RegisterSuccess(data: r)));
    });
  }
}
