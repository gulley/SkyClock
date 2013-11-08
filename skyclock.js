// requires jQuery

var SC = SC || {};

SC.SkyClock = {
  
  startUp : function() {
  	// See http://davywybiral.blogspot.com/2011/11/planetary-states-api.html
  	var url = 'http://www.astro-phys.com/api/states?callback=?';
	$.getJSON(url, {bodies: 'sun,mercury,venus,earth,moon,mars'}, function(data) {
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

    $(".time").html(
      "Today is " + td.toDateString() + "<br/>"
      + "The Sun can be found at " + pSun[0] + " " + pSun[1] + " " + pSun[2] + "<br/>"
      + "Mercury can be found at " + pMercury[0] + " " + pMercury[1] + " " + pMercury[2] + "<br/>"
      + "Venus can be found at " + pVenus[0] + " " + pVenus[1] + " " + pVenus[2] + "<br/>"
      + "Earth can be found at " + pEarth[0] + " " + pEarth[1] + " " + pEarth[2] + "<br/>"
      + "Moon can be found at " + pMoon[0] + " " + pMoon[1] + " " + pMoon[2] + "<br/>"
      + "Mars can be found at " + pMars[0] + " " + pMars[1] + " " + pMars[2] + "<br/>"
    );

    // To get geocentric angles, subject earth position from sun and a planet at a time
    // Use: cos(theta) = (px1*px2 + py1*py2 + pz1*pz2)/ ...
    //                (sqrt(px1^2 + py1^2 + pz1^2) * sqrt(px2^2 + py2^2 + pz2^2))
    // Ref: http://www.geom.uiuc.edu/docs/reference/CRC-formulas/node54.html

    /*
          98275   -322455  -153737
		9437030  39803620 20312736
		107593109  15250412    50745
		103588052  97031536 42050274
		 103701377  96699886 41941231
		-163790305 165861119 80494766
    */
  }
}
