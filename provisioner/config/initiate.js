rs.initiate({
  _id: "config",
  configsvr: true,
  members: [{
    _id : 0,
    host : "1.config.mongodb"
  }, {
    _id : 1,
    host : "2.config.mongodb"
  }, {
    _id : 2,
    host : "3.config.mongodb"
  }]
});
