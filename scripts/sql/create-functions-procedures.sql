use `flickr`;


/**
	Simple function that counts the number of members that two given groups share.
**/
DELIMITER $$
CREATE FUNCTION `count_same_members`(groupA VARCHAR(40), groupB VARCHAR(40)) RETURNS int(11)
BEGIN

DECLARE c int;

select count(*) into c from 
	(SELECT g.groupId, g.name, u.userId, u.nickname FROM flickr.`groups` g 

	join groups_users gu on g.groupId = gu.groupId
	join users u on gu.userId = u.userId

	where g.groupId = groupA) a

join 

	(SELECT g.groupId, g.name, u.userId, u.nickname FROM flickr.`groups` g 

	join groups_users gu on g.groupId = gu.groupId
	join users u on gu.userId = u.userId

	where g.groupId = groupB) b

on a.userId = b.userId;

RETURN c;

END$$
DELIMITER ;

/**
	Given two groups, create a new relation with the number of shared users.
**/
DELIMITER $$
CREATE PROCEDURE `update_group_relation`(groupA VARCHAR(24), groupB VARCHAR(24))
BEGIN
insert ignore into group_relations values(groupA, groupB, (select count_same_members(groupA, groupB)));
END$$
DELIMITER ;

/**
	Given a "from" group, create relations TO all groups that have more than a certain number of tracked users.
**/
DELIMITER $$
CREATE PROCEDURE `update_group_relation_for_group`(fromGroup varchar(24), groupMinSize int)
BEGIN

  DECLARE done BOOLEAN DEFAULT FALSE;
  DECLARE _id varchar(24);
  DECLARE cur CURSOR FOR SELECT groupId from groups where groupId != fromGroup and trackedUserCount > groupMinSize;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done := TRUE;

  OPEN cur;

  testLoop: LOOP
    FETCH cur INTO _id;
    IF done THEN
      LEAVE testLoop;
    END IF;
    call update_group_relation(fromGroup, _id);
  END LOOP testLoop;

  CLOSE cur;

END$$
DELIMITER ;

/**
	Create relations for all groups of at least a certain size TO groups of at least a certain size.
    To explore all relations for all groups given, the from and two sizes should be equal.
**/ 
DELIMITER $$
CREATE PROCEDURE `update_group_relation_for_range`(fromGroupMinSize int, toGroupMinSize int)
BEGIN

  DECLARE done BOOLEAN DEFAULT FALSE;
  DECLARE _id varchar(24);
  DECLARE cur CURSOR FOR SELECT groupId from groups where trackedUserCount > fromGroupMinSize;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done := TRUE;

  OPEN cur;

  testLoop: LOOP
    FETCH cur INTO _id;
    IF done THEN
      LEAVE testLoop;
    END IF;
    call update_group_relation_for_group(_id, toGroupMinSize);
  END LOOP testLoop;

  CLOSE cur;

END$$
DELIMITER ;

