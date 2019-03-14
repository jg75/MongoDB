db.createUser({
  user: "admin",
  pwd: "password",
  roles: [{
    role: "dbOwner",
    db: "admin"
  }]
});

db.createUser({
  user: "client",
  pwd: "password",
  roles: ["readWriteAnyDatabase"]
});

db.createUser({
  user: "read-only",
  pwd: "password",
  roles: ["readAnyDatabase"]
});
