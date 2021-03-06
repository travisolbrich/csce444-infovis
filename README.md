# CSCE 444 Information Visualization Project
Visualizing Flickr communities and their users for CSCE 444 at TAMU



## Data Pre-Processing
Mongo is used to perform some minor transformation on the raw data set. This is then exported to CSV format and imported into SQL. MySQL then processes the data.

### Methods

The data we have been provided is in JSON format. It consists of some 30147 users, and these users are a part of 194085 unique groups. The data provided is in a user-centric format.

Because the data is user-focused, pre-processing is required to get the groups out of each user object. Since the data is already in JSON, Mongo is for this phase of preprocessing. We first get the raw data into Mongo:

```
--db flickr-test --collection raw-data --type json --file flickr100k-users
```

Next, we want to process this data to extract group data from each user, give each group a list of users, and give each group a count of the number of tracked users. This can be done by running the [preprocess.js](scripts/mongo/preprocess.js) file. This will likely take in excess of an hour on the full data set.

```
mongo localhost/flickr-test scripts/mongo/preprocess.js
```

We now want to to perform some heavy relational operations (which Mongo is very poor at). This means we need to import the data into a relational database, and MySQL will be used. Therefore we must export the data to CSV so it can be re-imported into MySQL.

```
mongo --quiet localhost/flickr-test scripts/mongo/get-users.js > exports/users.csv
mongo --quiet localhost/flickr-test scripts/mongo/get-groups.js > exports/groups.csv
mongo --quiet localhost/flickr-test scripts/mongo/get-groups-users.js > exports/groups-users.csv
mongo --quiet localhost/flickr-test scripts/mongo/get-users-following.js > exports/users-following.csv
```

We must now create the schema in MySQL. In MySQL workbench the [create-schema.sql](scripts/sql/create-schema.sql) and [create-functions-procedures.sql](scripts/sql/create-functions-procedures.sql) scripts should be run. 

Finally, run the `update_group_relation_for_range` procedure. Use the parameters to reduce the data set to process. On my computer, processing with both parameters at `500` created several million rows and took about two days to run. 

This completes the preprocessing for our data.