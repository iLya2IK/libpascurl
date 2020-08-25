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

unit curl.session.protocol;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  libpascurl;

type
  TProtocol = (
    { DICT is a dictionary network protocol, it allows clients to ask dictionary
      servers about a meaning or explanation for words. See RFC 2229. Dict 
      servers and clients use TCP port 2628. }
    PROTOCOL_DICT                                   = Longint(CURLPROTO_DICT),

    { FILE is not actually a "network" protocol. It is a URL scheme that allows 
      you to tell curl to get a file from the local file system instead of 
      getting it over the network from a remote server. See RFC 1738. }
    PROTOCOL_FILE                                   = Longint(CURLPROTO_FILE),

    { FTP stands for File Transfer Protocol and is an old (originates in the 
      early 1970s) way to transfer files back and forth between a client and a 
      server. See RFC 959. It has been extended greatly over the years. FTP 
      servers and clients use TCP port 21 plus one more port, though the second 
      one is usually dynamically established during communication. }
    PROTOCOL_FTP                                    = Longint(CURLPROTO_FTP),

    { FTPS stands for Secure File Transfer Protocol. It follows the tradition of
      appending an 'S' to the protocol name to signify that the protocol is done
      like normal FTP but with an added SSL/TLS security layer. See RFC 4217.
      This protocol is problematic to use through firewalls and other network 
      equipment. }
    PROTOCOL_FTPS                                   = Longint(CURLPROTO_FTPS),

    { Designed for "distributing, searching, and retrieving documents over the 
      Internet", Gopher is somewhat of the grand father to HTTP as HTTP has 
      mostly taken over completely for the same use cases. See RFC 1436. Gopher 
      servers and clients use TCP port 70. }
    PROTOCOL_GOPHER                                 = Longint(CURLPROTO_GOPHER),

    { The Hypertext Transfer Protocol, HTTP, is the most widely used protocol 
      for transferring data on the web and over the Internet. See RFC 7230 for 
      HTTP/1.1 and RFC 7540 for HTTP/2. HTTP servers and clients use TCP port 
      80. }
    PROTOCOL_HTTP                                   = Longint(CURLPROTO_HTTP),

    { Secure HTTP is HTTP done over an SSL/TLS connection. See RFC 2818. HTTPS 
      servers and clients use TCP port 443, unless they speak HTTP/3 which then 
      uses QUIC and is done over UDP... }
    PROTOCOL_HTTPS                                  = Longint(CURLPROTO_HTTPS),

    { The Internet Message Access Protocol, IMAP, is a protocol for accessing, 
      controlling and "reading" email. See RFC 3501. IMAP servers and clients 
      use TCP port 143. Whilst connections to the server start out as cleartext,
      SSL/TLS communication may be supported by the client explicitly requesting
      to upgrade the connection using the STARTTLS command. See RFC 2595. }
    PROTOCOL_IMAP                                   = Longint(CURLPROTO_IMAP),

    { Secure IMAP is IMAP done over an SSL/TLS connection. Such connections 
      implicitly start out using SSL/TLS and as such servers and clients use TCP
      port 993 to communicate with each other. See RFC 8314. }
    PROTOCOL_IMAPS                                  = Longint(CURLPROTO_IMAPS),

    { The Lightweight Directory Access Protocol, LDAP, is a protocol for
      accessing and maintaining distributed directory information. Basically a 
      database lookup. See RFC 4511. LDAP servers and clients use TCP port 389.}
    PROTOCOL_LDAP                                   = Longint(CURLPROTO_LDAP),

    { Secure LDAP is LDAP done over an SSL/TLS connection. }
    PROTOCOL_LDAPS                                  = Longint(CURLPROTO_LDAPS),

    { The Post Office Protocol version 3 (POP3) is a protocol for retrieving 
      email from a server. See RFC 1939. POP3 servers and clients use TCP port 
      110. Whilst connections to the server start out as cleartext, SSL/TLS 
      communication may be supported by the client explicitly requesting to 
      upgrade the connection using the STLS command. See RFC 2595. }
    PROTOCOL_POP3                                   = Longint(CURLPROTO_POP3),

    { Secure POP3 is POP3 done over an SSL/TLS connection. Such connections 
      implicitly start out using SSL/TLS and as such servers and clients use TCP
      port 995 to communicate with each other. See RFC 8314. }
    PROTOCOL_POP3S                                  = Longint(CURLPROTO_POP3S),

    { The Real-Time Messaging Protocol (RTMP) is a protocol for streaming audio,
      video and data. RTMP servers and clients use TCP port 1935. }
    PROTOCOL_RTMP                                   = Longint(CURLPROTO_RTMP),
    PROTOCOL_RTMPE                                  = Longint(CURLPROTO_RTMPE),
    PROTOCOL_RTMPS                                  = Longint(CURLPROTO_RTMPS),
    PROTOCOL_RTMPT                                  = Longint(CURLPROTO_RTMPT),
    PROTOCOL_RTMPTE                                 = Longint(CURLPROTO_RTMPTE),
    PROTOCOL_RTMPTS                                 = Longint(CURLPROTO_RTMPTS),

    { The Real Time Streaming Protocol (RTSP) is a network control protocol to 
      control streaming media servers. See RFC 2326. RTSP servers and clients 
      use TCP and UDP port 554. }
    PROTOCOL_RTSP                                   = Longint(CURLPROTO_RTSP),

    { The Secure Copy (SCP) protocol is designed to copy files to and from a 
      remote SSH server. SCP servers and clients use TCP port 22. }
    PROTOCOL_SCP                                    = Longint(CURLPROTO_SCP),

    { The SSH File Transfer Protocol (SFTP) that provides file access, file 
      transfer, and file management over a reliable data stream. SFTP servers 
      and clients use TCP port 22. }
    PROTOCOL_SFTP                                   = Longint(CURLPROTO_SFTP),

    { The Server Message Block (SMB) protocol is also known as CIFS. It is an 
      application-layer network protocol mainly used for providing shared access
      to files, printers, and serial ports and miscellaneous communications 
      between nodes on a network. SMB servers and clients use TCP port 445. }
    PROTOCOL_SMB                                    = Longint(CURLPROTO_SMB),
    PROTOCOL_SMBS                                   = Longint(CURLPROTO_SMBS),

    { The Simple Mail Transfer Protocol (SMTP) is a protocol for email 
      transmission. See RFC 5321. SMTP servers and clients use TCP port 25. 
      Whilst connections to the server start out as cleartext, SSL/TLS 
      communication may be supported by the client explicitly requesting to 
      upgrade the connection using the STARTTLS command. See RFC 3207. }
    PROTOCOL_SMTP                                   = Longint(CURLPROTO_SMTP),

    { Secure SMTP, sometimes called SSMTP, is SMTP done over an SSL/TLS
      connection. Such connections implicitly start out using SSL/TLS and as 
      such servers and clients use TCP port 465 to communicate with each other. 
      See RFC 8314. }
    PROTOCOL_SMTPS                                  = Longint(CURLPROTO_SMTPS),

    { TELNET is an application layer protocol used over networks to provide a 
      bidirectional interactive text-oriented communication facility using a 
      virtual terminal connection. See RFC 854. TELNET servers and clients use 
      TCP port 23. }
    PROTOCOL_TELNET                                 = Longint(CURLPROTO_TELNET),

    { The Trivial File Transfer Protocol (TFTP) is a protocol for doing simple 
      file transfers over UDP to get a file from or put a file onto a remote 
      host. TFTP servers and clients use UDP port 69. }
    PROTOCOL_TFTP                                   = Longint(CURLPROTO_TFTP)
  );

  TProtocols = set of TProtocol;

implementation

end.
