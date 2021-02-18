const Map<String, int> date_lookup = {
  "Monday": 1,
  "Tuesday": 2,
  "Wednesday": 3,
  "Thursday": 4,
  "Friday": 5,
  "Saturday": 6,
  "Sunday": 7
};

Map<int, String> dayData = {
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
  0: "Sunday"
};

const btnSectionFilterMap = {
  'breaking_section': 'Breaking',
  'hiphop_section': 'Hip-Hop',
  'multi_group_section': 'Multi Group'
};

const Map<String, String> tierMap = {
  'breaking_section': 'breakingTier',
  'hiphop_section': 'hiphopTier',
  'multi_group_section': 'multigroupTier'
};

const Map<int, String> month_lookup = {
  1: "Janvarī",
  2: "Februarī",
  3: "Martā",
  4: "Aprilī",
  5: "Maījā",
  6: "Junījā",
  7: "Jūlījā",
  8: "Augustā",
  9: "Septembrī",
  10: "Oktobrī",
  11: "Novembrī",
  12: "Decembrī"
};

const Map<String, int> titleXpThreshold = {
  "newbie": 100, //0.01
  "begginer": 300, //0.01
  "junior ": 500,
  "middle": 1000,
  "senior": 1500,
  "godlike": 2500,
  "god": 500000
};

const Map<String, double> titleXpKMap = {
  'newbie': 0.01,
  'begginer': 0.003,
  'junior': 0.002,
  'middle': 0.001,
  'senior': 0.0006,
  'godlike': 0.0004,
  'god': 0.000002
};

const Map<String, String> titleLeveledUpTitleMap = {
  "newbie": 'begginer',
  'begginer': 'junior',
  'junior': 'middle',
  'middle': 'senior',
  'senior': 'godlike',
  'godlike': 'god'
};

const String no_avatar_image =
    'https://firebasestorage.googleapis.com/v0/b/darky-s-app.appspot.com/o/uploads%2Fphotos%2Fuser.png?alt=media&token=2b37c34a-158a-446b-8c5b-b88f177df670';
