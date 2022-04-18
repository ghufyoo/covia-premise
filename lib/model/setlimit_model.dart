class SetLimit {
  final String storename;
  final String date;
  final num durationHours;
  final num durationMinutes;
  final num durationSeconds;
  final num crowdLimit;
  final String storeemail;

  SetLimit(
      {required this.storename,
      required this.date,
      required this.durationHours,
      required this.durationMinutes,
      required this.durationSeconds,
      required this.crowdLimit,
      required this.storeemail});

  Map<String, dynamic> toJson() => {
        'storename': storename,
        'date': date,
        'durationHours': durationHours,
        'durationMinutes': durationMinutes,
        'durationSeconds': durationSeconds,
        'crowdLimit': crowdLimit,
        'email': storeemail
      };
}
