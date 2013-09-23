// requires jQuery

var SC = SC || {};

SC.SkyClock = {
  
  startUp : function() {
    var url = "http://www.astro-phys.com/api/api/de406/states?date=1000-1-20&bodies=mars";
    $.getJSON( url, args, SC.SkyClock.getData );
  },

  getData : function(data) {
    var items = [];
    $.each( data, function( key, val ) {
      items.push( "<li id='" + key + "'>" + val + "</li>" );
    });
   
    $( "<ul/>", {
      "class": "my-new-list",
      html: items.join( "" )
    }).appendTo( "body" );

    SC.SkyClock.showSky();
  },

  showSky : function() {
    var td = new Date();

    $(".time").html(
      "Today is " + td.toDateString()
    );
  }
}
