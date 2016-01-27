var Git = require("nodegit");
var Path = require("path");
Git.Repository.open(Path.resolve("..")).then(function(repo){
	console.log("ASDF");
    repo.getStatus().then(function(statuses) {
	  console.log("ASDF");
      function statusToText(status) {
        var words = [];
        if (status.isNew()) { words.push("NEW"); }
        if (status.isModified()) { words.push("MODIFIED"); }
        if (status.isTypechange()) { words.push("TYPECHANGE"); }
        if (status.isRenamed()) { words.push("RENAMED"); }
        if (status.isIgnored()) { words.push("IGNORED"); }

        return words.join(" ");
      }

      statuses.forEach(function(file) {
        console.log(file.path() + " " + statusToText(file));
      });
    });
});
