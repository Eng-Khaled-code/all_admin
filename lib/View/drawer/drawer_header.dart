import 'package:flutter/material.dart';

import '../utilities/strings.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = Strings.userImagesDirectoryUrl +
        Strings.userInformation!.value.imageUrl!;
    return UserAccountsDrawerHeader(
      currentAccountPicture: GestureDetector(
        child: CircleAvatar(
          backgroundImage: NetworkImage(
              Strings.userInformation!.value.imageUrl == "" ||
                      Strings.userInformation!.value.imageUrl == null
                  ? Strings.appIconUrl
                  : imageUrl),
          backgroundColor: Colors.grey,
        ),
      ),
      accountEmail: Text(
        Strings.userInformation!.value.email!,
        style: const TextStyle(color: Colors.white),
      ),
      accountName: Text(Strings.userInformation!.value.userName!,
          style: const TextStyle(color: Colors.white)),
    );
  }
}
