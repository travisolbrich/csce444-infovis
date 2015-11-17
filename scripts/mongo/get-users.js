//print(""id", "nickname"");
db.getCollection('raw-data').find({}, {id: 1, nickname: 1}).forEach(function(user) {
    print(user.id + '||' + user.nickname);
});