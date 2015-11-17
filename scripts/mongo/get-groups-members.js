db.getCollection('groups').find({}, {groupId: 1, members: 1}).forEach(function(group) {
    group.members.forEach(function(member) {
	print(group.groupId + "||" + member.userId + "||" + member.isAdmin); 
    })
})