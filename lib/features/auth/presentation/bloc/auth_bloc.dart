import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flavorith/features/auth/data/repositories/auth_repository.dart';

// Events
abstract class AuthEvent {}

// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({
    required this.authRepository,
  }) : super(AuthInitial());
} 