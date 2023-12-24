class DatedData {
  String? DatingMemberName;
  String? DatedMemerName;
  String? DatedMemerImage;
  String? DatingMemerImage;

  String? DateBudget;
  String? DateTheme;
  String? SelectedDayForDate;
  String? YourDistanceFromDp;
  String? Vichle;
  String? DatingMemberId;
  String? DatedMemberId;

  String? DatingMemberGender;
  String? DatingMemberAge;

  String? DatedMemberGender;
  String? DatedMemberAge;
  bool? like;
  bool? Accepted;
  bool? Rejected;
  String? PayBy;

  String? dislike;

  double? LatitueDatedMember;
  double? LongituteDatedMember;

  DatedData({
    this.PayBy,
    this.DatingMemberAge,
    this.DatingMemberGender,
    this.DateBudget,
    this.DatedMemberId,
    this.DatedMemerImage,
    this.DatedMemerName,
    this.DateTheme,
    this.DatingMemberId,
    this.DatingMemberName,
    this.DatingMemerImage,
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

  DatedData.fromMap(Map<String, dynamic> map) {
    DateBudget = map['DateBudget'] ?? '';
    DatedMemberId = map['DatedMemberId'] ?? '';
    DatedMemerImage = map['DatedMemerImage'] ?? '';
    DatedMemerName = map['DatedMemerName'] ?? '';
    DateTheme = map['DateTheme'] ?? '';

    PayBy = map['PayBy'] ?? '';

    DatingMemberId = map['DatingMemberId'] ?? '';
    DatingMemberName = map['DatingMemberName'] ?? '';
    DatingMemerImage = map['DatingMemerImage'] ?? '';
    SelectedDayForDate = map['SelectedDayForDate'] ?? '';
    Vichle = map['Vichle'] ?? '';
    YourDistanceFromDp = map['YourDistanceFromDp'] ?? '';
    LatitueDatedMember = map['LatitueDatedMember'] ?? 0;
    LongituteDatedMember = map['LongituteDatedMember'] ?? 0;

    DatedMemberAge = map['DatedMemberAge'] ?? '';
    DatedMemberGender = map['DatedMemberGender'] ?? '';

    DatingMemberAge = map['DatingMemberAge'] ?? '';
    DatingMemberGender = map['DatingMemberGender'] ?? '';

    like = map['like'] ?? false;

    Accepted = map['Accepted'] ?? false;
    Rejected = map['Rejected'] ?? false;

    dislike = map['dislike'] ?? '';
  }
}
