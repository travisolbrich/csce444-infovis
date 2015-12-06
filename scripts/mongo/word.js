db.getCollection('groups').find({}).forEach(function (group) {
    group.name.replace(/\W+/g, " ").split(" ").forEach(function (word) {
       if(word != "") {
           db.getCollection('words').insert({
               groupId: group.id,
               word: word
           });
       }; 
    });
});