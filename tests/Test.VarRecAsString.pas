
{$i deltics.inc}

  unit Test.VarRecAsString;

interface

  uses
    Deltics.Smoketest;


  type
    VarRecAsStringTests = class(TTest)
      procedure BooleanValues;
      procedure CurrencyValues;
      procedure DoubleValues;
      procedure ExtendedValues;
    end;


implementation

  uses
    Deltics.ConstArrays;


{ VarRecAsStringTests }

  procedure VarRecAsStringTests.BooleanValues;
  begin
    Test('VarRecAsString([TRUE], 0)').Assert(VarRecAsString([TRUE], 0)).Equals('true');
    Test('VarRecAsString([FALSE], 0)').Assert(VarRecAsString([FALSE], 0)).Equals('false');
  end;


  procedure VarRecAsStringTests.CurrencyValues;
  var
    c: Currency;
    expected: String;
  begin
    c := 0;
    Test('VarRecAsString([Currency(0)], 0)').Assert(VarRecAsString([c], 0)).Equals('0');

    c := 1;
    Test('VarRecAsString([Currency(1)], 0)').Assert(VarRecAsString([c], 0)).Equals('1');

    c := 1.5;
    Test('VarRecAsString([Currency(1.5)], 0)').Assert(VarRecAsString([c], 0)).Equals('1.5');

    // Exceeds precision of Currency - will be rounded to 3.1416 (in the variable itself, not by VarRecAsString)
    c         := 3.14159;
    expected  := '3.1416';
  {$ifdef 64BIT}
    {$ifdef DELPHIXE2__}
      {$ifdef __DELPHIXE4}
        expected  := '3.1415';  // 64-bit bug in Delphi XE2 and XE3?
      {$endif}
    {$endif}
  {$endif}
    Test('VarRecAsString([Currency(3.14159)], 0)').Assert(VarRecAsString([c], 0)).Equals(expected);

    c := 0.1;
    Test('VarRecAsString([Currency(0.1)], 0)').Assert(VarRecAsString([c], 0)).Equals('0.1');
  end;


  procedure VarRecAsStringTests.DoubleValues;
  var
    d: Double;
  begin
    d := 0;
    Test('VarRecAsString([Double(0)], 0)').Assert(VarRecAsString([d], 0)).Equals('0');

    d := 1;
    Test('VarRecAsString([Double(1)], 0)').Assert(VarRecAsString([d], 0)).Equals('1');

    d := 1.5;
    Test('VarRecAsString([Double(1.5)], 0)').Assert(VarRecAsString([d], 0)).Equals('1.5');

    d := 3.14159;
    Test('VarRecAsString([Double(3.14159)], 0)').Assert(VarRecAsString([d], 0)).Equals('3.14159');

    d := 0.1;
    Test('VarRecAsString([Double(0.1)], 0)').Assert(VarRecAsString([d], 0)).Equals('0.1');
  end;


  procedure VarRecAsStringTests.ExtendedValues;
  var
    e: Extended;
  begin
    e := 0;
    Test('VarRecAsString([Extended(0)], 0)').Assert(VarRecAsString([e], 0)).Equals('0');

    e := 1;
    Test('VarRecAsString([Extended(1)], 0)').Assert(VarRecAsString([e], 0)).Equals('1');

    e := 1.5;
    Test('VarRecAsString([Extended(1.5)], 0)').Assert(VarRecAsString([e], 0)).Equals('1.5');

    e := 3.14159;
    Test('VarRecAsString([Extended(3.14159)], 0)').Assert(VarRecAsString([e], 0)).Equals('3.14159');

    e := 0.1;
    Test('VarRecAsString([Extended(0.1)], 0)').Assert(VarRecAsString([e], 0)).Equals('0.1');
  end;

end.
