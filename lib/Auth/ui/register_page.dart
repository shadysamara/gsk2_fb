import 'package:flutter/material.dart';
import 'package:gsg2_firebase/Auth/helpers/auth_helper.dart';
import 'package:gsg2_firebase/Auth/models/country_model.dart';
import 'package:gsg2_firebase/Auth/providers/auth_provider.dart';
import 'package:gsg2_firebase/Auth/ui/widgets/custom_textField.dart';
import 'package:gsg2_firebase/global_widgets/custom_button.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  static final routeName = 'register';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<AuthProvider>(
      builder: (context, provider, x) {
        return SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  provider.selectFile();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey,
                  child: provider.file == null
                      ? Container()
                      : Image.file(provider.file, fit: BoxFit.cover),
                ),
              ),
              CustomTextfield('FirstName', provider.firstNameController),
              CustomTextfield('LastName', provider.lastNameController),
              CustomTextfield('Email', provider.emailController),
              CustomTextfield('Password', provider.passwordController),
              provider.countries == null
                  ? Container()
                  : Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15)),
                      child: DropdownButton<CountryModel>(
                        isExpanded: true,
                        underline: Container(),
                        value: provider.selectedCountry,
                        onChanged: (x) {
                          provider.selectCountry(x);
                        },
                        items: provider.countries.map((e) {
                          return DropdownMenuItem<CountryModel>(
                            child: Text(e.name),
                            value: e,
                          );
                        }).toList(),
                      ),
                    ),
              provider.countries == null
                  ? Container()
                  : Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15)),
                      child: DropdownButton<dynamic>(
                        isExpanded: true,
                        underline: Container(),
                        value: provider.selectedCity,
                        onChanged: (x) {
                          provider.selectCity(x);
                        },
                        items: provider.cities.map((e) {
                          return DropdownMenuItem<dynamic>(
                            child: Text(e),
                            value: e,
                          );
                        }).toList(),
                      ),
                    ),
              CustomButton(provider.register, 'Register'),
            ],
          ),
        );
      },
    );
  }
}
