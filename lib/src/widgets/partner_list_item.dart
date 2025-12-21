
// lib/src/widgets/partner_list_item.dart
import 'package:flutter/material.dart';
import '../models/res_partner.dart';

class PartnerListItem extends StatelessWidget {
  final ResPartner partner;

  const PartnerListItem({Key? key, required this.partner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(partner.name[0])),
      title: Text(partner.name),
      subtitle: Text(partner.email ?? 'No email'),
    );
  }
}
