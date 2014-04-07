// requires jQuery

var SC = SC || {};

SC.SkyClock = {

  drawPlanet : function(ctx,angle) {
    var mid = 200;
    ctx.beginPath();
    ctx.moveTo(mid, mid);
    var length = 150;
    var x = mid + length * Math.cos(angle);
    var y = mid + length * Math.sin(angle);
    ctx.lineTo(x, y);
    ctx.lineWidth = 10;
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(mid, mid, 15, 0, Math.PI * 2, true);
    ctx.closePath();
    ctx.fillStyle = "#000000";
    ctx.fill();

    planet_image = new Image();
    planet_image.src = 'images/jupiter.jpg';
    planet_image.onload = function() {
      ctx.drawImage(planet_image, x, y);
    }

  },

  
  startUp : function() {
    SC.SkyClock.showSky();
  	// See http://davywybiral.blogspot.com/2011/11/planetary-states-api.html
    /*
    var url = 'http://www.astro-phys.com/api/states?callback=?';
    $.getJSON(url, {bodies: 'sun,mercury,venus,earth,moon,mars,jupiter,saturn'}, function(data) {
	 	  SC.SkyClock.showData(data.results);
	  });
    */

    // http://www.astro-phys.com/api/de406/states?bodies=sun,moon,mercury,venus,earth,mars,jupiter,saturn
    var url = 'http://www.astro-phys.com/api/de406/states?bodies=sun,moon,mercury,venus,mars,jupiter,saturn';
    jQuery.getJSON(url, function(data) {
      var p = data.results.mercury[0];
      var v = data.results.mercury[1];
      alert('Position:\nx='+p[0]+'\ny='+p[1]+'\nz='+p[2]);
      alert('Velocity:\nx='+v[0]+'\ny='+v[1]+'\nz='+v[2]);
    });

  },

  showData : function(results) {
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
      + "Sun: "     + pSun[0] + " " + pSun[1] + " " + pSun[2] + "<br/>"
      + "Mercury: " + pMercury[0] + " " + pMercury[1] + " " + pMercury[2] + "<br/>"
      + "Venus: "   + pVenus[0] + " " + pVenus[1] + " " + pVenus[2] + "<br/>"
      + "Earth: "   + pEarth[0] + " " + pEarth[1] + " " + pEarth[2] + "<br/>"
      + "Moon: "    + pMoon[0] + " " + pMoon[1] + " " + pMoon[2] + "<br/>"
      + "Mars: "    + pMars[0] + " " + pMars[1] + " " + pMars[2] + "<br/>"
      + "Jupiter: " + pJupiter[0] + " " + pJupiter[1] + " " + pJupiter[2] + "<br/>"
      + "Saturn: "  + pSaturn[0] + " " + pSaturn[1] + " " + pSaturn[2] + "<br/>"
    );

  },

  showSky : function() {
    var canvas = $('#canvas')[0];
    var ctx = canvas.getContext("2d"); 
    var angle = 45 * Math.PI/180;
    SC.SkyClock.drawPlanet(ctx, angle);
    angle = 120 * Math.PI/180;    
    SC.SkyClock.drawPlanet(ctx, angle);

  }

}
