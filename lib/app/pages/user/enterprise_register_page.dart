import 'package:flutter/material.dart';
import 'package:pub/app/config/app_colors.dart';
import 'package:pub/app/models/user.dart';
import 'package:pub/app/pages/establishment/establishment_page.dart';
import 'package:pub/app/pages/user/widgets/enterprise_register_bar_widget.dart';
import 'package:pub/app/view_models/user_view_model.dart';
import 'package:pub/app/shared/form_field_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pub/app/shared/dropdown_widget.dart';
import 'package:location/location.dart';
class EnterpriseRegisterPage extends StatefulWidget  {
  _EnterpriseRegisterPageState createState() => _EnterpriseRegisterPageState();
}

class _EnterpriseRegisterPageState extends State<EnterpriseRegisterPage> {

  _EnterpriseRegisterPageState(){
    _userViewModel.checkLocation();
  }

  TextEditingController _nickNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  UserViewModel _userViewModel = UserViewModel(Location(), User());

  List<String> _listGenres = ['Não informado','Masculino', 'Feminino'];
  String _selectedGenre = '';

  late String _latitude;
  late String _longitude;

  @override
  Widget build (BuildContext context) {

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            appBar:  EnterpriseRegisterBarWidget(),
            body: SingleChildScrollView(
                child:Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColors.white),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                        children: <Widget> [
                          Padding(
                              padding: EdgeInsets.only(top: 60),
                              child:  FormFieldWidget(
                                  formFieldController :_nickNameController,
                                  name: 'nickname',
                                  message: 'digite seu nickname')
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 28),
                              child:  FormFieldWidget(
                                  formFieldController :_ageController,
                                  name: 'idade',
                                  message: 'digite sua idade')

                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 28),
                              child:Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    border: new Border.all(
                                        color: Colors.black12,
                                        width: 1.0,
                                        style: BorderStyle.solid
                                    ),
                                  ), width: 280, height: 38,
                                  child: Form(
                                      autovalidateMode: AutovalidateMode.always,
                                      child: DropdownWidget(list: _listGenres, callback: (String dropdownReturn){
                                        setState(() {
                                          _selectedGenre = dropdownReturn;
                                        });
                                      },name: "gênero",))
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: 144),
                            child: ElevatedButton(
                                onPressed: (){
                                  User user = _userViewModel.validaUsuario(_nickNameController, _ageController, _selectedGenre, _listGenres);
                                  this._latitude = _userViewModel.locationData.latitude.toString();
                                  this._longitude = _userViewModel.locationData.longitude.toString();
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => EstablishmentPage( user: user,
                                                                               latitude:_latitude,
                                                                               longitude:_longitude)
                                  )
                                  );
                                },
                                child: Text("Avançar",
                                    style:GoogleFonts.inter( fontSize: 14, color: Colors.white)
                                ),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))
                                      )
                                  ),
                                  backgroundColor: MaterialStateProperty.all(AppColors.lightBrown),
                                  padding:MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 60)
                                  ),
                                )
                            ),
                          )
                        ]
                    )
                )
            )
        )
    );
  }
}

