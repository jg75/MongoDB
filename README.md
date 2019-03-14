# MongoDB
A clustered example of MongoDB running via docker.  I made this so I can get used to some basic mongodb administration and maintenance stuff.

## Getting Started

The mongodb service will forward it's published port to host port 27017. Make sure the port is not in use or change it to a different port.

### Setup your mongodb cluster

#### Put user creation scripts in the provisioner/users directory
  ```
  // Example
  // provisioner/users/users.js

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
  ```

#### Provision clustered and authenticated mongodb
  ```
  # Start mongo with no authentication
  docker-compose -f docker-compose-no-auth.yml up -d mongodb
  # Run the provisioner to configure the cluster
  docker-compose -f docker-compose-no-auth.yml up provisioner.mongodb
  # Stop and remove the mongodb containers with no authentication
  docker-compose down
  ```

### Start mongodb
  ```
  docker-compose up mongodb
  ```

### Connect to your mongodb cluster using authentication
  ```
  mongo mongodb://read-only:password@localhost:27017/admin?authSource=admin
  ```

### To backup your database
  ```
  docker-compose up backup.mongodb
  ```
