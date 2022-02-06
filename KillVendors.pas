Program KillVendors;

const
  MyMaxWeight = 500; // Max Weight
  // Обозначение позиции руны в рунбуке: 21 - 1, 33 - 2, 46 - 3, 58 - 4, 64 - 5, 73 - 6, 88 - 7, 94 - 8, 1025 - 9.
  RuneToKill = 21;         // Руна фарм.
  RuneToSell = 33;         // Руна на продажу.
  RuneToBank = 46;         // Руна на к банку.
  // Типы:
  MaleType      = $0190; // Вендор Мужчина.
  FemaleType    = $0191; // Вендор Женщина.
  CorpseType    = $2006;
  RunebookType  = $0EFA;
  RunebookColor = $0510;
  Loot          = $1539; // Штаны длинные
  Loot1         = $1517;// Майка
  Loot2         = $1531; // Юбка длинная
  Loot3         = $153B; // Короткий фартук

var
 Corpse: Cardinal;  

Procedure Resurrector;
var MoveSuccess: boolean;
begin
  if Dead then
    begin
      HelpRequest;//Нажать "Help"
      Wait(1000);                                  
      Waitgump('3');//Нажать "Help i am stuck"
      Wait(1000);
      Waitgump('2');//Нажать на кнопку города
      Wait(3000)
      FindDistance := 10;	

      // Looks not so stable
	    // while (not moveXYZ(2466, 532, 0, 0, 255, true)) do
	    	// Wait(1000);	
      // Refactoring to have 5 tries, if failed -> send message to system journal

      MoveSuccess := False;
      for i := 0 to 5 do
        begin
          if (MoveXYZ(2466, 532, 0, 0, 255, true)) then
            begin
              MoveSuccess := True;
            end;
          Wait(1000);
        end;

      // Halting script if failed to get to location
      if not MoveSuccess then
        begin
          AddToSystemJournal('Failed to move while ressurecting!');
          Halt;
        end;

      while (GetType(Self()) = $0192) or (GetType(Self()) = $0193) do 
	      begin
          UseObject($4001BDF0);
          Wait(1000);
        end;
      Recal_rb_new(RuneToKill);
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