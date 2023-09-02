class Building {
  final String? oldName;
  final String? newName;

  Building(this.oldName, this.newName);

  @override
  bool operator ==(Object other) {
    if(other is! Building) return false;
    final Building otherBuilding = other;

    return this.oldName==otherBuilding.oldName &&
      this.newName==otherBuilding.newName;
  }

  @override
  int get hashCode => "$oldName$newName".hashCode;
}

buildingToTitle(Building building) {
  return "${building.newName}(原${building.oldName})";
}