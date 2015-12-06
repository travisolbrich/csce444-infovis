select * from words mcw
join group_relations gr on gr.groupAId = mcw.groupId

 where lower(mcw.word) = 'art'
 and gr.groupBId in (select groupId from words where lower(word) = 'art')