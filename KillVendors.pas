program KillVendors;
const
MyMaxWeight = 500; // Max Weight
// Обозначение позиции руны в рунбуке: 21 - 1, 33 - 2, 46 - 3, 58 - 4, 64 - 5, 73 - 6, 88 - 7, 94 - 8, 1025 - 9.
  runetokill = 21;         // Руна домой.
  runetosell = 33;         // Руна на фарм.
  runetobank = 46;         // Руна на фарм.
  
procedure ApproachMob();
begin
  AddToSystemJournal('Approaching mob');
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