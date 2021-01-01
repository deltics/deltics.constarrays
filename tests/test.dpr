
{$apptype CONSOLE}

  program test;

uses
  Deltics.Smoketest,
  Deltics.ConstArrays in '..\src\Deltics.ConstArrays.pas',
  Test.ConstArrays in 'Test.ConstArrays.pas',
  Test.VarRecAsString in 'Test.VarRecAsString.pas';

begin
  TestRun.Test(VarRecAsStringTests);
  TestRun.Test(ConstArrayTests);
end.
