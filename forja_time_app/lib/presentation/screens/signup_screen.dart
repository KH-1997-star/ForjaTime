import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubits/signup/signup_cubit.dart';
import '../../data/repositories/auth_repository.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignupScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocProvider<SignupCubit>(
          create: (_) => SignupCubit(context.read<AuthRepository>()),
          child: const SignupForm(),
        ),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.success) {
          Navigator.of(context).pop();
        } else if (state.status == SignupStatus.error) {
          // Nothing for now.
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _EmailInput(),
          const SizedBox(height: 8),
          _PasswordInput(),
          const SizedBox(height: 8),
          _SignupButton(),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) =>
          previous.email != current.email ||
          current.status == SignupStatus.error,
      builder: (context, state) {
        return TextField(
          onChanged: (email) {
            context.read<SignupCubit>().emailChanged(email);
          },
          decoration: InputDecoration(
            labelText: 'email',
            errorText:
                state.emailErrorMessage == '' ? null : state.emailErrorMessage,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          current.status == SignupStatus.error,
      builder: (context, state) {
        return TextField(
          onChanged: (password) {
            context.read<SignupCubit>().passwordChanged(password);
          },
          decoration: InputDecoration(
            labelText: 'password',
            errorText: state.passwordErrorMessage == ''
                ? null
                : state.passwordErrorMessage,
          ),
          obscureText: true,
        );
      },
    );
  }
}

class _SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == SignupStatus.submitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: const Size(200, 40),
                ),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<SignupCubit>().signupFormSubmitted();
                  if (state.otherError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.otherError!)));
                  }
                },
                child: const Text(
                  'SIGN UP',
                  style: TextStyle(color: Colors.white),
                ),
              );
      },
    );
  }
}
