import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/presentation/resources/styles_manager.dart';
import 'package:weather/presentation/screen/weather/weather_screen.dart';

import '../../../data/bloc/auth/auth_cubit.dart';
import '../../../data/singleton.dart';
import '../../component/component.dart';
import '../../resources/color_manager.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late AuthCubit authCubit;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  bool isDense = false;
  String? latLng;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) {
        authCubit = AuthCubit();
        return authCubit;
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/register.png'),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: Stack(children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 80),
              child: const Text(
                "Create\nAccount",
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSignUpErrorState) {
                  showSnackBar(context, state.message);
                }
                if (state is AuthSignUpSuccessState) {
                  changeNavigatorReplacement(context, WeatherScreen());
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        right: 35,
                        left: 35,
                        top: MediaQuery.of(context).size.height * 0.27),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        textField(
                          'Name',
                          () {},
                          controller: nameController,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
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
                          'Password', () {},
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
                                'Sign Up',
                                style: getSemiBoldStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: ColorManager.primary,
                                child: state is AuthSignUpLoadingState
                                    ? CircularProgressIndicator(
                                        color: ColorManager.white,
                                      )
                                    : IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            // authCubit.changePassword('123444','12345678');
                                            //authCubit.updateUser('hamoa12@gamil.com',);

                                            authCubit
                                                .createAccountWithEmailPassword(
                                                    emailController.text,
                                                    passwordController.text,
                                                    nameController.text,
                                                    latLng ?? '');
                                          }
                                        },
                                        icon: const Icon(Icons.arrow_forward),
                                      ),
                              ),
                            ]),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 18,
                                    color: Colors.white,
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
    );
  }

  void _getUserLocation() async {
    var position = await Singleton().getGeoLocationPosition();

    if (position != null) {
      latLng = '${position.latitude},${position.longitude}';
    }
  }
}
