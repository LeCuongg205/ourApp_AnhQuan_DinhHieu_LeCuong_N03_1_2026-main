// Danh sách và CRUD cho User
import '../entities/user.dart';

class UserList {
  final List<User> _items = [];

  // Khởi tạo với danh sách ban đầu
  UserList([List<User>? initial]) {
    if (initial != null) {
      _items.addAll(initial);
    }
  }

  // Create: thêm 1 bản ghi kiểu User vào danh sách
  bool create(User user) {
    if (_items.any((u) => u.id == user.id)) {
      return false;
    }
    _items.add(user);
    return true;
  }

  // Read all: trả về danh sách tất cả User (bản sao để tránh bị sửa)
  List<User> readAll() {
    return List<User>.from(_items);
  }

  // Read by id: trả về User nếu tìm thấy, còn không thì trả null
  User? readById(int id) {
    try {
      return _items.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  // Update: cập nhật 1 bản ghi có id cụ thể
  // Trả về true nếu cập nhật thành công, false nếu không tìm thấy id
  bool updateById(int id, {String? name, String? email, String? password}) {
    final index = _items.indexWhere((u) => u.id == id);
    if (index == -1) return false;

    final existing = _items[index];

    // Sử dụng null-coalescing để không gán null vào trường non-nullable
    existing.name = name ?? existing.name;
    existing.email = email ?? existing.email;
    existing.password = password ?? existing.password;

    _items[index] = existing;
    return true;
  }

  // Delete: xóa bản ghi theo id
  bool deleteById(int id) {
    final before = _items.length;
    _items.removeWhere((u) => u.id == id); // removeWhere trả về void
    final after = _items.length;
    return after < before;
  }

  // Utility: số lượng phần tử
  int count() => _items.length;

  // Utility: xóa toàn bộ (dùng cho test)
  void clear() => _items.clear();
}
