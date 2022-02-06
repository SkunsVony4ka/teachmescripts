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

   loot= $1539; // Штаны длинные
   loot1= $1517;// Майка
   loot2= $1531; // Юбка длинная
   loot3= $153B; // Короткий фартук

 var
 corpse: cardinal;  

procedure Resurrector;
BEGIN
  if dead then
  begin
    HelpRequest;//Нажать "Help"
    wait(1000);                                  
    waitgump('3');//Нажать "Help i am stuck"
    wait(1000);
    waitgump(IntToStr(2));//Нажать на кнопку города
    wait(3000)
    FindDistance:=10;
	
	while (not moveXYZ(2466, 532, 0, 0, 255, true)) do
		Wait(1000);
		
    wait(1000)
	
    while (GetType(Self()) = $0192) or (GetType(Self()) = $0193) do 
	begin
      useObject($4001BDF0);
      wait(1000);
    end;
	
     recal_rb_new(runetokill);
    AttackMob;
  end;
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
		wait(200);
	end;
end;	

  procedure checksave;
                          ////////////////////////////////////////////
//////////////////////////////////////////// Проверка сохранения мира.
  begin
    if injournalbetweentimes('World is saving now...', now-(1.0/(24*60*2)), now) > -1 then
      repeat wait(500); until injournalbetweentimes('World data saved in ', now-(1.0/(24*60*2)), now) > 1;
    checklag(5000);
  end;

  function recall(value: integer; useinvis: boolean): boolean;
                          ////////////////////////////////////////////
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

    useobject(backpack);
    checksave;
    wait(400);

    repeat
      while isgump do closesimplegump(getgumpscount-1);
	  setwarmode(false);

      if dead then begin
        addtosystemjournal('Я умер во время телепорта.');
        stringlist.free;
        result := false;
        exit;
      end;

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