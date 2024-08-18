class AppUser{
  String? authId;
  String? fullName;
  String? email;

  AppUser({
    this.authId,
    this.email,
    this.fullName
  });

  AppUser.fromFirestore(Map<String,dynamic>? data)
      :this(
      authId : data?['authId'],
      email  : data?['email'],
      fullName  : data?['fullName']
  );

  Map<String,dynamic> toFirestore(){
    return {
      "authId" : authId,
      "email" : email,
      "fullName" : fullName
    };
  }
}