// requires jQuery

var SC = SC || {};

SC.SkyClock = {
  
  startUp : function() {
  	// See http://davywybiral.blogspot.com/2011/11/planetary-states-api.html
    var url = 'http://www.astro-phys.com/api/states?callback=?';
    $.getJSON(url, {bodies: 'sun,mercury,venus,earth,moon,mars,jupiter,saturn'}, function(data) {
	 	  SC.SkyClock.showSky(data.results);
	  });
  },

  showSky : function(results) {
    var td = new Date();

  	var pMercury = results.mercury[0];
  	var pVenus   = results.venus[0];
  	var pSun     = results.sun[0];
  	var pEarth   = results.earth[0];
  	var pMoon    = results.moon[0];
    var pMars    = results.mars[0];
    var pJupiter = results.jupiter[0];
    var pSaturn  = results.saturn[0];

    $(".time").html(
      "Today is " + td.toDateString() + "<br/>"
      + "Sun: " + pSun[0] + " " + pSun[1] + " " + pSun[2] + "<br/>"
      + "Mercury: " + pMercury[0] + " " + pMercury[1] + " " + pMercury[2] + "<br/>"
      + "Venus: " + pVenus[0] + " " + pVenus[1] + " " + pVenus[2] + "<br/>"
      + "Earth: " + pEarth[0] + " " + pEarth[1] + " " + pEarth[2] + "<br/>"
      + "Moon: " + pMoon[0] + " " + pMoon[1] + " " + pMoon[2] + "<br/>"
      + "Mars: " + pMars[0] + " " + pMars[1] + " " + pMars[2] + "<br/>"
      + "Jupiter: " + pJupiter[0] + " " + pJupiter[1] + " " + pJupiter[2] + "<br/>"
      + "Saturn: " + pSaturn[0] + " " + pSaturn[1] + " " + pSaturn[2] + "<br/>"
    );

  }
}
