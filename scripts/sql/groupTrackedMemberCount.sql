select count(*) from 
	(SELECT g.groupId as groupA, g.name as nameA, u.userId, u.nickname FROM flickr.`groups` g 

	join groups_users gu on g.groupId = gu.groupId
	join users u on gu.userId = u.userId

	where g.groupId = '11252682@N00') a

join 

	(SELECT g.groupId as groupB, g.name as nameB, u.userId, u.nickname FROM flickr.`groups` g 

	join groups_users gu on g.groupId = gu.groupId
	join users u on gu.userId = u.userId

	where g.groupId = '1328110@N24') b

on a.userId = b.userId

