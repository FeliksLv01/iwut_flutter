class UpdateInfo {
  String? latestRelease = '';
  String? updateUrl = '';

  UpdateInfo({this.latestRelease, this.updateUrl});

  UpdateInfo.fromJson(Map<String, dynamic> json) {
    latestRelease = json['latestRelease'];
    updateUrl = json['updateUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latestRelease'] = this.latestRelease;
    data['updateUrl'] = this.updateUrl;
    return data;
  }
}
