rs.initiate({
  _id: "replica1",
  members: [{
    _id : 0,
    host : "1.replica1.mongodb"
  }, {
    _id : 1,
    host : "2.replica1.mongodb"
  }, {
    _id : 2,
    host : "3.replica1.mongodb"
  }]
});
