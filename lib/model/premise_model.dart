class Premise {
  final String storename;
  final String address;
  final num postcode;
  final String state;
  final num activeuser;
  final String email;
  final num crowdLimit;
  final String date;
  final num durationHours;
  final num durationMinutes;
  final num durationSeconds;
  final String riskStatus;

  Premise(
      {required this.storename,
      required this.address,
      required this.postcode,
      required this.state,
      required this.activeuser,
      required this.email,
      required this.crowdLimit,
      required this.date,
      required this.durationHours,
      required this.durationMinutes,
      required this.durationSeconds,
      required this.riskStatus});

  Map<String, dynamic> toJson() => {
        'storename': storename,
        'address': address,
        'postcode': postcode,
        'state': state,
        'activeuser': activeuser,
        'email': email,
        'crowdLimit': crowdLimit,
        'date': date,
        'durationHours': durationHours,
        'durationMinutes': durationMinutes,
        'durationSeconds': durationSeconds,
        'riskstatus': riskStatus
      };
}
