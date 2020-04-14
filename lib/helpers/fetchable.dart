class Fetchable {
  bool isAlreadyFetched = false;
  void fetchComplete() {
    isAlreadyFetched = true;
  }
}
