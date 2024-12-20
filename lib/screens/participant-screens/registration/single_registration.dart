import 'package:flutter/material.dart';
import 'package:technozia/constants/global_variables.dart';
import 'package:technozia/constants/utils.dart';
import 'package:technozia/models/duoRegistration.dart';
import 'package:technozia/models/events.dart';
import 'package:technozia/models/team_member.dart';
import 'package:technozia/services/participant_services.dart';
import 'package:technozia/services/registration_services.dart';

class SingleRegistrationScreen extends StatefulWidget {
  static const String routeName = '/single-registration-screen';
  final Event event;
  const SingleRegistrationScreen({super.key, required this.event});

  @override
  State<SingleRegistrationScreen> createState() =>
      _SingleRegistrationScreenState();
}

enum PaymentMode { online, offline }

class _SingleRegistrationScreenState extends State<SingleRegistrationScreen> {
  ParticipantServices participantServices = ParticipantServices();
  RegistrationServices registrationServices = RegistrationServices();
  final _registrationFormKey = GlobalKey<FormState>();

  final TextEditingController _phoneNo = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _paymentId = TextEditingController();
  List<TeamMember>? teamMembers;
  List<DuoRegistration>? duoRegistrations;

  void getTeamMembers() async {
    teamMembers = await participantServices.fetchAllTeamMembers(context);
    setState(() {});
  }

  void onRegister() async {
    registrationServices.duoEventregistration(
      context: context,
      participantOne: participant1.toString(),
      participantTwo: "null",
      participantThree: "null",
      participantFour: "null",
      participantFive: "null",
      phoneNo: int.parse(_phoneNo.text),
      email: _email.text,
      eventName: widget.event.name,
      amount: widget.event.price,
      paymentMode: _character.toString(),
      paymentId: _paymentId.text,
      date: DateTime.now().toString(),
    );
  }

  @override
  void initState() {
    super.initState();
    getTeamMembers();
  }

  String? selectedValue1 = "";
  String? participant1;
  PaymentMode? _character = PaymentMode.online;

  @override
  Widget build(BuildContext context) {
    _paymentId.text = "";
    final event = ModalRoute.of(context)?.settings.arguments as Event;
    List<String>? dropdownItems = teamMembers?.map((e) => e.fullName).toList();
    return Scaffold(
      backgroundColor: GlobalVariables.bodyBackgroundColor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.appBarColor,
        centerTitle: true,
        title: Text(
          "Register",
          style: TextStyle(color: GlobalVariables.appBarContentColor),
        ),
      ),
      body: teamMembers == null
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Select the team members and fill the details",
                      style: TextStyle(
                        color: GlobalVariables.richBlackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        wordSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "for",
                      style: TextStyle(
                        color: GlobalVariables.richBlackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        wordSpacing: 0.5,
                      ),
                    ),
                    Text(
                      event.name,
                      style: TextStyle(
                        color: GlobalVariables.richBlackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        wordSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DropdownButton<String>(
                      hint: const Text("Team member 1"),
                      value: selectedValue1!.isNotEmpty ? selectedValue1 : null,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue1 = newValue!;
                          participant1 = selectedValue1;
                        });
                      },
                      borderRadius: BorderRadius.circular(24),
                      style: TextStyle(
                          color: GlobalVariables.richBlackColor,
                          fontSize: 16.0),
                      dropdownColor: Colors.white,
                      elevation: 8,
                      underline: Container(
                        height: 1,
                        color: GlobalVariables.richBlackColor,
                      ),
                      items: dropdownItems
                          ?.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value.isNotEmpty ? value : null,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Form(
                      key: _registrationFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _phoneNo,
                            decoration: InputDecoration(
                              labelText: 'Enter Phone No',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: GlobalVariables.appBarColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                            ),
                            validator: (val) {
                              if (val!.length != 10) {
                                return 'Phone number must be 10 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _email,
                            decoration: InputDecoration(
                              labelText: 'Enter email',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: GlobalVariables.appBarColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Amount to be paid: ₹${widget.event.price.toString()}",
                            style: TextStyle(
                              color: GlobalVariables.richBlackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'UPI ID: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.richBlackColor,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'presidency@hdfc',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: GlobalVariables.richBlackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            title: const Text('Online'),
                            leading: Radio<PaymentMode>(
                              value: PaymentMode.online,
                              groupValue: _character,
                              onChanged: (PaymentMode? value) {
                                setState(() {
                                  _character = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Offline'),
                            leading: Radio<PaymentMode>(
                              value: PaymentMode.offline,
                              groupValue: _character,
                              onChanged: (PaymentMode? value) {
                                setState(() {
                                  _character = value;
                                });
                              },
                            ),
                          ),
                          PaymentMode.online == _character
                              ? Column(
                                  children: [
                                    TextFormField(
                                      controller: _paymentId,
                                      decoration: InputDecoration(
                                        labelText: 'Enter Payment ID',
                                        labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  GlobalVariables.appBarColor),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.withOpacity(0.1),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 16.0,
                                                horizontal: 16.0),
                                      ),
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'Enter your payment ID';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                )
                              : const SizedBox(
                                  height: 8,
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              GlobalVariables.appBarColor, // Text color
                          elevation: 8, // Elevation (shadow)
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // Rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 24.0), // Button padding
                        ),
                        onPressed: () {
                          if (participant1 == null) {
                            showSnackBar(
                                context, "Please select the team member");
                            return;
                          }
                          if (_registrationFormKey.currentState!.validate()) {
                            onRegister();
                          }
                        },
                        child: const Text("Register Now"))
                  ],
                ),
              ),
            ),
    );
  }
}
