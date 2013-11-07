// requires jQuery

var SC = SC || {};

SC.SkyClock = {
  
  startUp : function() {
  	// See http://davywybiral.blogspot.com/2011/11/planetary-states-api.html
  	var url = 'http://www.astro-phys.com/api/states?callback=?';
	$.getJSON(url, {bodies: 'mercury'}, function(data) {
  		var pMercury = data.results.mercury[0];
		SC.SkyClock.showSky(pMercury);
	});
  },

  showSky : function(pMercury) {
    var td = new Date();

    $(".time").html(
      "Today is " + td.toDateString() + "<br/>"
      + "Mercury can be found at " + pMercury[0] + " " + pMercury[1] + " " + pMercury[2] + "<br/>"
    );

  }
}
