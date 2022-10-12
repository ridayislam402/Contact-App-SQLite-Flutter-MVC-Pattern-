const String tblContact = 'tbl_contact';
const String tblContactColId = 'id';
const String tblContactColName = 'name';
const String tblContactColMobile = 'mobile';
const String tblContactColEmail = 'email';
const String tblContactColAddress = 'address';
const String tblContactColDob = 'dob';
const String tblContactColImage = 'image';
const String tblContactColFavorate = 'favorate';

class ContactModel{
  int? id;
  String name;
  String mobile;
  String? email;
  String? streetAddress;
  String? dob;
  String? image;
  bool favorate;

  ContactModel(
      {this.id,
     required this.name,
     required this.mobile,
      this.email,
      this.streetAddress,
      this.dob,
      this.image,
      this.favorate = false,});

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      tblContactColName : name,
      tblContactColMobile : mobile,
      tblContactColEmail : email,
      tblContactColAddress : streetAddress,
      tblContactColDob : dob,
      tblContactColImage : image,
      tblContactColFavorate : favorate ? 1 : 0,
    };
    if(id != null){
      map[tblContactColId] = id;
    }
    return map;
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) => ContactModel(
      name: map[tblContactColName],
      id: map[tblContactColId],
      mobile: map[tblContactColMobile],
    email: map[tblContactColEmail],
    streetAddress : map[tblContactColAddress],
    dob: map[tblContactColDob],
    image : map[tblContactColImage],
    favorate : map[tblContactColFavorate] == 1 ? true : false
  );
}