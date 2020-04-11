extension MyString on String {
  String capitalize() {
    return this.substring(0, 1).toUpperCase() + this.substring(1, this.length);
  }
}
