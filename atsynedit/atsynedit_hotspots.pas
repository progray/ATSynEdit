{
Copyright (C) Alexey Torgashin, uvviewsoft.com
License: MPL 2.0 or LGPL
}
unit ATSynEdit_Hotspots;

{$mode objfpc}{$H+}
{$ModeSwitch advancedrecords}
{$Z1}

//{$define test_hotspots}

interface

uses
  Classes, SysUtils,
  ATSynEdit_fgl,
  ATSynEdit_Carets;

type
  TATHotspotItem = record
    PosX, PosY: integer;
    EndX, EndY: integer;
    Tag: string;
    class operator=(const A, B: TATHotspotItem): boolean;
  end;

type
  TATHotspotItems = specialize TFPGList<TATHotspotItem>;

type
  { TATHotspots }

  TATHotspots = class
  private
    FList: TATHotspotItems;
    function GetItem(AIndex: integer): TATHotspotItem;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    function Count: integer;
    function IsIndexValid(N: integer): boolean; inline;
    property Items[N: integer]: TATHotspotItem read GetItem; default;
    procedure Add(const AItem: TATHotspotItem);
    procedure Delete(N: integer);
    procedure Insert(N: integer; const AItem: TATHotspotItem);
    function FindByPos(AX, AY: integer): integer;
    function FindByTag(const ATag: string): integer;
  end;


implementation

{ TATHotspotItem }

class operator TATHotspotItem.=(const A, B: TATHotspotItem): boolean;
begin
  Result:= false;
end;

{ TATHotspots }

constructor TATHotspots.Create;
var
  R: TATHotspotItem;
begin
  FList:= TATHotspotItems.Create;

  {$ifdef test_hotspots}
  //debug
  R.PosX:= 0;
  R.PosY:= 0;
  R.EndX:= 4;
  R.EndY:= 4;
  R.Tag:= 'spot0';
  Add(R);

  R.PosX:= 10;
  R.PosY:= 20;
  R.EndX:= 20;
  R.EndY:= 20;
  R.Tag:= 'spot1';
  Add(R);
  {$endif}
end;

destructor TATHotspots.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited;
end;

procedure TATHotspots.Clear;
begin
  FList.Clear;
end;

function TATHotspots.GetItem(AIndex: integer): TATHotspotItem;
begin
  Result:= FList[AIndex];
end;

function TATHotspots.Count: integer;
begin
  Result:= FList.Count;
end;

function TATHotspots.IsIndexValid(N: integer): boolean; inline;
begin
  Result:= (N>=0) and (N<Count);
end;

procedure TATHotspots.Add(const AItem: TATHotspotItem);
begin
  FList.Add(AItem);
end;

procedure TATHotspots.Delete(N: integer);
begin
  FList.Delete(N);
end;

procedure TATHotspots.Insert(N: integer; const AItem: TATHotspotItem);
begin
  if N>=FList.Count then
    FList.Add(AItem)
  else
    FList.Insert(N, AItem);
end;

function TATHotspots.FindByPos(AX, AY: integer): integer;
var
  Item: TATHotspotItem;
  i: integer;
begin
  Result:= -1;
  for i:= 0 to Count-1 do
  begin
    Item:= Items[i];
    if IsPosInRange(AX, AY, Item.PosX, Item.PosY, Item.EndX, Item.EndY, false) = cRelateInside then
      exit(i);
  end;
end;

function TATHotspots.FindByTag(const ATag: string): integer;
var
  i: integer;
begin
  Result:= -1;
  for i:= 0 to Count-1 do
    if ATag=Items[i].Tag then
      exit(i);
end;

end.

