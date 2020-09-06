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

unit curl.http.response;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils, libpascurl, curl.utils.errors_stack,  curl.response,
  container.avltree, utils.functor,
  curl.http.response.property_modules.content,
  curl.http.response.property_modules.timeout,
  curl.http.response.property_modules.redirect;

type
  TResponse = class(curl.response.TResponse)
  protected
    type
      THeadersList = specialize TAvlTree<String, String, TCompareFunctorString>;
  protected
    FContent : TModuleContent;
    FTimeout : TModuleTimeout;
    FRedirect : TModuleRedirect;
  public
    constructor Create (ACURL : libpascurl.CURL; AErrorsStack : PErrorsStack;
      ABuffer : PMemoryBuffer);
    destructor Destroy; override;
    
    { Provide access to CURL error messages storage. }
    property Errors;

    { Get content data. }
    property Content : TModuleContent read FContent;

    { Get timeouts info. }
    property Timeout : TModuleTimeout read FTimeout;

    { Get redirects info. }
    property Redirect : TModuleRedirect read FRedirect;
  end;

implementation

{ TResponse }

constructor TResponse.Create (ACURL : libpascurl.CURL; AErrorsStack :
  PErrorsStack; ABuffer : PMemoryBuffer);
begin
  inherited Create(ACURL, AErrorsStack, ABuffer);
  FContent := TModuleContent.Create(Handle, ErrorsStorage, MemoryBuffer);
  FTimeout := TModuleTimeout.Create(Handle, ErrorsStorage);
  FRedirect := TModuleRedirect.Create(Handle, ErrorsStorage);
end;

destructor TResponse.Destroy;
begin
  FreeAndNil(FContent);
  FreeAndNil(FTimeout);
  FreeAndNil(FRedirect);
  inherited Destroy;
end;

end.
