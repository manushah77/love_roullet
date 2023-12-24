class AcceptedDateData {
  String? DatingMemberName;
  String? DatedMemberName;
  String? DatedMemberImage;
  String? DatingMemberImage;

  String? DateBudget;
  String? DateTheme;
  String? SelectedDayForDate;
  String? YourDistanceFromDp;
  String? Vichle;
  int? Flower;

  String? DatingMemberId;
  String? DatedMemberId;

  String? DatedMemberGender;
  String? DatedMemberAge;


  String? DatingMemberGender;
  String? DatingMemberAge;

  bool? like;
  bool? Accepted;
  bool? Rejected;
  String? PayBy;

  bool? dislike;

  double? LatitueDatedMember;
  double? LongituteDatedMember;


  AcceptedDateData({
    this.PayBy,
    this.Flower,
    this.DateBudget,
    this.DatedMemberId,
    this.DatedMemberImage,
    this.DatedMemberName,
    this.DateTheme,
    this.DatingMemberId,
    this.DatingMemberName,
    this.DatingMemberImage,
    this.LatitueDatedMember,
    this.LongituteDatedMember,
    this.SelectedDayForDate,
    this.Vichle,
    this.YourDistanceFromDp,
    this.DatedMemberAge,
    this.DatedMemberGender,
    this.dislike,
    this.like,
    this.Accepted,
    this.Rejected,


  });

  AcceptedDateData.fromMap(Map<String, dynamic> map) {
    DateBudget = map['DateBudget'] ?? '';
    DatedMemberId = map['DatedMemberId'] ?? '';
    DatedMemberImage = map['DatedMemberImage'] ?? '';
    DatedMemberName = map['DatedMemberName'] ?? '';
    DateTheme = map['DateTheme'] ?? '';

    PayBy = map['PayBy'] ?? '';
    Flower = map['flower'] ?? 0;

    DatingMemberId = map['DatingMemberId'] ?? '';
    DatingMemberName = map['DatingMemberName'] ?? '';
    DatingMemberImage = map['DatingMemberImage'] ?? '';
    SelectedDayForDate = map['SelectedDayForDate'] ?? '';
    Vichle = map['Vichle'] ?? '';
    YourDistanceFromDp = map['YourDistanceFromDp'] ?? '';
    LatitueDatedMember = map['LatitueDatedMember'] ?? 0;
    LongituteDatedMember = map['LongituteDatedMember'] ?? 0;

    DatedMemberAge = map['DatedMemberAge'] ?? '';
    DatedMemberGender = map['DatedMemberGender'] ?? '';

    like = map['like'] ?? false;

    Accepted = map['Accepted'] ?? false;
    Rejected = map['Rejected'] ?? false;

    dislike = map['dislike'] ?? false;
  }

}
