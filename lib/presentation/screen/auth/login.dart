import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/data/bloc/auth/auth_cubit.dart';
import 'package:weather/presentation/resources/color_manager.dart';
import 'package:weather/presentation/resources/font_manager.dart';
import 'package:weather/presentation/resources/manager_values.dart';
import 'package:weather/presentation/screen/auth/register.dart';
import 'package:weather/presentation/screen/weather/weather_screen.dart';

import '../../component/component.dart';
import '../../resources/styles_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthCubit authCubit;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isDense = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider<AuthCubit>(
        create: (context) {
          authCubit = AuthCubit();
          return authCubit;
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/login.png'),
                fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(children: [
              Container(
                padding: const EdgeInsets.only(left: 35, top: 80),
                child: const Text(
                  "Welcome\nBack",
                  style: TextStyle(color: Colors.white, fontSize: 33),
                ),
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoginSuccessState) {
                    changeNavigatorReplacement(context, WeatherScreen());
                  }
                  if (state is AuthLoginErrorState) {
                    showSnackBar(context, state.message);
                  }
                },
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          right: 35,
                          left: 35,
                          top: MediaQuery.of(context).size.height * 0.5),
                      child: Form(
                        key: _formKey,
                        child: Column(children: [
                          textField(
                            'Email',
                            () {},
                            isEmailKeyboard: true,
                            controller: emailController,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          textField(
                            'Password',
                            () {},
                            // isPassword: true,
                            controller: passwordController,
                            isDense: isDense,
                            isPassword: true,
                            showPassword: () {
                              setState(() {
                                isDense = !isDense;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign In',
                                style: getSemiBoldStyle(
                                  color: Color(0xff4c505b),
                                  fontSize: FontSize.s20,
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: ColorManager.primary,
                                child: state is AuthLoginLoadingState
                                    ? CircularProgressIndicator(
                                        color: ColorManager.white,
                                      )
                                    : IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            authCubit.signInWithEmailPassword(
                                                emailController.text,
                                                passwordController.text);
                                          }
                                        },
                                        icon: const Icon(Icons.arrow_forward),
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: AppSize.s40,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    changeNavigator(context, RegisterScreen());
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 18,
                                      color: Color(0xff4c505b),
                                    ),
                                  ),
                                ),
                              ]),
                        ]),
                      ),
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
