{-----------------------------------------------------------------------------
 Unit Name: SVGInterfaces
 Author:    PyScripter
 Purpose:   Inteface-based access to Svg parsing and drawing
 History:
-----------------------------------------------------------------------------}

unit SVGInterfaces;

interface

Uses
  Winapi.Windows,
  System.Types,
  System.UITypes,
  System.SysUtils,
  System.Classes;

const
  SVG_INHERIT_COLOR = TColors.SysDefault;
  SVG_NONE_COLOR = TColors.SysNone;

type
  //  Abstraction of an SVG document
  ISVG = interface
    // property access methods
    function GetWidth: Single;
    function GetHeight: Single;
    function GetOpacity: Single;
    procedure SetOpacity(const Opacity: Single);
    function GetGrayScale: Boolean;
    procedure SetGrayScale(const IsGrayScale: Boolean);
    function GetFixedColor: TColor;
    procedure SetFixedColor(const Color: TColor);
    function GetSource: string;
    procedure SetSource(const ASource: string);
    // procedures and functions
    function IsEmpty: Boolean;
    procedure Clear;
    procedure SaveToStream(Stream: TStream);
    procedure SaveToFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(const FileName: string);
    procedure PaintTo(DC: HDC; R: TRectF; KeepAspectRatio: Boolean = True);
    // properties
    property Width: Single read GetWidth;
    property Height: Single read GetHeight;
    property Opacity: Single read GetOpacity write SetOpacity;
    property GrayScale: Boolean read GetGrayScale write SetGrayScale;
    property FixedColor: TColor read GetFixedColor write SetFixedColor;
    property Source: string read GetSource write SetSource;
  end;


  // Factory type
  ISVGHandler = interface
    ['{D81A7410-F0DB-457E-BA9D-480A335A1337}']
    // Factory method
    function NewSvg: ISVG;
  end;

Var
  GlobalSVGHandler: ISVGHandler;

implementation

{$INCLUDE SVGIconImageList.inc}

Uses
  {$IFDEF PreferNativeSvgSupport}
  D2DSVGHandler,
  {$ENDIF}
  PasSVGHandler;

initialization
  if not Assigned(GlobalSVGHandler) then
  begin
    {$IFDEF PreferNativeSvgSupport}
    if WinSvgSupported then
      GlobalSVGHandler := GetD2DSVGHandler
    else
    {$ENDIF}
      GlobalSVGHandler := GetPasSVGHandler;
  end;

end.
