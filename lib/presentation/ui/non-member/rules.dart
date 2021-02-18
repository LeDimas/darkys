import 'package:darky_app/services/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({Key key}) : super(key: key);

  final String rules = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                backgroundColor: Color(0xFF6DC0C4),
                shadowColor: Colors.transparent,
                title: Text(
                    AppLocalizations.of(context).translate('rules_title'))),
            body: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF263248),
                ),
                child: Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          vertical: 48.0,
                        ),
                        child: Column(
                          children: [
                            Text(AppLocalizations.of(context)
                                .translate('lessons_rules')),
                            Text(AppLocalizations.of(context)
                                .translate('dancer_duties_rules')),
                            Text(AppLocalizations.of(context)
                                .translate('parents_duties_rules')),
                            Text(AppLocalizations.of(context)
                                .translate('study_responsobilities_rules')),
                            Text(AppLocalizations.of(context)
                                .translate('epilogue_rules'))
                          ],
                        ))))));
  }
}
