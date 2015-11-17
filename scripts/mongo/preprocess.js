var rawDataCollection = 'raw-data';
var groupCollection = 'groups';

// Create groups from all of the users we have
var users = db.getCollection(rawDataCollection).find({'groups.0': {$exists: true}});

users.forEach(function (user) {
    user.groups.forEach(function (group) {
        db.getCollection(groupCollection).insert(group)
    })
});

// Make field names better
db.getCollection(groupCollection).update({}, {$unset: {isAdmin: ""}, $rename: {'members': 'memberCount', 'photos': 'photoCount'}}, false, true);

// Add users to their groups 
var users = db.getCollection(rawDataCollection).find({'groups.0': {$exists: true}});

users.forEach(function (user) {
    user.groups.forEach(function (group) {
        var groupId = group.groupId;
        db.getCollection(groupCollection).update({groupId: groupId}, {$addToSet: {members: {userId: user.id, isAdmin: group.isAdmin}}});
    })
});

// Update group user counts
db.getCollection(groupCollection).find({}). forEach(function(group) {
    group.trackedMemberCount = eval('group.members.length');
    db.getCollection(groupCollection).save(group);
})