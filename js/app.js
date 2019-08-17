var converter = new showdown.Converter();

var d = new Date();
var day = ('0' + d.getDate()).slice(-2);
var month = ('0' + (d.getMonth() + 1)).slice(-2);
var year =  d.getFullYear();

function loader() {
	try {
		URL = window.location.href.split('?');
		var args = URL[1].split('=');

		if (args[0] == 'post') {
			getPost(args[1]);
			document.title = 'Blix | ' + args[1];
		} else if (args[0] == 'archive') {
			getArchiveYear(args[1]);
			document.title = 'Blix | ' + args[1];
		} else {
			getPost('404');
		}
	} catch(TypeError) {
		getCurrentPosts();
	}
}

function getCurrentPosts() {
	for (i = 32; i > 0; i--) {
		var post = year + '-' + month + '-' + ('0' + i).slice(-2);

		try {
			jQuery.get('/blog/posts/' + post + '.md', function(txt) {
				var file = txt.split("----------");
				var head = file[0].split("\n");

				cardPost(head[0], head[1]);
			});
		} catch(err) {
			document.getElementById("output").innerHTML = err.message;
		}
	}
}

function getPost(args) {
	var post = '/blog/posts/' + args + '.md';

	try {
		jQuery.get(post, function(txt) {
			var file = txt.split("----------");
			var head = file[0].split("\n");
			var body = converter.makeHtml(file[1]);

			fullPost(head[0], body, head[1]);
		}).fail(function() {
			getPost('404');
		});
	} catch(err) {
		document.getElementById("output").innerHTML = err.message;
	}
}

function getArchiveYear(args) {
	var day = 1;
	var month = 1;
	var post = '';

	for (month = 1; month < 13; month++) {
		for (day = 1; day < 32; day++) {
			post = '/blog/posts/' + args + '-' + ('0' + (month + 1)).slice(-2) + '-' + ('0' + (day + 1)).slice(-2) + '.md';
			try {
				jQuery.get(post, function(txt) {
					var md = txt.split("----------");
					var head = md[0].split("\n")
					var title = head[0];
					var date = head[1];
					
					listPost(title, date);
				});
			}
			catch(err) {
				document.getElementById("output").innerHTML = err.message;
			}
		}
	}
}

function listPost(title, date) {
	item = document.createElement("li");
	item.innerHTML = '<a href="?post=' + date.replace('/', '-').replace('/', '-') + '">' + date + ' | ' + title + '</a>';
	output = document.getElementById("output").appendChild(list);
}

function cardPost(title, date) {
	card = document.createElement("card");
	card.innerHTML = '<h3><a href="?post=' + date.replace('/', '-').replace('/', '-') + '">' + title + '</a></h3><hr><h6 txt="r">' + date + '</h6>';
	output = document.getElementById("output").appendChild(card);
}

function fullPost(title, body, date) {
	card = document.createElement("card");
	card.innerHTML = '<h1>' + title + '</h1><hr>' + body + '<hr><h6 txt="r">' + date + '</h6>';
	output = document.getElementById("output").appendChild(card);
}

