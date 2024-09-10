
import 'package:flutter/material.dart';
import 'package:helder_proto/models/helder_letter.dart';
import 'package:helder_proto/data/services/database_service.dart';

class AccountsScreen extends StatelessWidget{
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _letterList();    
  }

  Widget _letterList() {
    return FutureBuilder(
      future: DatabaseService.instance.getLetters(), 
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            HelderLetter letter = snapshot.data![index];
            return ListTile(
              title: Text(letter.sender),
            );
          }
        );
      }
    );
  }

}