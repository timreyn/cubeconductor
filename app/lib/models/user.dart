class User {
  User(Map userData)
      :
        id = userData['id'],
        wcaId = userData['wca_id'],
        name = userData['name'],
        delegateStatus = userData['delegate_status'],
        avatarUrl = userData['avatar_url'],
        avatarThumbUrl = userData['avatar_thumb_url'];

  final int id;
  final String wcaId;
  final String name;
  final String delegateStatus;
  final String avatarUrl;
  final String avatarThumbUrl;
}