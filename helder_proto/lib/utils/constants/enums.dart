enum HelderKind {
  brief("Brief"),
  factuur("Factuur"),
  belasting("Belasting"),
  toeslag("Toeslag");

  const HelderKind(this.kindName);
  final String kindName;
}

Map<String, dynamic> helderKindToJson() {
  return {
    "HelderKinds": HelderKind.values.map((e) => e.kindName.split('.').last).toList(),
  };
}


enum LetterKind {
  normaal('Normale brief'),
  afspraak('Afspraak');

  const LetterKind(this.kindName);
  final String kindName;
}

Map<String, dynamic> letterKindToJson() {
  return {
    "Brief": LetterKind.values.map((e) => e.toString().split('.').last).toList(),
  };
}

enum InvoiceKind {
  dienst('Dienst'),
  product('Product'),
  overig('Overig');

  const InvoiceKind(this.kindName);
  final String kindName;
}

Map<String, dynamic> invoiceKindToJson() {
  return {
    "Factuur": TaxKind.values.map((e) => e.toString().split('.').last).toList(),
  };
}

enum TaxKind {
  inkomstenBelasting('Inkomstenbelasting'),
  omzetBelasting('Omzetbelasting'),
  overigeBelasting('Overige belasting');

  const TaxKind(this.kindName);
  final String kindName;
}

Map<String, dynamic> taxKindToJson() {
  return {
    "Belasting": TaxKind.values.map((e) => e.toString().split('.').last).toList(),
  };
}

enum AllowanceKind {
  zorgToeslag('Zorgtoeslag'),
  overigeToeslag('Overige toeslag');

  const AllowanceKind(this.kindName);
  final String kindName;
}

Map<String, dynamic> allowanceKindToJson() {
  return {
    "Toeslag": AllowanceKind.values.map((e) => e.toString().split('.').last).toList(),
  };
}
Map<String, dynamic> allKindsToJson() {
  return {
    ...letterKindToJson(),
    ...invoiceKindToJson(),
    ...taxKindToJson(),
    ...allowanceKindToJson(),
  };
}