List<K> listMap<T, K>(List<T> list, K Function(int index, T element) func) {
  if (list == null) return null;
  if (list.isEmpty) return [];
  final List<K> resultList = [];
  for (var i = 0; i < list.length; i++) {
    resultList.add(func(i, list[i]));
  }
  return resultList;
}
