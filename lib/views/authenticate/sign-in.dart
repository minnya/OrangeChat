import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:orange_chat/components/commons/custom_container.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/main.dart';
import 'package:orange_chat/views/authenticate/reset-password.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = screenWidth > 600 ? 600 : screenWidth;
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(builder: (context, constraints) {
        double screenHeight = MediaQuery.of(context).size.height;
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        double remainingHeight = screenHeight - keyboardHeight;
        bool isWideScreen = screenWidth > 600;
        return CustomContainer(
            alignment: Alignment.center,
            // direction: isWideScreen?Direction.HORIZONTAL:Direction.VERTICAL,
            height: remainingHeight,
            // constraints: BoxConstraints(minHeight: constraints.maxHeight),
            padding: EdgeInsets.symmetric(
              horizontal: (screenWidth - contentWidth) / 2 + 30,
              // vertical: (remainingHeight-contentHeight)/2
            ),
            children: const [
              _Logo(),
              SizedBox(
                height: 24,
              ),
              _FormContent()
            ]);
      }),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      direction: Direction.HORIZONTAL,
      children: [
        SizedBox(
            height: 60,
            width: 60,
            child: Image.asset("assets/images/icon_orange.png")),
        Text(
          "Orange",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: 50),
        )
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: AutofillGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              autofillHints: const [AutofillHints.username],
              controller: _emailController,
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return 'Please enter a valid email';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              autofillHints: const [AutofillHints.password],
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
            _gap(),
            RichText(
                text: TextSpan(
                    text: 'Forgot password?',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ResetPasswordPage()));
                      })),
            _gap(),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await AuthHelper(context: context)
                        .login(_emailController.text, _passwordController.text);
                    if (AuthHelper().isSignedIn()) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => MyApp()));
                    }
                  }
                },
              ),
            ),
            // const TextDivider(text: "or"),
            // SignInButton(
            //   Buttons.Google,
            //   onPressed: () async{
            //     GoogleSignIn _googleSignIn = GoogleSignIn(
            //       // Optional clientId
            //       clientId: '',
            //     );
            //     final SupabaseClient client = Supabase.instance.client;
            //     TargetPlatform platform = Theme.of(context).platform;
            //
            //     if(platform == TargetPlatform.android || platform== TargetPlatform.iOS) {}
            //     else if(platform == TargetPlatform.windows || platform == TargetPlatform.macOS || platform == TargetPlatform.linux){
            //       client.auth.signInWithOAuth(
            //         OAuthProvider.google,
            //         authScreenLaunchMode: LaunchMode.platformDefault
            //       );
            //     }
            //     _googleSignIn.signIn();
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
