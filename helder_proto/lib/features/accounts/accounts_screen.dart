import 'package:flutter/material.dart';
import 'package:helder_proto/common/widgets/helder_toggleswitch.dart';

import 'package:helder_proto/features/accounts/accounts_list.dart';
import 'package:helder_proto/features/accounts/accounts_screen_layout.dart';

class AccountsScreen extends StatefulWidget{
  final bool payedAccounts;

  const AccountsScreen({
    super.key,
    
    this.payedAccounts = true
  });

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  late Widget listWidget;

  @override
  void initState() {
    super.initState();

    listWidget = AccountsList(
      key: ValueKey(widget.payedAccounts),
      payedAccounts: widget.payedAccounts
    );
  }

  @override
  Widget build(BuildContext context) {

    return AccountsScreenLayout(
      toggleSwitch: HelderToggleSwitch(
        initialValue: widget.payedAccounts,
        onToggle: (value) {
          setState(() {
            listWidget = AccountsList(
              key: ValueKey(value),
              payedAccounts: value
            );
          });
        },
      ), 
      paymentCards: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: listWidget,
      )
    );
  }
}