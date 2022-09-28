// import 'package:flutter/material.dart';
// import 'package:portfeuille_numerique/updateLangue.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class chooseLangue extends StatefulWidget {
//   const chooseLangue({Key? key}) : super(key: key);

//   @override
//   State<chooseLangue> createState() => _chooseLangueState();
// }

// class _chooseLangueState extends State<chooseLangue> {
//   Locale? _locale;

//   void setLocale(Locale locale) {
//     setState(() {
//       _locale = locale;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       locale: _locale,
//       // debugShowCheckModeBanner:false,
//       localizationsDelegates: AppLocalizations.localizationsDelegates,
//       supportedLocales: AppLocalizations.supportedLocales,
//       home: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             icon: BackButtonIcon(),
//           ),
//           title: Text("Modifier la langue"),
//         ),
//         body: updateLangue(),
//       ),
//     );
//   }
// }
