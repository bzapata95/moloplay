import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:molopay/helpers/sql_helpers.dart';
import 'package:molopay/helpers/storage_helpers.dart';
import 'package:molopay/models/person.dart';
import 'package:molopay/models/transaction.dart';
import 'package:molopay/routes/routes.dart';
import 'package:molopay/utils/formatted_currency.dart';
import 'package:molopay/utils/formatted_transaction.dart';
import 'package:molopay/utils/handle_request_permission.dart';
import 'package:molopay/utils/responsive.dart';
import 'package:molopay/widgets/avatar.dart';
import 'package:molopay/widgets/card_transaction.dart';
import 'package:molopay/widgets/header.dart';

class ProfileScreen extends StatefulWidget {
  final Person person;
  const ProfileScreen({super.key, required this.person});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Transaction> transactions = [];
  bool isActiveEditName = false;
  String? _urlPath;
  final _nameProfileController = TextEditingController();
  final FocusNode _focusNodeNameProvider = FocusNode();
  final _storageHelper = StorageHelper();

  onLoadTransactions() async {
    final response = await SQLHelper.getTransactionsByPersonId(
        id: widget.person.id, limit: 300);
    setState(() {
      transactions = formattedTransaction(response);
    });
  }

  @override
  void initState() {
    onLoadTransactions();
    _nameProfileController.text = widget.person.name;
    _urlPath = widget.person.urlImage;

    super.initState();
  }

  onHandleEditNamePerson() async {
    if (_nameProfileController.text.trim().isEmpty) {
      return;
    }

    try {
      await SQLHelper.updateNamePerson(
          name: _nameProfileController.text, idPerson: widget.person.id);
      isActiveEditName = false;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  onHandleUploadPhoto(bool gallery) async {
    final String? response;

    if (gallery) {
      response = await HandleRequestPermissions.requestOpenPhotoLibrary();
    } else {
      response = await HandleRequestPermissions.requestOpenCamera();
    }

    if (response != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: response,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          // AndroidUiSettings(
          //     toolbarTitle: 'Cropper',
          //     toolbarColor: Colors.deepOrange,
          //     toolbarWidgetColor: Colors.white,
          //     initAspectRatio: CropAspectRatioPreset.original,
          //     lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          // WebUiSettings(
          //   context: context,
          // ),
        ],
      );

      if (croppedFile == null) return;

      final urlSecure = await _storageHelper.uploadImage(croppedFile.path);
      if (urlSecure != null) {
        _urlPath = urlSecure;
        await SQLHelper.updateUrlImagePerson(
            urlImage: urlSecure, idPerson: widget.person.id);
        setState(() {});
        if (mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20)
            .copyWith(top: 10),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: responsive.dp(8.5),
                          height: responsive.dp(8.5),
                          child: Stack(
                            children: [
                              Avatar(
                                name: widget.person.name,
                                radius: 150,
                                size: 80,
                                urlImage: _urlPath,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: responsive.dp(4),
                                  height: responsive.dp(4),
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 58, 70, 62),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () {
                                        showCupertinoModalPopup(
                                            context: context,
                                            builder: (_) {
                                              return CupertinoActionSheet(
                                                title: Text('Operation'),
                                                actions: [
                                                  CupertinoActionSheetAction(
                                                    child: Text("Take a photo"),
                                                    onPressed: () async {
                                                      onHandleUploadPhoto(
                                                          false);
                                                    },
                                                  ),
                                                  CupertinoActionSheetAction(
                                                    child: Text("Gallery"),
                                                    onPressed: () async {
                                                      onHandleUploadPhoto(true);
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      icon:
                                          const Icon(Icons.camera_alt_outlined),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        if (!isActiveEditName)
                          Text(
                            _nameProfileController.text,
                            style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (isActiveEditName)
                          SizedBox(
                              height: 56,
                              width: 200,
                              child: TextField(
                                focusNode: _focusNodeNameProvider,
                                controller: _nameProfileController,
                                decoration: const InputDecoration(
                                  hintText: "Into name",
                                ),
                              )),
                      ],
                    ),
                    const Spacer(),
                    if (!isActiveEditName)
                      IconButton(
                          onPressed: () {
                            _focusNodeNameProvider.requestFocus();
                            _nameProfileController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _nameProfileController.text.length,
                            );
                            setState(() {
                              isActiveEditName = !isActiveEditName;
                            });
                          },
                          icon: const Icon(Icons.edit)),
                    if (isActiveEditName)
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                onHandleEditNamePerson();
                              },
                              icon: const Icon(Icons.save)),
                          IconButton(
                              onPressed: () {
                                _nameProfileController.text =
                                    widget.person.name;
                                setState(() {
                                  isActiveEditName = !isActiveEditName;
                                });
                              },
                              icon: const Icon(Icons.close)),
                        ],
                      ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Total debt",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          formattedCurrency(widget.person.balance!),
                          style: const TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                const Header(
                  title: "Transactions",
                ),
                const SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.detailsTransaction,
                            arguments: transactions[index]);
                      },
                      child: Column(
                        children: [
                          CardTransaction(
                            transaction: transactions[index],
                            withAvatar: false,
                            withName: false,
                          ),
                          const Divider()
                        ],
                      ),
                    );
                  },
                  itemCount: transactions.length,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
