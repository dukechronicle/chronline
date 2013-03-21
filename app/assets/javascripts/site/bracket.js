var depth       = 35;
var teamWidth   = 70
var regionspace = 90;
var finalspace  = 100;
var img_width   = 20;
var img_height  = 20;
var orig_x      = 25;
var orig_y      = 40;
var data;
var $dialog = $([]);
var coords = [];
var score_coords = [];



var drawCanvasImage = function(ctx, image,x,y) {
  return function() {
    ctx.drawImage(image, x,y,img_width,img_height);
  }
}
initialize("#bracket", function() {
    data = $("#bracket_data").data("bracket").table;
    $(this).click(function (e) {
        if (e.offsetX === undefined && e.offsetY === undefined) {
            e.offsetX = e.pageX - e.target.offsetLeft;
            e.offsetY = e.pageY - e.target.offsetTop;
        }
        if (index = teamFromLocation(e.offsetX, e.offsetY)) {
            team = data.teams[index];
            $dialog.remove();
            $dialog = $("<div>")
            $dialog.attr('title', team.school);
            $dialog.html(team.description);
            $dialog.dialog({width : 650});
        }
    });
    draw();
});



function updateRound(ctx, round, info){
  nextCoords = [];
  for(i in info){
    ctx.textAlign = 'right';  
    var updates = info[i];
    var xy      = score_coords[i];
    var score   = "(" + updates.score1 + "-" + updates.score2 + ")";

    if(i < 32/(Math.pow(2, round+1))){
      ctx.fillText(score, xy[0] + teamWidth/2, xy[1]);
    } else {
      ctx.textAlign = 'left';
      ctx.fillText(score, xy[0] - teamWidth/2,xy[1]);
    }

    var index;
    if(updates.score1 > updates.score2){ 
      index = updates.team1;
    } else {
      index = updates.team2;
    }
    var winner = data.teams[index];
    
    ctx.textAlign = "left";

    if(i < 32/(Math.pow(2, round+1))){
      ctx.fillText(winner.school + "("+winner.seed+")", xy[0] + teamWidth+3, xy[1]-3);
      nextCoords.push([xy[0]+teamWidth,xy[1]+(depth*(i+1))]);
    } else{
      ctx.textAlign = "right";
      ctx.fillText(winner.school + "("+winner.seed+")", xy[0] - teamWidth-3, xy[1]-3);
      nextCoords.push([xy[0]-teamWidth,xy[1]+(depth*(i+1))]);
    }
  }
  score_coords = nextCoords;
}

function drawImages(ctx, canvas){
  var team_data = data.teams;
  for(i in coords){
    var pic = new Image();
    pic.src = team_data[i].image;
    if(i<32) {
      pic.onload = drawCanvasImage(ctx, pic, 0, coords[i][2]-(img_height/2));
    } else{
      pic.onload = drawCanvasImage(ctx, pic, canvas.width-img_width, coords[i][2]-(img_height/2));
    }
  }
}
function teamFromLocation(x,y){
  for(i in coords){
    var team = coords[i];
    var t_x = team[1];
    var t_y = team[2];

    var x_dist = Math.abs(x - t_x);
    var y_dist = Math.abs(y - t_y);

    if(x_dist <= teamWidth){
      if(y_dist<=depth/3){
        return i
      }
    }

  }
  return undefined;
}

function drawRound(ctx, x, y, round, left){
  l=1;
  if(!left){
    l=-1;
  }
  var j = 4 - round
  for(var i=0;i<Math.pow(2,j);i++){
    ctx.beginPath();
    ctx.moveTo(x, y);
    ctx.lineTo(x+l*teamWidth, y);
    ctx.lineTo(x+l*teamWidth, y+depth*Math.pow(2,round-1));
    ctx.lineTo(x, y+depth*Math.pow(2,round-1));
    ctx.stroke();
    y+=2*depth*Math.pow(2,round-1)
    
  }
}

function writeTeams(ctx, x, y, round, left, count){
    ctx.font = "normal 6.3pt Arial"
    l=1;
    if(!left){
      l=-1;
    }
    var j = 4 - round;
    var teams = data.teams;
    firstseed = teams[0].school;
    for(var i=0;i<Math.pow(2,j);i++){
      if(count+1 < teams.length){
      player = teams[count];
      player2 = teams[count+1];
      if(left == true){
        ctx.fillText(player.school + "  ("+(player.seed)+")", x, y-5);
        coords.push([player.school, x, y-5]);
        score_coords.push([x,y+(depth/2)]);
        var next_y = y+depth*Math.pow(2,round-1)-5;
        ctx.fillText(player2.school + "  ("+(player2.seed)+")", x, next_y);
        coords.push([player.school, x, next_y]);
      }
      else{ 
      ctx.textAlign = 'right';  
      ctx.fillText("("+(player.seed)+")  " + player.school, x, y-5);  
      coords.push([player.school, x, y-5]);
      score_coords.push([x, y+(depth/2)]);
      var next_y = y+depth*Math.pow(2,round-1)-5;
      ctx.fillText("("+(player2.seed)+")  " + player2.school, x, next_y); 
      coords.push([player2.school, x, next_y]);
      ctx.textAlign = 'left';
      }
      y+=2*depth*Math.pow(2,round-1)
      count = count +2;
      }
    }
  }

function draw(){
  var canvas = document.getElementById("bracket");
  var ctx = canvas.getContext("2d");
  var x = orig_x;
  var y = orig_y;
  //Midwest
  for(var i=1; i<5;i++){
    drawRound(ctx,x+teamWidth*(i-1), (y-(depth/2))+(depth/2)*Math.pow(2,i-1),i, true);
  }

  //text for first round
  for(var i=1; i<2;i++){
    //top left
    writeTeams(ctx,x+teamWidth*(i-1), (y-(depth/2))+(depth/2)*Math.pow(2,i-1),i, true,0);
    //bottom left
    y=8*(depth*2)+regionspace;      
    writeTeams(ctx,x+teamWidth*(i-1), (y-(depth/2))+(depth/2)*Math.pow(2,i-1),i, true,16);
    //top right
    x+= 6*teamWidth+finalspace+6*teamWidth;
    y= orig_y;
    writeTeams(ctx,x+teamWidth*(i-1), (y-(depth/2))+(depth/2)*Math.pow(2,i-1),i, false,32);
    //bottom right
    y=8*(depth*2)+regionspace;
    writeTeams(ctx,x+teamWidth*(i-1), (y-(depth/2))+(depth/2)*Math.pow(2,i-1),i, false,48);
  }
  var x = orig_x;
  var y = orig_y;


  //draw final dash for mid west
  var mw_y_end = y+15*depth;
  var mw_mid = (y+mw_y_end)/2;
  ctx.moveTo(x+4*teamWidth, mw_mid);
  ctx.lineTo(x+5*teamWidth, mw_mid);
  ctx.stroke();
  
  //West
  y=8*(depth*2)+regionspace;
  for(var i=1; i<5;i++){
    drawRound(ctx,x+teamWidth*(i-1), (y-(depth/2))+(depth/2)*Math.pow(2,i-1),i, true)
  }
  
  //draw final dash for west and connect to midwest
  w_y_end = y+15*depth;
  w_mid = (y+w_y_end)/2;
  ctx.moveTo(x+4*teamWidth, w_mid);
  ctx.lineTo(x+5*teamWidth, w_mid);
  ctx.lineTo(x+5*teamWidth, mw_mid)
  ctx.stroke();
  
  //final left dash
  left_mid = (w_mid+mw_mid)/2;
  ctx.moveTo(x+5*teamWidth, left_mid);
  ctx.lineTo(x+6*teamWidth, left_mid);
  ctx.stroke();
  
  //start right side

  //south
  x+= 6*teamWidth+finalspace+6*teamWidth;
  y=orig_y;
  for(var i=1; i<5;i++){
    drawRound(ctx,x-teamWidth*(i-1), (y-(depth/2))+(depth/2)*Math.pow(2,i-1),i,false)
  }

  //draw final dash for south
  var s_y_end = y+15*depth;
  var s_mid = (y+mw_y_end)/2;
  ctx.moveTo(x-4*teamWidth, s_mid);
  ctx.lineTo(x-5*teamWidth, s_mid);
  ctx.stroke();

  //East
  y=8*(depth*2)+regionspace;
  for(var i=1; i<5;i++){
    drawRound(ctx,x-teamWidth*(i-1), (y-(depth/2))+(depth/2)*Math.pow(2,i-1),i,false)
  }

  //draw final dash for east and connect to south
  e_y_end = y+15*depth;
  e_mid = (y+w_y_end)/2;
  ctx.moveTo(x-4*teamWidth, e_mid);
  ctx.lineTo(x-5*teamWidth, e_mid);
  ctx.lineTo(x-5*teamWidth, s_mid)
  ctx.stroke();

  //final right dash
  right_mid = (s_mid+e_mid)/2;
  ctx.moveTo(x-5*teamWidth, left_mid);
  ctx.lineTo(x-6*teamWidth, left_mid);
  ctx.stroke();
  
  drawImages(ctx, canvas);

  var standings = data.standings;
  for( i in standings){
    updateRound(ctx, i, standings[i]);
  }


  var img = new Image();
  img.onload = function(){
    logo_img_width = 200;
    logo_img_height = 200;
    ctx.drawImage(img, x-6*teamWidth- finalspace/2 - logo_img_width/2, orig_y+ .8*depth, logo_img_width ,logo_img_height);
  }

  img.src = "http://upload.wikimedia.org/wikipedia/en/4/47/2013NCAAMensFinalFourLogo.jpeg";
  
  


  
  }
