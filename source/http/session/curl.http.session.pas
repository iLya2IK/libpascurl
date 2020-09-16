(******************************************************************************)
(*                                 libPasCURL                                 *)
(*                 object pascal wrapper around cURL library                  *)
(*                        https://github.com/curl/curl                        *)
(*                                                                            *)
(* Copyright (c) 2020                                       Ivan Semenkov     *)
(* https://github.com/isemenkov/libpascurl                  ivan@semenkov.pro *)
(*                                                          Ukraine           *)
(******************************************************************************)
(*                                                                            *)
(* This source  is free software;  you can redistribute  it and/or modify  it *)
(* under the terms of the GNU General Public License as published by the Free *)
(* Software Foundation; either version 3 of the License.                      *)
(*                                                                            *)
(* This code is distributed in the  hope that it will  be useful, but WITHOUT *)
(* ANY  WARRANTY;  without even  the implied  warranty of MERCHANTABILITY  or *)
(* FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License for *)
(* more details.                                                              *)
(*                                                                            *)
(* A copy  of the  GNU General Public License is available  on the World Wide *)
(* Web at <http://www.gnu.org/copyleft/gpl.html>. You  can also obtain  it by *)
(* writing to the Free Software Foundation, Inc., 51  Franklin Street - Fifth *)
(* Floor, Boston, MA 02110-1335, USA.                                         *)
(*                                                                            *)
(******************************************************************************)

unit curl.http.session;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils, curl.session, curl.http.response, curl.utils.headers_list,
  curl.http.session.property_modules.protocols, 
  curl.http.session.property_modules.writer,
  curl.http.session.property_modules.request,
  curl.http.session.property_modules.options,
  curl.http.session.property_modules.header,
  curl.http.session.property_modules.redirect,
  curl.http.session.property_modules.dns,
  curl.http.session.property_modules.tcp;

type
  THTTP = class
  public
    type
      TResponse = class(curl.http.response.TResponse);
      TSession = class(curl.session.TSession)
      protected
        FHeadersList : THeadersList;

        FWriter : TModuleWriter;
        FHeader : TModuleHeader;
        FProtocols : TModuleProtocols; 
        FRequest : TModuleRequest;
        FOptions : TModuleOptions;
        FRedirect : TModuleRedirect;
        FDNS : TModuleDNS;
        FTCP : TModuleTCP;
      public
        constructor Create;
        destructor Destroy; override; 

        { Provide access to CURL library error messages storage. }
        property Errors;

        { Provide the URL to use in the request. }
        property Url;  

        { Get request options. }
        property Request : TModuleRequest read FRequest; 

        { Get download writer object. }
        property Download : TModuleWriter read FWriter;

        { Set options. }
        property Options : TModuleOptions read FOptions;

        { Set redirect options. }
        property Redirect : TModuleRedirect read FRedirect;

        { Set DNS property. }
        property DNS : TModuleDNS read FDNS;

        { Set TCP properties. }
        property TCP : TModuleTCP read FTCP;

        { Send current request using GET method. }
        function Get : TResponse;
      end;
  end;    

implementation

uses
  curl.protocol, curl.http.request.method;

{ THTTP.TSession }

constructor THTTP.TSession.Create;
begin
  inherited Create;
  FHeadersList := THeadersList.Create;

  FProtocols := TModuleProtocols.Create(Handle, ErrorsStorage);
  FWriter := TModuleWriter.Create(Handle, ErrorsStorage, MemoryBuffer);
  FHeader := TModuleHeader.Create(Handle, ErrorsStorage, @FHeadersList);
  FRequest := TModuleRequest.Create(Handle, ErrorsStorage);
  FOptions := TModuleOptions.Create(Handle, ErrorsStorage);
  FRedirect := TModuleRedirect.Create(Handle, ErrorsStorage);
  FDNS := TModuleDNS.Create(Handle, ErrorsStorage);
  FTCP := TModuleTCP.Create(Handle, ErrorsStorage);
  
  FProtocols.Allowed := [PROTOCOL_HTTP, PROTOCOL_HTTPS];
  FProtocols.AllowedRedirects := [PROTOCOL_HTTP, PROTOCOL_HTTPS];
  FProtocols.Default := PROTOCOL_HTTPS;
end;

destructor THTTP.TSession.Destroy;
begin
  FreeAndNil(FHeadersList);
  
  FreeAndNil(FProtocols);
  FreeAndNil(FWriter);
  FreeAndNil(FRequest);
  FreeAndNil(FOptions);
  FreeAndNil(FRedirect);
  FreeAndNil(FDNS);
  FreeAndNil(FTCP);

  inherited Destroy;
end;

function THTTP.TSession.Get : TResponse;
begin
  FRequest.Method := TMethod.GET;
  Result := TResponse.Create(Handle, ErrorsStorage, MemoryBuffer, 
    @FHeadersList);
end;

end.
