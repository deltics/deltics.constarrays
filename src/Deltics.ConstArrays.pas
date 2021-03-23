
{$i deltics.constarrays.inc}

  unit Deltics.ConstArrays;


interface

  uses
    Deltics.StringTypes;


  type
    ConstArray = class
    public
      class function AsStringArray(aArgs: array of const): StringArray;
    end;
    TConstArray = array of TVarRec;


  {$ifdef TypeHelpers}
    TConstArrayHelper = record helper for TConstArray
    private
      function get_AsStringArray: StringArray; {$ifdef InlineMethods} inline; {$endif}
    public
      property AsStringArray: StringArray read get_AsStringArray;
    end;


    TVarRecHelper = record helper for TVarRec
    private
      function get_AsString: String;  {$ifdef InlineMethods} inline; {$endif}
    public
      property AsString: String read get_AsString;
    end;
  {$endif}


  function VarRecAsString(aValue: TVarRec): String; overload;
  function VarRecAsString(aArgs: array of const; const aIndex: Integer): String; overload;




implementation

  uses
    SysUtils,
    Deltics.Exceptions,
    Deltics.Strings;




  class function ConstArray.AsStringArray(aArgs: array of const): StringArray;
  var
    i: Integer;
  begin
    SetLength(result, Length(aArgs));

    for i := 0 to High(aArgs) do
      result[i] := VarRecAsString(aArgs[i]);
  end;


{$ifdef TypeHelpers}
  function TConstArrayHelper.get_AsStringArray: StringArray;
  begin
    result := ConstArray.AsStringArray(self);
  end;


  function TVarRecHelper.get_AsString: String;
  begin
    result := VarRecAsString(self);
  end;
{$endif}



  function VarRecAsString(aValue: TVarRec): String;

    {$ifdef __DELPHIXE}
      {$ifdef CPU32BITS}
        function IntPtr(aPointer: Pointer): Integer;
        begin
          result := Integer(aPointer);
        end;
      {$else}
        function IntPtr(aPointer: Pointer): Int64;
        begin
          result := Int64(aPointer);
        end;
      {$endif}
    {$endif}

    procedure HandleVariant;
    {$ifdef DELPHIXE2__}
      var
        s: String;
      begin
        if Assigned(System.VarToUStrProc) then
        begin
          System.VarToUStrProc(s, TVarData(aValue.VVariant^));
          result := s;
        end;
      end;
    {$else}
      begin
        raise ENotSupported.Create('Unable to render vtVariant const array value as string');
      end;
    {$endif}

  var
    strLen: Integer;
    strPtr: PAnsiChar;
  begin
    case aValue.VType of
      vtBoolean:
        if aValue.VBoolean then
          result := 'true'
        else
          result := 'false';

      vtObject,
      vtClass,
      vtInterface:
        raise ENotSupported.Create('Unable to render const array value as string');

      vtInteger:
        result := IntToStr(aValue.VInteger);

      vtChar:
        result := STR.FromAnsi(AnsiChar(aValue.VChar));

      vtWideChar:
        result := Str.FromWide(WideChar(aValue.VWideChar));

      vtExtended:
        result := FloatToStr(aValue.VExtended^);

      vtCurrency:
        result := CurrToStr(aValue.VCurrency^);

      vtPointer:
        result := IntToHex(IntPtr(aValue.VPointer), SizeOf(Pointer) * 2);

      vtPChar:
        result := Str.FromBuffer(PAnsiChar(aValue.VPChar));

      vtPWideChar:
        result := Str.FromBuffer(aValue.VPWideChar);

    {$ifNdef NEXTGEN}
      vtString: begin
                  strPtr  := PAnsiChar(aValue.VString);
                  strLen  := PByte(strPtr)^;

                  Inc(strPtr);
                  result  := Str.FromBuffer(strPtr, strLen);
                end;

      vtAnsiString:
        result := Str.FromBuffer(PAnsiChar(aValue.VAnsiString));

      vtWideString:
        result := Str.FromBuffer(PWideChar(aValue.VWideString));
    {$endif}

    {$ifdef UNICODE}
      vtUnicodeString:
        result := Str.FromBuffer(PWideChar(aValue.VUnicodeString));
    {$endif}

    {$ifdef DELPHI XE2__}
      vtVariant:
        HandleVariant;
    {$endif}

      vtInt64:
        result := IntToStr(aValue.VInt64^);
    end;
  end;


  function VarRecAsString(aArgs: array of const; const aIndex: Integer): String;
  begin
    result := VarRecAsString(aArgs[aIndex]);
  end;


end.
