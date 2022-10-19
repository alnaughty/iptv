import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:vtv/services/firebase_auth.dart';
import 'package:vtv/services/m3u_url_handler.dart';
import 'package:vtv/utils/global.dart';
import 'package:vtv/utils/loader.dart';
import 'package:vtv/utils/palette.dart';
import 'package:vtv/views/auth/connect_via_credentials/children/login.dart';
import 'package:vtv/views/auth/connect_via_credentials/children/register.dart';

class ConnectViaCredentials extends StatefulWidget {
  const ConnectViaCredentials({super.key});

  @override
  State<ConnectViaCredentials> createState() => _ConnectViaCredentialsState();
}

class _ConnectViaCredentialsState extends State<ConnectViaCredentials>
    with
        Palette,
        LoaderV,
        SingleTickerProviderStateMixin,
        FirebaseAuthServices,
        M3UHandler {
  late final FocusNode iconButtonNode;
  late final TabController _controller;
  late final TextEditingController _playlist;
  late final FocusNode _playlistName;
  final GlobalKey<CredentialLoginState> _kLogin =
      GlobalKey<CredentialLoginState>();
  final GlobalKey<CredentialRegisterState> _kReg =
      GlobalKey<CredentialRegisterState>();
  late final BehaviorSubject<int> percentage;
  bool hasFocusedSubmit = false;
  @override
  void initState() {
    iconButtonNode = FocusNode(debugLabel: "back-button");
    _playlistName = FocusNode(debugLabel: "playlist")..requestFocus();
    _controller = TabController(
      vsync: this,
      length: 2,
    );
    _playlist = TextEditingController();
    iconButtonNode.requestFocus();
    percentage = BehaviorSubject<int>.seeded(0)
      ..listen((value) async {
        if (value == 100) {
          setState(() {
            loadingText = "Conversion et sauvegarde des données";
          });

          // setState(() {});
        } else {
          setState(() {
            loadingText = "Récupération des données : $value%";
          });
        }
      });
    // TODO: implement initState
    super.initState();
  }

  final GlobalKey<FormState> _kForm = GlobalKey<FormState>();
  final List<String> _label = ["S'Identifier", "S'inscrire"];
  late String loadingText = "Récupération des données : $percent%";

  @override
  void dispose() {
    _playlistName.dispose();
    _playlist.dispose();
    iconButtonNode.dispose();
    _controller.dispose();
    percentage.close();
    // TODO: implement dispose
    super.dispose();
  }

  File? toCategorize;
  Future<void> downloadAndConvert(context, String url) async {
    await downloadFromUrl(url, progressPercentage: (p) {
      percentage.add((100 * p).toInt());
      print("PERCENT : ${percentage.value}");
      setState(() {
        percent = percentage.value;
      });
      // }
    }).then((v) async {
      if (v != null) {
        print("SAVE FILE!");
        // setState(() {
        //   toCategorize = File(v);
        // });
        percentage.add(100);
        await cacher.setPlaylist(
          _playlist.text,
        );
        await categorizeParse(File(v)).onError((error, stackTrace) {
          setState(() {
            _isLoading = false;
            percent = 0;
            loadingText = "Récupération des données : $percent%";
          });
        }).whenComplete(() async =>
            await Navigator.pushReplacementNamed(context, "/landing_page"));
      } else {
        print("WARA MA SAVE");
        setState(() {
          _isLoading = false;
          percentage.add(0);
        });
      }
      return;
    });
    return;
  }

  bool _isLoading = false;
  int? percent;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_isLoading,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          right: true,
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.black,
                body: SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: background,
                    ),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            IconButton(
                              focusNode: iconButtonNode,
                              onPressed: () => Navigator.of(context).pop(),
                              padding: const EdgeInsets.all(0),
                              icon: Image.asset(
                                "assets/icons/back.png",
                                color: Colors.white,
                                height: 30,
                              ),
                            ),
                            const Spacer(),
                            Hero(
                              tag: "logo-f",
                              child: Image.asset(
                                "assets/images/logo.png",
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                        TabBar(
                          controller: _controller,
                          indicatorColor: Colors.white,
                          indicatorWeight: 3,
                          onTap: (i) {
                            setState(() {});
                          },
                          tabs: [
                            ..._label.map(
                              (e) => Tab(
                                text: e.toUpperCase(),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "nom de Playlist".toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Form(
                          key: _kForm,
                          child: TextFormField(
                            onChanged: (i) => setState(() {}),
                            cursorColor: appmaincolor,
                            controller: _playlist,
                            focusNode: _playlistName,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            validator: (String? text) {
                              if (text == null) {
                                return "Entrée invalide";
                              } else if (text.isEmpty) {
                                return "Ce champ est requis";
                              }
                            },
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              // isDense: true,
                              hintText: "Ma Playlist".toUpperCase(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 500,
                          ),
                          height: _controller.index == 0 ? 280 : 400,
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _controller,
                            children: [
                              CredentialLogin(
                                key: _kLogin,
                              ),
                              CredentialRegister(
                                key: _kReg,
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: dark,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: hasFocusedSubmit
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                          ),
                          child: InkWell(
                            onFocusChange: (t) {
                              setState(() {
                                hasFocusedSubmit = t;
                              });
                            },
                            onTap: () async {
                              print(_controller.index);
                              bool f = _kForm.currentState!.validate();
                              if (_controller.index == 0) {
                                bool validated =
                                    _kLogin.currentState!.isValidated;
                                if (validated && f) {
                                  /// DO THE THING!
                                  String email = _kLogin.currentState!.email;
                                  String password =
                                      _kLogin.currentState!.password;
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await login(email, password)
                                      .then((String? value) async {
                                    if (value != null) {
                                      await downloadAndConvert(context, value);
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                        percentage.add(0);
                                      });
                                    }
                                  });
                                }
                              } else {
                                bool validated =
                                    _kReg.currentState!.isValidated;
                                if (validated && f) {
                                  /// DO THE THING!
                                  String email = _kReg.currentState!.email;
                                  String password =
                                      _kReg.currentState!.password;
                                  String url = _kReg.currentState!.m3u;
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await register(email, password, url)
                                      .then((String? value) async {
                                    if (value != null) {
                                      await downloadAndConvert(context, value);
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                        percentage.add(0);
                                      });
                                    }
                                  });
                                }
                              }
                            },
                            child: const SizedBox(
                              height: 60,
                              child: Center(
                                child: Text(
                                  "SOUMETTRE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isLoading) ...{
                Positioned.fill(
                  child: loading(
                    color: Colors.white,
                    text: loadingText,
                  ),
                )
              },
            ],
          ),
        ),
      ),
    );
  }
}
