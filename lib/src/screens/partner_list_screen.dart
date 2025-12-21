
// lib/src/screens/partner_list_screen.dart
import 'package:flutter/material.dart';
import '../models/res_partner.dart';
import '../widgets/partner_list_item.dart';

class PartnerListScreen extends StatelessWidget {
  final List<ResPartner> partners;

  const PartnerListScreen({Key? key, required this.partners}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Partners')),
      body: ListView.builder(
        itemCount: partners.length,
        itemBuilder: (context, index) => PartnerListItem(partner: partners[index]),
      ),
    );
  }
}
