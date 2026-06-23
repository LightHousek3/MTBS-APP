class WaitlistStatus {
  const WaitlistStatus({
    required this.movieId,
    required this.isSaved,
    required this.canAddToWaitlist,
  });

  final String movieId;
  final bool isSaved;
  final bool canAddToWaitlist;

  factory WaitlistStatus.fromJson(Map<String, dynamic> json) {
    return WaitlistStatus(
      movieId: json['movieId']?.toString() ?? '',
      isSaved: json['isSaved'] == true,
      canAddToWaitlist: json['canAddToWaitlist'] == true,
    );
  }
}
