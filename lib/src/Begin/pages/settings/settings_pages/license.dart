import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/src/Begin/begin.dart';
import 'package:phoenix/src/Begin/utilities/constants.dart';
import "dart:collection";

class LicensesPage extends StatefulWidget {
  const LicensesPage({Key key}) : super(key: key);

  @override
  _LicensesPageState createState() => _LicensesPageState();
}

class _LicensesPageState extends State<LicensesPage> {
  @override
  void initState() {
    backArtStateChange = false;
    super.initState();
  }

  @override
  void dispose() {
    backArtStateChange = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: licensesManager(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          // if (snapshot.data != null) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Licenses", style: TextStyle(fontFamily: "FuturaR")),
              backgroundColor: kMaterialBlack,
            ),
            backgroundColor: kMaterialBlack,
            body: ListView.builder(
              itemCount: snapshot.data.length - 1,
              itemBuilder: (BuildContext context, int index) {
                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    title: Text(
                      snapshot.data.keys.toList()[index],
                      style:
                          TextStyle(color: Colors.white, fontFamily: "FuturaR"),
                    ),
                    subtitle: Text(
                      "${snapshot.data[snapshot.data.keys.toList()[index]].length} Licenses",
                      style:
                          TextStyle(color: Colors.white, fontFamily: "FuturaR"),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InsideLicense(
                                  snapshot.data.keys.toList()[index],
                                  snapshot.data[
                                      snapshot.data.keys.toList()[index]])));
                    },
                  ),
                );
              },
            ),
          );
        } else {
          return Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                backgroundColor: kMaterialBlack,
                color: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}

class InsideLicense extends StatelessWidget {
  final List<String> licenseValue;
  final String licenseKey;
  InsideLicense(this.licenseKey, this.licenseValue);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMaterialBlack,
      appBar: AppBar(
        backgroundColor: kMaterialBlack,
        title: Text(
          licenseKey,
          style: TextStyle(fontFamily: "FuturaR"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < licenseValue.length; i++)
              Column(
                children: [
                  Text(
                    licenseValue[i],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "InterR",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 32),
                  ),
                  Divider(
                    color: Colors.white54,
                    indent: 50,
                    thickness: 0.2,
                    endIndent: 50,
                    height: 4,
                  )
                ],
              ),
            Padding(
              padding: EdgeInsets.only(top: 32),
            )
          ],
        ),
      ),
    );
  }
}

licensesManager() async {
  Map<String, List<String>> licenseData = {};
  List<LicenseEntry> rawLicense = await LicenseRegistry.licenses.toList();
  allLicenseIterator(String package) {
    for (int i = 0; i < rawLicense.length; i++) {
      for (int o = 0; o < rawLicense[i].packages.length; o++) {
        if (package == rawLicense[i].packages.toList()[o]) {
          String licenseParagraph = "";
          rawLicense[i].paragraphs.forEach((element) {
            licenseParagraph += "\n \n ${element.text}";
          });
          licenseData[package].add(licenseParagraph);
        }
      }
    }
  }

  for (int i = 0; i < rawLicense.length; i++) {
    for (int o = 0; o < rawLicense[i].packages.length; o++) {
      if (!licenseData.keys
          .toList()
          .contains(rawLicense[i].packages.toList()[o])) {
        licenseData[rawLicense[i].packages.toList()[o]] = [];
        allLicenseIterator(rawLicense[i].packages.toList()[o]);
      }
    }
  }
  final sorted = SplayTreeMap<String, List<String>>.from(
      licenseData, (a, b) => a.compareTo(b));
  return sorted;
}
