// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

String.prototype.format = function (args) {
  var str = this;
  return str.replace(String.prototype.format.regex, function(item) {
    var intVal = parseInt(item.substring(1, item.length - 1));
    var replace;
    if (intVal >= 0) {
      replace = args[intVal];
    } else if (intVal === -1) {
      replace = "{";
    } else if (intVal === -2) {
      replace = "}";
    } else {
      replace = "";
    }
    return replace;
  });
};
String.prototype.format.regex = new RegExp("{-?[0-9]+}", "g");

function confirmation(s,f){if(confirm(s)){f.submit();}}
function hide(n){document.getElementById(n).style.display='none';}
function show(m){document.getElementById(m).style.display='';}
function show2(m){document.getElementById(m).style.display='';if(document.getElementById('ongletVisible')){if(m.substring(0,7)=='Plateau'){document.getElementById('ongletVisible').value=m.substring(7);}}}
function change_style(o,s){document.getElementById(o).className=s;}
function addSmiley(s){if(document.getElementById('texteChat')){var t=document.getElementById('texteChat');t.value+=' :'+s+': ';t.focus();t.selectionStart+=s.length+4;}}
sfHover=function(){var sfEls=document.getElementById("menu").getElementsByTagName("LI");for(var i=0;i<sfEls.length;i++){sfEls[i].onmouseover=function(){this.className+=" sfhover";}
sfEls[i].onmouseout=function(){this.className=this.className.replace(new RegExp(" sfhover\\b"),"");}}
sfEls=document.getElementById("partnership").getElementsByTagName("LI");for(i=0;i<sfEls.length;i++){sfEls[i].onmouseover=function(){this.className+=" sfhover";}
sfEls[i].onmouseout=function(){this.className=this.className.replace(new RegExp(" sfhover\\b"),"");}}
sfEls=document.getElementById("contenu").getElementsByTagName("LI");for(i=0;i<sfEls.length;i++){sfEls[i].onmouseover=function(){this.className+=" sfhover";}
sfEls[i].onmouseout=function(){this.className=this.className.replace(new RegExp(" sfhover\\b"),"");}}}
function getOffset(element){var top=0,left=0;do{top+=element.offsetTop;left+=element.offsetLeft;}while(element=element.offsetParent);return{top:top,left:left};}
if(window.attachEvent)window.attachEvent("onload",sfHover);
function spend_down(element) {
  var v = parseInt(element.value);
  v -= 1;
  element.value = v.toString();
  spend_update(element, undefined);
}
function spend_up(element, max) {
  var v = parseInt(element.value);
  v += 1;
  element.value = v.toString();
  spend_update(element, max);
}
function spend_update(element, max) {
  if (element != undefined) {
    var v = parseInt(element.value);
    if (v > 0) { show(element.id + "_down"); }
    else {
      hide(element.id + "_down");
      v = 0; 
    }
    if (max == undefined || v < max) { show(element.id + "_up"); }
    else { 
      hide(element.id + "_up");
      v = max;
    }
    element.value = v.toString();
  }

  var fuel = 0.0;
  tblFuel = document.getElementById("tbl_game_resource_spend_fuel");
  if (tblFuel != undefined) {
    var inputs = tblFuel.getElementsByTagName("input");
    for (var i=0; i<inputs.length; i++)
    {
      var mult = 0;
      switch (inputs[i].id.split("_")[3])
      {
        case "1": /* Wood */
        mult = 1;
        break;
        case "2": /* Peat */
        mult = 2;
        break;
        case "13": /* Peatcoal */
        mult = 3;
        break;
        case "14": /* Straw */
        mult = 0.5;
        break;
      }
      fuel += mult * parseInt(inputs[i].value);
    }
    var rsfuc = document.getElementById("resource_spend_50_count");
    rsfuc.innerHTML = fuel.toString();
    var rsfun = document.getElementById("resource_spend_50_needed");
    if (rsfun != undefined)
    {
      var rsfunI = parseFloat(rsfun.innerHTML);
      rsfuc.className = fuel >= rsfunI ? (fuel > rsfunI ? "warning" : "valid") : "invalid";
    }
  }

  var food = 0.0;
  tblFood = document.getElementById("tbl_game_resource_spend_food");
  if (tblFood != undefined) {
    var inputs = tblFood.getElementsByTagName("input");
    for (var i=0; i<inputs.length; i++)
    {
      var mult = 0;
      switch (inputs[i].id.split("_")[3])
      {
        case "3": /* Grain */
        case "6": /* Coin */
        case "9": /* Grapes */
        case "10": /* Malt */
        case "11": /* Flour */
        case "20": /* Wine */
        mult = 1;
        break;
        case "4": /* Livestock */
        case "12": /* Whiskey */
        mult = 2;
        break;
        case "22": /* Bread */
        mult = 3;
        break;
        case "7": /* Coinx5 */
        case "15": /* Meat */
        case "21": /* Beer */
        mult = 5;
        break;
      }
      food += mult * parseInt(inputs[i].value);
    }
    var rsfoc = document.getElementById("resource_spend_51_count")
    rsfoc.innerHTML = food.toString();
    var rsfon = document.getElementById("resource_spend_51_needed");
    if (rsfon != undefined)
    {
      var rsfonI = parseFloat(rsfon.innerHTML);
      rsfoc.className = food >= rsfonI ? (food > rsfonI ? "warning" : "valid") : "invalid";
    }
  }

  var vps = 0.0;
  tblVps = document.getElementById("tbl_game_resource_spend_vps");
  if (tblVps != undefined) {
    var inputs = tblVps.getElementsByTagName("input");
    for (var i=0; i<inputs.length; i++)
    {
      var mult = 0;
      switch (inputs[i].id.split("_")[3])
      {
        case "12": /* Whiskey */
        mult = 1;
        break;
        case "7": /* Coin X 5 */
        case "17": /* Book */
        mult = 2;
        break;
        case "16": /* Ceramic */
        mult = 3;
        break;
        case "19": /* Ornament */
        mult = 4;
        break;
        case "18": /* Reliquery */
        mult = 8;
        break;
      }
      vps += mult * parseInt(inputs[i].value);
    }
    var rsvpc = document.getElementById("resource_spend_52_count")
    rsvpc.innerHTML = vps.toString();
    var rsvpn = document.getElementById("resource_spend_52_needed");
    if (rsvpn != undefined)
    {
      var rsvpnI = parseFloat(rsvpn.innerHTML);
      rsvpc.className = vps >= rsvpnI ? (vps > rsvpnI ? "warning" : "valid") : "invalid";
    }
  }

  var eFuelFoodBreaks = document.getElementById("resource_gain_steps");
  if (eFuelFoodBreaks != undefined) {
    var resourceGainBreaks = eFuelFoodBreaks.value.split("|");
    for (var i=0; i < resourceGainBreaks.length; i++) {
      var resource = resourceGainBreaks[i].substring(0, resourceGainBreaks[i].indexOf(":"));
      var gainBreaks = resourceGainBreaks[i].substring(resourceGainBreaks[i].indexOf(":") + 1).split(";");
      var breaks_met = {};
      for (var j=0; j < gainBreaks.length; j++) {
        var spendResources = gainBreaks[j].substring(0, gainBreaks[j].indexOf("=")).split(',');
        var gainValue = parseInt(gainBreaks[j].substring(gainBreaks[j].indexOf("=") + 1));
        for (var k=0; k < spendResources.length; k++) {
          var spendResource = spendResources[k].substring(0, spendResources[k].indexOf(">"));
          var spendStep = parseFloat(spendResources[k].substring(spendResources[k].indexOf(">") + 1));

          var eSpendResourceAmount = document.getElementById("resource_spend_" + spendResource + "_count");
          if (eSpendResourceAmount == undefined) { continue; }
          var spendResourceAmount = parseFloat(eSpendResourceAmount.innerHTML);
          if (spendResourceAmount >= spendStep) {
            breaks_met[spendResource] = gainValue;
            if (spendResourceAmount > spendStep) { eSpendResourceAmount.className = "warning"; }
            else { eSpendResourceAmount.className = ""; }
          }
        }
      }
      var minBreak = false;
      for (var sr in breaks_met) {
        if (minBreak == false || breaks_met[sr] < minBreak) {
          minBreak = breaks_met[sr];
        }
      }
      for (var sr in breaks_met) {
        if (breaks_met[sr] > minBreak) {
          var eSpendResourceAmount = document.getElementById("resource_spend_" + sr + "_count");
          eSpendResourceAmount.className = "warning";
        }
      }
      for (var j=0; j < 2; j++) {
        var eGainValue = document.getElementById("resource_gain_" + j + "_" + resource);
        if (eGainValue == undefined) { continue; }
        eGainValue.innerHTML = minBreak;
      }
    } 
  }

  var eGainFactors = document.getElementById("resource_gain_factors");
  if (eGainFactors != undefined) {
    var resourceGainFactors = eGainFactors.value.split("|");
    for (var i=0; i < resourceGainFactors.length; i++) {
      var resourceGainFactor = resourceGainFactors[i].split(":");
      if (resourceGainFactor.length < 3) { continue; }
      var resSpend = resourceGainFactor[0];
      var factor = parseInt(resourceGainFactor[1]);
      var resGain = resourceGainFactor[2];
      var eSpendResourceAmount = document.getElementById("game_resource_spend_" + resSpend);
      if (eSpendResourceAmount == undefined) { continue; }
      var eGainValue = document.getElementById("game_resource_gain_" + resGain);
      if (eGainValue == undefined) { continue; }
      eGainValue.innerHTML = factor * parseInt(eSpendResourceAmount.value);
    }
  }
}
function gain_down(key) {
  var element = document.getElementById("game_resource_gain_" + key);
  if (element == undefined) { return; }
  var v = parseInt(element.value);
  v -= 1;
  element.value = v.toString();
  gain_update(key);
}
function gain_up(key) {
  var element = document.getElementById("game_resource_gain_" + key);
  if (element == undefined) { return; }
  var v = parseInt(element.value);
  v += 1;
  element.value = v.toString();
  gain_update(key);
}
function gain_update(key) {
  var element = document.getElementById("game_resource_gain_" + key);
  if (element == undefined) { return; }
  var v = parseInt(element.value);
  if (v < 0) { v = 0; }

  var rKeys = document.getElementById("resource_gain_keys");
  if (rKeys == undefined) { return; }
  rKeys = rKeys.value.split(',');

  sum = 0;
  var vals = {};
  for (var i=0; i<rKeys.length; i++)
  {
    var sGain = document.getElementById("resource_gain_count_" + rKeys[i]);
    var iGain = document.getElementById("game_resource_gain_" + rKeys[i]);
    if (sGain == undefined || iGain == undefined) { continue; }
    vals[rKeys[i]] = [parseInt(sGain.innerHTML), parseInt(iGain.value)];
    if (isNaN(vals[rKeys[i]][1])) { vals[rKeys[i]][1] = 0; }
    sum += vals[rKeys[i]][0] * vals[rKeys[i]][1];
  }

  var sSum = document.getElementById("resource_gain_52");
  if (sSum == undefined) { return; }

  var max = 0
  var eMax = document.getElementById("resource_gain_max");
  if (eMax == undefined) { return; }
  max = parseInt(eMax.innerHTML);

  while (sum > max)
  {
    v -= 1;
    sum -= vals[key][0];    
  }
  if (v > 0) { show(element.id + "_down"); }
  else { hide(element.id + "_down"); }

  var className = "warning";
  if (sum < max)
  {
    for (var i=0; i<rKeys.length; i++)
    {
      if (sum + vals[rKeys[i]][0] <= max) { show("game_resource_gain_" + rKeys[i] + "_up"); }
      else { hide("game_resource_gain_" + rKeys[i] + "_up"); }
      sSum.className = eMax.className = "warning";
    }
  }
  else
  {
    for (var i=0; i<rKeys.length; i++)
    {
      hide("game_resource_gain_" + rKeys[i] + "_up"); 
      sSum.className = eMax.className = "valid";
    }
  }
  element.value = v.toString();
  sSum.innerHTML = sum.toString();
}
function showSelect(e) {
  hide("game_action_basic");
  hide("game_action_build");
  hide("game_action_enter");
  hide("game_action_contract");
  hide("game_action_extra");
  show("bPlay");
  switch (e.options[e.selectedIndex].value)
  {
    case "0":
      hide("bPlay");
      break;
    case "201":
      show("game_action_basic");
      break;
    case "202":
      show("game_action_extra");
      break;
    case "203":
      show("game_action_build");
      break;
    case "204":
      show("game_action_enter");
      break;
    case "205":
      show("game_action_contract");
      break;
  }
}
function showDistrict(e, cost, position_y) {
  var district = "url(../assets/district" + cost + e.options[e.selectedIndex].value + ".png)";
  ndt = document.getElementById("tblNewDistrictTop");
  ndb = document.getElementById("tblNewDistrictBottom");
  if (ndt.style.backgroundImage != "")
  {
    ndt.style.backgroundImage = district;
  }
  if (ndb.style.backgroundImage != "")
  {
    ndb.style.backgroundImage = district;
  }
}
function selectTile(e, seatNumber, x, y, maxCount) {
  var newkey = '{0}:{1},{2}'.format([seatNumber, x, y]);
  var selectedTiles = document.getElementById("game_selected_tiles");
  var deselectTile = "";
  var deselectCard = "";
  if (selectedTiles.value.length > 0)
  {
    var re = new RegExp(";?"+newkey,"g");
    if (re.test(selectedTiles.value))
    {
      // This tile already exists in the list, so remove it, deselect it, and then return
      selectedTiles.value = selectedTiles.value.replace(re, "");
      if (selectedTiles.value.length > 0 && selectedTiles.value[0] == ";") { selectedTiles.value = selectedTiles.value.substring(1); }
      document.getElementById('dSF{0}_{1}_{2}'.format([seatNumber, x, y])).style.display = 'none';
      var dsbc = document.getElementById('dSBC{0}_{1}_{2}'.format([seatNumber, x, y]));
      if (dsbc) { dsbc.style.display = 'none'; }
      return;
    }
    var numItems = (selectedTiles.value.match(/;/g)||[]).length+1;
    if (numItems >= maxCount)
    {
      var iOldestSelection = selectedTiles.value.indexOf(';');
      if (iOldestSelection >= 0) { 
        deselectTile = 'dSF' + selectedTiles.value.substring(0, iOldestSelection).replace(':', '_').replace(',', '_');
        deselectCard = 'dSBC' + selectedTiles.value.substring(0, iOldestSelection).replace(':', '_').replace(',', '_');
        selectedTiles.value = selectedTiles.value.substring(iOldestSelection+1);
      }
      else
      {
        deselectTile = 'dSF' + selectedTiles.value.replace(':', '_').replace(',', '_');
        deselectCard = 'dSBC' + selectedTiles.value.replace(':', '_').replace(',', '_');
        selectedTiles.value = "";
      }
      document.getElementById(deselectTile).style.display = 'none';
      var dsbc = document.getElementById(deselectCard);
      if (dsbc) { dsbc.style.display = 'none'; }
    }
  }
  document.getElementById('dSF{0}_{1}_{2}'.format([seatNumber, x, y])).style.display = '';
  var dsbc = document.getElementById('dSBC{0}_{1}_{2}'.format([seatNumber, x, y]));
  if (dsbc) { dsbc.style.display = ''; }
  if (selectedTiles.value != "")
  {
    selectedTiles.value += ";";
  }
  selectedTiles.value += newkey;
}
function selectDistrict(e, cost, position_y) {
  var landscapePositionX = document.getElementById("game_landscape_position_x");
  var landscapePositionY = document.getElementById("game_landscape_position_y");
  var optDistrict = document.getElementById("game_action_landscape_side");
  var districtUrl = "url(../assets/district" + cost + optDistrict.options[optDistrict.selectedIndex].value + ".png)";
  ndt = document.getElementById("tblNewDistrictTop");
  ndb = document.getElementById("tblNewDistrictBottom");
  ndt.style.backgroundImage = ndb.style.backgroundImage = "";
  if (position_y.toString() != landscapePositionY.value)
  {
    if (position_y < 100) { ndt.style.backgroundImage = districtUrl; }
    else { ndb.style.backgroundImage = districtUrl; }
    landscapePositionX.value = "100";
    landscapePositionY.value = position_y;
  }
  else { landscapePositionX.value = landscapePositionY.value = ""; }
}
function selectPlot(e, cost, position_x, position_y) {
  var landscapePositionX = document.getElementById("game_landscape_position_x");
  var landscapePositionY = document.getElementById("game_landscape_position_y");
  var optPlot = document.getElementById("game_action_landscape_side");
  var plotUrl = "url(../assets/plot" + cost + (position_x > 100 ? "1" : "0") + ".png)";
  var allPaintableIds = document.getElementById("paintable_locations").value.split(":");
  for (var i=0; i<allPaintableIds.length; i++)
  {
    document.getElementById("tblNewPlot" + allPaintableIds[i]).style.backgroundImage = "";
  }
  if (position_y.toString() != landscapePositionY.value || position_x.toString() != landscapePositionX.value)
  {
    var p1 = document.getElementById("tblNewPlot" + (position_x > 100 ? "1" : "0") + position_y.toString());
    p1.style.backgroundImage = plotUrl;
    p1.style.backgroundPosition = "center top";
    var p2 = document.getElementById("tblNewPlot" + (position_x > 100 ? "1" : "0") + (position_y+1).toString());
    p2.style.backgroundImage = plotUrl;
    p2.style.backgroundPosition = "center bottom";
    landscapePositionX.value = position_x;
    landscapePositionY.value = position_y;
  }
  else { landscapePositionX.value = landscapePositionY.value = ""; }
}
function selectResourceSpend(e, exactRequired) {
  var child = e.parentNode.firstChild;
  var countSelected = 0;
  while (child)
  {
    if (child.id == "game_resource_spend_")
    { 
      if (child.checked)
      {
        countSelected += 1;
      }
    }
    child = child.nextSibling;
  }
  var countElem = document.getElementById("resource_spend_checked_count");
  countElem.innerHTML = countSelected.toString();
  countElem.className = countSelected == exactRequired ? "valid" : "invalid";
}
function selectResourceGain(e, resource, numberResources, uniqueRequired) {
  if (!uniqueRequired) { return; }

  for (var i=0; i<numberResources; i++)
  {
    tdResourceGain = document.getElementById("tdResourceGain_" + i.toString());

    var child = tdResourceGain.firstChild;
    while (child)
    {
      if (child.id != undefined && child.id.substring(0,19) == "game_resource_gain_")
      { 
        var isChecked = false;
        for (var j=0; j<numberResources; j++)
        {
          if (j == i) { continue; }
          if (document.getElementById("game_resource_gain_" + j.toString() + "__" + child.value).checked)
          {
            isChecked = true;
            child.disabled = true;
            break;
          }
        }
        if (!isChecked)
        {
          child.disabled = false;
        }
      }
      child = child.nextSibling;
    }
  }
}
function selectGainCount(e, idx, sres_map, gres_map) {
  var res_splits = sres_map.split(',');
  for (var i=0; i<res_splits.length; i++) {
    res = res_splits[i].split(':');
    if (res[0] != "50" && res[0] != "51") {
      continue;
    }
    var eSpend = document.getElementById("resource_spend_" + idx + "_" + res[0]);
    if (eSpend != undefined) {
      eSpend.value = parseFloat(res[1]) * parseInt(e.value);
    }
  }

  for (var r=50; r<52; r++) {
    var sum = 0.0
    for (var i=0; i<2; i++) {
      var eSpend = document.getElementById("resource_spend_" + i + "_" + r);
      if (eSpend != undefined) {
        sum += parseFloat(eSpend.value);
      }
    }
    var eNeed = document.getElementById("resource_spend_" + r + "_needed");
    if (eNeed != undefined) {
      eNeed.innerHTML = sum.toString();
    }
  }

  res_splits = gres_map.split(',');
  for (var i=0; i<res_splits.length; i++) {
    res = res_splits[i].split(':');
    if (res[0] == "50" || res[0] == "51") {
      continue;
    }
    var eGain = document.getElementById("resource_gain_" + idx + "_" + res[0]);
    if (eGain != undefined) {
      eGain.innerHTML = parseInt(res[1]) * parseInt(e.value);
    }
  }

  spend_update(undefined, undefined);
}
function checkExtraSpend(e, val) {
  alert(val);
}