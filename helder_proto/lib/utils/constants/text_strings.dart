class TTexts {

  static const agreementTitle = "Wat gebeurt er met je brief?";
  static const List<String> agreementPoints = [
    "We versimpelen je brief met OpenAI, deze OpenAI bewaard je brief 30 dagen",
    "Onze app slaat geen gegevens online op, \ndeze staan alleen op jouw telefoon!",
    "Voor het scannen van de brief kun je, als je \ndit wil, je naam en adres doorstrepen.\nDe app werkt dan nog steeds",
    "Wil je de algemene voorwaarden lezen?\nKlik dan hier.",
    "Wil je ons privacybeleid lezen?\nKlik dan hier."
  ];

  static const String canYouPayNowText = "De rekening moet betaald worden. Denk goed\nna of je de rekening nu kan betalen. Zijn er nog\nandere dingen die je deze maand nog moet\nbetalen? Denk aan huur, gas, water, elektra en\nzorgverzekering. ";

  static String dontNeedToPayToday(String dateString){
    return "Je hoeft de rekening niet vandaag te betalen.\nSpaar voor deze rekening en betaal voor $dateString!";
  } 
}