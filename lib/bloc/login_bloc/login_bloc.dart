import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:vpn/data/login_datasource.dart';
import 'package:vpn/utils/authmanager.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  var datasource = LoginDataSource();
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      emit((LoginLoading()));
      try {
        var response =
            await datasource.getLogin(event.username, event.password);

        await AuthManager.saveLoginTime(DateTime.now());
        await AuthManager.saveExpireIn(response.expiresIn);
        await AuthManager.saveAccessToken(response.accessToken);
        // await AuthManager.saveRefreshToken(response.refreshToken);

        emit((LoginSuccess()));
      } on DioException catch (e) {
        emit((LoginError(e.response?.data['message'])));
      } catch (e) {
        emit((LoginError(e.toString())));
      }
    });
  }
}
