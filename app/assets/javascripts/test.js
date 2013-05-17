  
function verifAction(){
  var afficheBoutonGo=true;
  var action=document.getElementById("action").value.split(RegExp("[;]+","g"));
  var listeActions=document.getElementById("listeActionsPolitiques").value.split(RegExp("[;]+","g"));
  var j;
  var numAction=parseInt(action[0]);
  if(numAction==0)
  {
    afficheBoutonGo=false;
  }
  document.getElementById('listeUnites').style.display='none';
  document.getElementById('idCarteAction').value=0;
  document.getElementById('sacrificeUnites').style.display='none';
  document.getElementById('TRA').style.display='none';
  document.getElementById('IA').style.display='none';
  document.getElementById('nbCA_IA').style.display='none';
  document.getElementById('endTurn').style.display='none';
  document.getElementById('quitGame').style.display='none';
  if(document.getElementById('optionMasarik'))
  {
    document.getElementById('optionMasarik').style.display='none';
  }
  if(document.getElementById('optionCzech'))
  {
    document.getElementById('optionCzech').style.display='none';
  }
  if(document.getElementById('optionComenius'))
  {
    document.getElementById('optionComenius').style.display='none';
  }
  i=0;
  while(listeActions[i])
  {
    document.getElementById('listeAdversaires'+listeActions[i]).style.display='none';
    i++;
  }
  if(document.getElementById('idTRA'))
  {
    var idTRA=parseInt(document.getElementById('idTRA').value);
    if(idTRA>0)
    {
      var coutF=-99;
      var coutR=-99;
      var nbF=parseInt(document.getElementById('nbNourriture').value);
      var nbR=parseInt(document.getElementById('nbRessources').value);
      var nbRM=parseInt(document.getElementById('nbRessourcesM').value);
      var TRAstatus=0;
      if(numAction==1||numAction==13)
      {
        coutF=parseInt(action[1]);
      }
      else if(numAction==12&&action[4]=='Frugality')
      {
        coutF=parseInt(action[5]);
      }
      if(numAction==2)
      {
        coutR=parseInt(action[2]);
        if(parseInt(action[4])==12)
        {
          nbR+=nbRM;
        }
      }
      else if(numAction==3||numAction==4||numAction==13)
      {
        coutR=parseInt(action[3]);
      }
      else if(numAction==12&&(action[4]=='Engineering Genius'))
      {
        coutR=parseInt(action[6])-parseInt(action[7]);
      }
      if((coutF>0&&idTRA==2)||(coutR>0&&idTRA==1))
      {
        switch(idTRA)
        {
          case 1:
          if(nbR>coutR&&nbF>coutF)
          {
            TRAstatus=1;
          }
          else if(nbR<=coutR&&nbF>coutF)
          {
            TRAstatus=2;
          }
          else if(nbR>=coutR&&nbF<=coutF)
          {
            TRAstatus=3;
          }
          break;
          case 2:
          if(nbF>coutF&&nbR>coutR)
          {
            TRAstatus=1;
          }
          else if(nbF<=coutF&&nbR>coutR)
          {
            TRAstatus=2;
          }
          else if(nbF>=coutF&&nbR<=coutR)
          {
            TRAstatus=3;
          }
          break;
        }
      }
      else if((coutF>-99&&idTRA==2)||(coutR>-99&&idTRA==1))
      {
        TRAstatus=3;
      }
    }
    switch(TRAstatus)
    {
      case 0:
      document.getElementById('TRA').style.display='none';
      break;
      case 1:
      document.getElementById('traCB').checked='';
      document.getElementById('traCB').disabled='';
      document.getElementById('valTRA').value=0;
      document.getElementById('TRA').style.display='';
      break;
      case 2:
      document.getElementById('traCB').checked='checked';
      document.getElementById('traCB').disabled='disabled';
      document.getElementById('valTRA').value=idTRA;
      document.getElementById('TRA').style.display='';
      break;
      case 3:
      document.getElementById('traCB').checked='';
      document.getElementById('traCB').disabled='disabled';
      document.getElementById('valTRA').value=0;
      document.getElementById('TRA').style.display='';
      break;
    }
  }
  if(numAction==8)
  {
    document.getElementById('listeUnites').style.display='';
  }
  if(numAction==9)
  {
    document.getElementById('endTurn').style.display='';
    if(document.getElementById('optionComenius'))
    {
      document.getElementById('optionComenius').style.display='';
      afficheBoutonGo=false;
    }
  }
  if(numAction==99)
  {
    document.getElementById('quitGame').style.display='';
  }
  var nbOptMasarik=0;
  if(document.getElementById('optionMasarik')&&parseInt(document.getElementById('nbActionsMilitairesRestantes').value)>0)
  {
    switch(numAction)
    {
      case 1:
      nbOptMasarik=1;
      break;
      case 2:
      if(action[4]<12)
      {
        nbOptMasarik=1;
      }
      break;
      case 3:
      if(action[5]<12)
      {
        nbOptMasarik=1;
      }
      break;
      case 4:
      nbOptMasarik=1;
      break;
      case 8:
      nbOptMasarik=1;
      break;
      case 12:
      nbOptMasarik=1;
      break;
    }
    if(nbOptMasarik>0)
    {
      document.getElementById('optionMasarik').style.display='';
      if(document.getElementById('useMasarik2'))
      {
        document.getElementById('useMasarik2').checked='';
      }
      if(nbOptMasarik<=1)
      {
        if(document.getElementById('useMasarik2'))
        {
          document.getElementById('useMasarik2').style.display='none';
        }
      }
      else
      {
        if(document.getElementById('useMasarik2'))
        {
          document.getElementById('useMasarik2').style.display='';
        }
        if(parseInt(document.getElementById('nbActionsMilitairesRestantes').value)<=1)
        {
          if(document.getElementById('useMasarik2'))
          {
            document.getElementById('useMasarik2').checked='';
            document.getElementById('useMasarik2').disabled='disabled';
          }
        }
      }
      if(parseInt(document.getElementById('nbActionsCivilesRestantes').value)==0)
      {
        document.getElementById('useMasarik1').checked='checked';
        document.getElementById('useMasarik1').disabled='disabled';
        document.getElementById('valMasarik').value=1;
      }
      else
      {
        document.getElementById('useMasarik1').checked='';
        document.getElementById('useMasarik1').disabled='';
        document.getElementById('valMasarik').value=0;
      }
    }
  }
  var affOpt=false;
  if(document.getElementById('optionCzech'))
  {
    switch(numAction)
    {
      case 2:
      if(parseInt(action[4])==10)
      {
        affOpt=true;
      }
      break;
      case 3:
      if(parseInt(action[5])==10)
      {
        affOpt=true;
      }
      break;
      case 4:
      affOpt=true;
      break;
      case 12:
      if(action[4]=='Engineering Genius')
      {
        affOpt=true;
      }
      break;
    }
    if(affOpt)
    {
      document.getElementById('optionCzech').style.display='';
      if(numAction==2)
      {
        var coutAction=parseInt(action[2]);
      }
      else if(numAction==12)
      {
        coutAction=parseInt(action[6])-parseInt(action[7]);
      }
      else
      {
        var coutAction=1*action[3];
      }
      if(parseInt(document.getElementById('nbRessources').value)<coutAction)
      {
        document.getElementById('useCzech').checked='checked';
        document.getElementById('useCzech').disabled='disabled';
        document.getElementById('valCzech').value=1;
      }
      else if(coutAction==0)
      {
        document.getElementById('useCzech').checked='';
        document.getElementById('useCzech').disabled='disabled';
        document.getElementById('valCzech').value=0;
      }
      else
      {
        document.getElementById('useCzech').checked='';
        document.getElementById('useCzech').disabled='';
        document.getElementById('valCzech').value=0;
      }
    }
  }
  if(numAction==12)
  {
    document.getElementById('idCarteAction').value=action[1];
  }
  if(numAction==15||numAction==221||numAction==231)
  {
    document.getElementById('sacrificeUnites').style.display='';
  }
  if(numAction==22||numAction==23||numAction==24)
  {
    document.getElementById('listeAdversaires'+action[1]).style.display='';
    afficheBoutonGo=false;
    for(j=1;j<=6;j++)
    {
      if(document.getElementById('adversaire'+action[1]+'-'+j))
      {
        if(document.getElementById('adversaire'+action[1]+'-'+j).checked)
        {
          afficheBoutonGo=true;
        }
      }
    }
  }
  if(numAction==22||numAction==15)
  {
    document.getElementById('sacrificeUnites').style.display='';
  }
  if(numAction==2481)
  {
    document.getElementById('IA').style.display='';
    document.getElementById('nbCA_IA').style.display='';
  }
  if(afficheBoutonGo)
  {
    document.getElementById("boutonGO").style.display='';
  }
  else{document.getElementById("boutonGO").style.display='none';
}
}
function verifOpt()
{
  document.getElementById("boutonSubmit").style.display='';
  typeAction=document.getElementById("typeAction").value;
  nbActions=document.getElementById("nbActions").value;
  for(i=0;i<nbActions;i++)
  {
    if(document.getElementsByName("action")[i])
    {
      if(document.getElementsByName("action")[i].checked)
      {
        var action=document.getElementsByName("action")[i].value.split(RegExp("[;]+","g"));
        var numAction=1*action[0];
        if(numAction==2)
        {
          var coutAction=1*action[2];
        }
        else
        {
          var coutAction=1*action[3];
        }
      }
    }
  }
  if(document.getElementById('idTRA'))
  {
    if(document.getElementById('idTRA').value==1&&coutAction>0)
    {
      document.getElementById('TRA').style.display='';
      document.getElementById('valTRA').value=document.getElementById('idTRA').value;
      if(coutAction==document.getElementById('nbRessources').value)
      {
        document.getElementById('traCB').checked='checked';
        document.getElementById('traCB').disabled='disabled';
        document.getElementById('valTRA').value=document.getElementById('idTRA').value;
      }
      else
      {
        document.getElementById('traCB').checked='';
        document.getElementById('traCB').disabled='';
        document.getElementById('valTRA').value=0;
      }
    }
    else
    {
      document.getElementById('TRA').style.display='none';
      document.getElementById('traCB').checked='';
      document.getElementById('traCB').disabled='';
      document.getElementById('valTRA').value=0;
    }
  }
  var affOpt=false;
  if(document.getElementById('optionMasarik')&&numAction==6)
  {
    affOpt=true;
  }
  if(document.getElementById('useMasarik2'))
  {
    if(affOpt)
    {
      document.getElementById('useMasarik2').style.display='';
    }
    else
    {
      document.getElementById('useMasarik2').style.display='none';
    }
  }
  affOpt=false;
  if(document.getElementById('optionCzech'))
  {
    switch(numAction)
    {
      case 2:
      if(parseInt(action[4])==10)
      {
        affOpt=true;
      }
      break;
      case 3:
      if(parseInt(action[5])==10)
      {
        affOpt=true;
      }
      break;
      case 4:
      affOpt=true;
      break;
      case 12:
      if(action[4]=='Engineering Genius')
      {
        affOpt=true;
      }
      break;
    }
    if(affOpt)
    {
      document.getElementById('optionCzech').style.display='';
      if(numAction==2)
      {
        var coutAction=parseInt(action[2]);
      }
      else if(numAction==12)
      {
        coutAction=parseInt(action[6])-parseInt(action[7]);
      }
      else
      {
        var coutAction=1*action[3];
      }
      if(parseInt(document.getElementById('nbRessources').value)<coutAction)
      {
        document.getElementById('useCzech').checked='checked';
        document.getElementById('useCzech').disabled='disabled';
        document.getElementById('valCzech').value=1;
      }
      else
      {
        document.getElementById('useCzech').checked='';
        document.getElementById('useCzech').disabled='';
        document.getElementById('valCzech').value=0;
      }
    }
  }
}
function updateIA()
{
  var numCarte;
  var nbCA=0;
  var idMerveille=0;
  var idLeader=0;
  var ageLeader=0;
  var nomCartesTechno='';
  var idCartesTechno='';
  var nbCartes=0;
  var numCarteMax=0;
  for(numCarte=1;numCarte<=13;numCarte++)
  {
    if(document.getElementById('IA'+numCarte))
    {
      numCarteMax=numCarte;
      var paramCarte=document.getElementById('IA'+numCarte).value.split(RegExp("[;]+","g"));
      if(document.getElementById('IA'+numCarte).checked)
      {
        nbCA+=parseInt(paramCarte[0]);
        if(paramCarte[2]==13)
        {
          idMerveille=paramCarte[1];
        }
        else
        {
          nbCartes++;
        }
        if(paramCarte[2]==14)
        {
          ageLeader=paramCarte[3];idLeader=paramCarte[1];
        }
        if(paramCarte[2]<13||paramCarte[2]==15||paramCarte[2]==16)
        {
          nomCartesTechno+=paramCarte[4]+'|';
          idCartesTechno+=paramCarte[1]+'|';
        }
      }
    }
  }
  for(numCarte=1;numCarte<=numCarteMax;numCarte++)
  {
    var paramCarte=document.getElementById('IA'+numCarte).value.split(RegExp("[;]+","g"));
    if((!document.getElementById('IA'+numCarte).checked&&(paramCarte[0]>5-nbCA||(document.getElementById('nbCartesIA').value<=nbCartes&&paramCarte[2]!=13)))||
      paramCarte[0]==0||
      (ageLeader>0&&paramCarte[3]==ageLeader&&paramCarte[1]!=idLeader&&paramCarte[2]==14)||
      (nomCartesTechno.search(paramCarte[4])==0&&idCartesTechno.search(paramCarte[1])!=0)||
      (document.getElementById('idMerveilleIA').value>0&&paramCarte[2]==13)||
      (idMerveille>0&&paramCarte[1]!=idMerveille&&paramCarte[2]==13))
    {
      document.getElementById('IA'+numCarte).disabled='disabled';
    }
    else
    {
      document.getElementById('IA'+numCarte).disabled='';
    }
  }
  document.getElementById('nbCA_IA').innerHTML=nbCA+'/5 CA';
  if(nbCA>0)
  {
    document.getElementById("action").value=2481;
  }
  else
  {
    document.getElementById("action").value=2482;
  }
}
function updateTRA()
{
  if(document.getElementById('traCB').checked)
  {
    document.getElementById('valTRA').value=document.getElementById('idTRA').value;
  }
  else
  {
    document.getElementById('valTRA').value=0;
  }
}
function updateOpt(n)
{
  var valOpt=0;
  if(document.getElementById('use'+n))
  {
    if(document.getElementById('use'+n).checked)
    {
      valOpt++;
    }
  }
  else
  {
    var i=1;
    while(document.getElementById('use'+n+i))
    {
      if(document.getElementById('use'+n+i).checked)
      {
        valOpt++;
      }
      i++;
    }
  }
  if(document.getElementById('val'+n))
  {
    document.getElementById('val'+n).value=valOpt;
  }
  else
  {
    i=1;
    while(document.getElementById('val'+n+i))
    {
      document.getElementById('val'+n+i).value=valOpt;
      i++;
    }
  }
}
function updateMilitaryStrength()
{
  var i=1;
  var infosTactique=document.getElementById('infosTactique').value.split(RegExp("[;]+","g"));
  var valeurTactique=parseInt(infosTactique[0]);
  var puissanceTactique=parseInt(infosTactique[1]);
  var ageTactique=parseInt(infosTactique[2]);
  var forceMilitaire=parseInt(document.getElementById('forceMilitaireBase').value);
  var forceTactique=1;
  var forceTactiqueObs=1;
  var nbTactiques=0;
  var nbTactiquesObs=0;
  var nbAirForces=0;
  while(document.getElementById('unite_sacrifiee_'+i))
  {
    if(document.getElementById('unite_sacrifiee_'+i).checked)
    {
      var unite=document.getElementById('unite_sacrifiee_'+i).value.split(RegExp("[;]+","g"));
      forceMilitaire+=parseInt(unite[2]);
      if(parseInt(unite[1])==7)
      {
        nbAirForces++;
      }
      else
      {
        forceTactiqueObs*=parseInt(unite[1]);
        if(parseInt(unite[2])>=ageTactique-1)
        {
          forceTactique*=parseInt(unite[1]);
        }
      }
    }
    i++;
  }
  while(forceTactique%valeurTactique==0&&forceTactique>0)
  {
    nbTactiques++;
    forceTactique/=valeurTactique;
  }
  while(forceTactiqueObs%valeurTactique==0&&forceTactiqueObs>0)
  {
    nbTactiquesObs++;
    forceTactiqueObs/=valeurTactique;
  }
  nbTactiquesObs-=nbTactiques;
  nbTactiquesObsBrut=nbTactiquesObs;
  nbTactiquesObs+=Math.min(Math.max(nbAirForces-nbTactiques,0),nbTactiquesObs);
  nbTactiques+=Math.min(nbAirForces-nbTactiquesObs+nbTactiquesObsBrut,nbTactiques);
  forceMilitaire+=nbTactiques*puissanceTactique+nbTactiquesObs*Math.ceil(puissanceTactique/2);
  if(!document.getElementById('bonusColonisation')||forceMilitaire>0)
  {
    i=1;
    while(document.getElementById('carte_defense_'+i))
    {
      if(document.getElementById('carte_defense_'+i).checked)
      {
        var carte=document.getElementById('carte_defense_'+i).value.split(RegExp("[;]+","g"));
        forceMilitaire+=parseInt(carte[2]);
      }
      i++;
    }
  }
  if(document.getElementById('bonusColonisation')&&forceMilitaire>0)
  {
    forceMilitaire+=1*document.getElementById('bonusColonisation').value;
  }
  document.getElementById('forceMilitaire').innerHTML=forceMilitaire;
}
ttaSfHover=function()
{
  if(document.getElementById("corps_page"))
  {
    var sfEls=document.getElementById("corps_page").getElementsByTagName("li");
    for(var i=0;i<sfEls.length;i++)
    {
      sfEls[i].onmouseover=function()
      {
        this.className+=" sfhover";
      }
      sfEls[i].onmouseout=function()
      {
        this.className=this.className.replace(new RegExp(" sfhover\\b"),"");
      }
    }
  }
}
if(window.attachEvent)
  window.attachEvent("onload",ttaSfHover);