class Change{

  String username;
  DateTime timestamp;
  String collection;
  String id;
  String type;
  String notes;
  String field;
  dynamic before;
  dynamic after;
  dynamic snapshotBefore;
  dynamic snapshotAfter;

  Change({this.field,this.type,this.id,this.collection,this.username,
    this.after,this.before,this.notes,this.snapshotAfter,this.snapshotBefore,this.timestamp});


}