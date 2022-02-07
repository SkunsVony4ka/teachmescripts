program KillVendors;
const
MyMaxWeight = 500; // Max Weight
// Обозначение позиции руны в рунбуке: 21 - 1, 33 - 2, 46 - 3, 58 - 4, 64 - 5, 73 - 6, 88 - 7, 94 - 8, 1025 - 9.
  runetokill = 21;         // Руна фарм.
  runetosell = 33;         // Руна на продажу.
  runetobank = 46;         // Руна на к банку.
// Типы:
maletype =     $0190; // Вендор Мужчина.
femaletype =   $0191; // Вендор Женщина.
corpsetype =   $2006;
runebooktype = $0EFA;
runebookcolor = $0510;
goldcointype = $0EED;

   loot= $1539; // Штаны длинные
   loot1= $1517;// Майка
   loot2= $1531; // Юбка длинная
   loot3= $153B; // Короткий фартук
   loot4= $152E; // Короткие штаны
   loot5= $1537; // Круглая юбка
   loot6= $1515; // Клока
   loot7= $1F03; // Роба
   loot8= $09C7; // Бутылка вина
   loot9= $1F7B; // дуплет

 var
i:integer;
n:integer;
corpseID:Cardinal;
mobloottype: array [1..9] of word;  

procedure Resurrector;
BEGIN
  if dead then
  begin
    HelpRequest;//Нажать "Help"
    Wait(1000);                                  
    Waitgump('3');//Нажать "Help i am stuck"
    Wait(1000);
    Waitgump(IntToStr(2));//Нажать на кнопку города
    Wait(3000)
    FindDistance:=10;
	
	while (not moveXYZ(2466, 532, 0, 0, 255, true)) do
		Wait(1000);
    while (GetType(Self()) = $0192) or (GetType(Self()) = $0193) do 
	begin
      useObject($4001BDF0);
      Wait(1000);
    end;
	
     recal_rb_new(runetokill);
    AttackMob;
  end;
end;
procedure death; forward;
procedure init;
  begin
	// Типы предметов при луте из моба
	mobloottype[1] := goldcointype;
	mobloottype[2] := loot
 	mobloottype[3] := loot1
	mobloottype[4] := loot2
	mobloottype[5] := loot3
	mobloottype[6] := loot4
	mobloottype[7] := loot5
	mobloottype[8] := loot6
	mobloottype[9] := loot7
  mobloottype[9] := loot8
  mobloottype[9] := loot9


	// Дополнительно
    if not connected then connect;          // Подключение
    setpausescriptondisconnectstatus(true); // Включить паузу при дисконнекте.
    setarstatus(true);                      // Включить реконнект.
    while not connected do wait(500);       // Ждем подключения.

    addtosystemjournal('Персонаж в игре. Макрос запущен.');
    finddistance := 5;    // Дальность поиска пк и монстров.
    moveopendoor := true;  // Открываем двери при ходьбе.
    movethroughnpc := dex; // При каком значении стамины пытаться пройти через персонажей.
	
	SetRunUnmountTimer(205); 
	SetWalkUnmountTimer(405); 
	SetRunMountTimer(205); 
	SetWalkMountTimer(405);  
  end;

procedure FullDisconnect;
begin
SetARStatus(false);
Disconnect;
Exit;
end;

procedure checksave;
//////////////////////////////////////////// Проверка сохранения мира.
  begin
    if injournalbetweentimes('World is saving now...', now-(1.0/(24*60*2)), now) > -1 then
      repeat wait(500); until injournalbetweentimes('World data saved in ', now-(1.0/(24*60*2)), now) > 1;
    checklag(5000);
  end;

procedure checkdistance;

  begin
    if getdistance(monster) > 1 then
      newmovexy(getx(monster), gety(monster), false, 1, false);
  end;

  procedure checkweight;

  begin
    if getquantity(findtype(batwingstype, backpack)) >= maxbatwings then begin
	  while not newmovexy(coord[high(coord)].x, coord[high(coord)].y, false, 1, isRunningWhileWalking) do wait(300);
	  if dead then exit;
	  recall(runetohome, false);
	  if dead then exit;
	  unload;
	  coming;
	end;

  procedure IngoreExistingCorpses;
begin
	while (findtype(corpsetype, ground) > 0) AND (NOT dead) do begin
		addtosystemjournal('Игнорим хладный труп');
		ignore(finditem);
		Wait(200);
	end;
end;	

function recall(value: integer; useinvis: boolean): boolean;
//////////////////////////////////////////// Реколл по рунбуке.
  var
    t: tdatetime;
    x, y: integer;
    charges: string;
    stringlist: tstringlist;

  begin
    result := true;
    x := getx(self);
    y := gety(self);
    stringlist := tstringlist.create;

    checklag(50000);
    useobject(backpack);
    wait(500);

    repeat
      while isgump do closesimplegump(getgumpscount-1);

      if useinvis then if (findtypeex(invistype, inviscolor, backpack, false) > 0) then begin
        checklag(50000);
        if WarMode = true then SetWarMode(false);
        useobject(finditem);
	addtosystemjournal('Пьем инвиз');
        wait(200);
	//NewMoveXY(getx + 2, gety + 2, false, 1, false);
      end;

          checklag(50000);
          if WarMode = true then SetWarMode(false);
          if dead then death; 
          if (useinvis = false) then useskill('Hiding');
          wait(200);
          usetype(runebooktype, runebookcolor);
          wait(600);

        //until isgump;

	    t := now;
        getgumptextlines(getgumpscount-1, stringlist);
        charges := copy(stringlist[12], 10, length(stringlist[12]));
        if strtoint(charges) < 30 then addtosystemjournal('Мужик! У меня в рунбуке мало зарядов: ' + charges);
        if strtoint(charges) < 2 then FullDisconnect;
      numgumpbutton(getgumpscount-1, value);
	  //until numgumpbutton(getgumpscount-1, value);

      repeat
        checklag(50000);
        wait(600);
      until ((x <> getx(self)) AND (y <> gety(self))) OR (injournalbetweentimes('The spell fizzles.', t, now) > -1) OR (t+(1.0/(24*60*6)) < now);

    until ((x <> getx(self)) OR (y <> gety(self)));
    stringlist.free;
  end;

procedure Unload;
begin
checksave;
FindType($2006,Ground);
if FindType($2006,Ground)>0 then
begin
newMoveXY(GetX(FindItem),GetY(FindItem),true,1,true);
CorpseID:=FindItem;
if dead then death;
checksave;
UseObject(CorpseID);
wait(600);
for i := 1 to high(mobloottype) do
if findtype(mobloottype[i], corpseID) > 0 then begin
moveitem(finditem, 0, backpack, 0, 0, 0);
wait(600);
end;
ignore(CorpseID);
if Weight > MWeight then
begin
sbros;
end;
end;
end;
procedure kill;
begin 
      FindDistance:=5;
      FindVertical:=15;
      checksave;
      if gethp(self)<100 then
      begin
      end;
      FindType($0190,ground);
      n:=findcount;
      //AddToSystemJournal('Найдено '+IntToStr(n)+' '+GetName(FindItem));
      wait (600);
      FindType($0190,ground);           
      if n>0 then
      begin
      FindType($0190,ground);
        attack(FindItem);
        while gethp(finditem)>0 do 
        begin
        if dead then death;
        FindType($0190,ground);
        attack(FindItem);
        if GetDistance(FindItem)>0 then
          newMoveXY(GetX(FindItem),GetY(FindItem),true,1,true);
          wait(100);
          if dead then death;  
        end;
        if FindType($2006,ground)>0 then
          begin
          FindType($2006,ground);
          newMoveXY(GetX(FindItem),GetY(FindItem),true,1,true);
          wait(300); 
Unload;
Check_Hidden;
               FindType($2006,ground)
              ignore(FindItem)
          end;
   wait(100);
   end;
wait(100);
end;
Begin
  init;

  while NOT (weight > 1000) do begin 
  ignore(self);
  ignore($001F7021);   // Свои Чары

  Check_Hidden;

  while gethp(self)>1 do
  begin
  kill;
  wait(100);
  end;

  if dead then death;
  wait(100);
  end; 
  wait(100);
end. 




procedure ApproachMob();
begin
  AddToSystemJournal('Approaching mob');
  finddistance := 6;    // Дальность поиска вендоров.
    moveopendoor := true;  // Открываем двери при ходьбе.
    movethroughnpc := dex; // При каком значении стамины пытаться пройти через персонажей.
end;

procedure WearWeapon();
begin
  AddToSystemJournal('Wearing weapon');
end;

procedure AttackMob();
begin
  AddToSystemJournal('Attacking mob');
end;


procedure AttackSomeMob();
begin
  ApproachMob();
  WearWeapon();
  AttackMob();  
end;


begin
    AttackSomeMob(); 
end.