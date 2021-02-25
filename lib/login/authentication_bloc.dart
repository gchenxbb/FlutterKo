import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutterko/login/user_repository.dart';
import 'package:flutter/cupertino.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => InitialAuthenticationState();

  //Future,async,await。
  //Stream,sync*,yeild。
  //yield* Stream。
  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasToken();
      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
//      yield AuthenticationLoading();
      await userRepository.persisToken(event.token);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
//      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
