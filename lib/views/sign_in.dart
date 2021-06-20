import 'package:doa_1_0/services/api_service.dart';
import 'package:doa_1_0/services/constants.dart';
import 'package:doa_1_0/view_models/client_state_provider.dart';
import 'package:doa_1_0/widgets/alert_dialogs.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import './home_page.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;
  void _toggleLoadingState() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      opacity: 0.5,
      color: Colors.green[50],
      isLoading: _isLoading,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Image.asset("assets/logo_ver2.png")),
              ),
              SizedBox(height: 20),
              /* Text('Yaşatan Tazelik',
                  style: GoogleFonts.courgette(fontSize: 30)),*/
              SignInForm(
                toggleLoadingState: _toggleLoadingState,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  final VoidCallback toggleLoadingState;
  const SignInForm({@required this.toggleLoadingState});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (value) {
                  if (EmailValidator.validate(value)) {
                    return null;
                  } else {
                    return 'Lütfen Geçerli Bir E-Posta Giriniz';
                  }
                },
                decoration: InputDecoration(hintText: 'E-posta'),
              ),
              TextFormField(
                //keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value.isNotEmpty) {
                    return null;
                  } else {
                    return 'Lütfen Şifrenizi Giriniz';
                  }
                },
                controller: _passwordController,
                decoration: InputDecoration(hintText: 'Şifre'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Constants.mainGreen),
                ),
                onPressed: () async {
                  widget.toggleLoadingState();
                  await _submit();
                  widget.toggleLoadingState();
                },
                child: Text('GİRİŞ',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              )
            ],
          )),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState.validate()) {
      /// TODO:burada sadece loginStatus bilgisi yeterli, buraya Map dönmeye gerek yok
      /// tekrar bunu düşün
      Map<String, dynamic> _loginResponse =
          await Provider.of<ClientState>(context, listen: false).login(
              email: _emailController.text, pass: _passwordController.text);
      if (_loginResponse['loginStatus'] == LoginStatus.ok) {
        Provider.of<ClientState>(context, listen: false).setLoggedIn(true);
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      } else if (_loginResponse['loginStatus'] == LoginStatus.userError) {
        showLoginAlertDialog(context, 'Kullanıcı Bulunamadı');
      } else if (_loginResponse['loginStatus'] == LoginStatus.passwordError) {
        showLoginAlertDialog(context, 'Hatalı Şifre');
      } else if (_loginResponse['loginStatus'] == LoginStatus.unknownError) {
        showLoginAlertDialog(context, 'Bilinmeyen Bir Hata Oluştu');
      }
    }
  }
}
