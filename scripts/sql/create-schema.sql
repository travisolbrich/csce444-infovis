CREATE DATABASE `flickr`;
use `flickr`;

CREATE TABLE `groups` (
  `groupId` varchar(45) NOT NULL,
  `name` varchar(100) NOT NULL,
  `isInvitationOnly` tinyint(4) NOT NULL,
  `userCount` int(11) NOT NULL,
  `photoCount` int(11) NOT NULL,
  `trackedUserCount` int(11) NOT NULL,
  PRIMARY KEY (`groupId`),
  UNIQUE KEY `groupId_UNIQUE` (`groupId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `userId` varchar(45) NOT NULL,
  `nickname` varchar(45) NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `userId_UNIQUE` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `group_relations` (
  `groupAId` varchar(45) NOT NULL,
  `groupBId` varchar(45) NOT NULL,
  `memberCount` int(11) NOT NULL,
  PRIMARY KEY (`groupAId`,`groupBId`),
  KEY `uid_idx` (`groupAId`),
  KEY `gbid` (`groupBId`),
  CONSTRAINT `gaid` FOREIGN KEY (`groupAId`) REFERENCES `groups` (`groupId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `gbid` FOREIGN KEY (`groupBId`) REFERENCES `groups` (`groupId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `groups_users` (
  `groupId` varchar(45) NOT NULL,
  `userId` varchar(45) NOT NULL,
  `isAdmin` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`groupId`,`userId`),
  KEY `uid_idx` (`userId`),
  CONSTRAINT `gid` FOREIGN KEY (`groupId`) REFERENCES `groups` (`groupId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `uid` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
