db.getCollection('raw-data').find({}).forEach(function(user) {
    user.following.forEach(function(u) {
        print(user.id + '||' + u.userId ); 
    })
});