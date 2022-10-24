{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit pascurl_lib;

{$warn 5023 off : no warning about unused units}
interface

uses
  libpascurl, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('pascurl_lib', @Register);
end.
