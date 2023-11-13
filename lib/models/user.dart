class UserData {
  final String? id;
  final String? username;
  final String? fullName;
  final String? profilePicture;
  final String? dateJoined;
  final String? email;
  final String? description;
  final String? alamat;
  final String? nomorTelepon;
  UserData({required this.id, required this.username,
    required this.fullName, required this.profilePicture,
    required this.dateJoined, required this.email, required this.description,
    required this.alamat, required this.nomorTelepon});

  factory UserData.fromJson(Map<String, dynamic> userProfile){
    return UserData(id: userProfile['id'].toString(), username: userProfile['username'],
        fullName: userProfile['nama_lengkap'], profilePicture: userProfile['gambar_profil'],
        dateJoined:userProfile['date_joined'],
        email: userProfile['email'], description: userProfile['description'], alamat: userProfile['alamat'], nomorTelepon:
        userProfile['nomor_telepon']
    );
  }
}

