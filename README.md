## BPSock (Basic Protocol Socket)

1) Facilitate the use of communication over socket connections.
2) Send queries and receive one or multiple responses.
3) Cancel queries in process.
4) Using a single socket connection to have several simultaneous communication channels.
5) Receive information without the need for an associated query, that is, once the connection is established, either end can send data to the other end even if the other end has not made a request.

### Basic Protocol

2 option for communication:
<pre>
          Asynchronous
CLIENT                  SERVER
Send ------------------> HookHandler
HookHandler <----------- Send

             Request
CLIENT                  SERVER
req -------------------> reqPoint
option: cancel --------> reqPoint
reqHandler <------------ reqPoint
</pre>

Asynchronous: 
Both parties are always ready to receive data at any time, and both parties are can  to send information at any time.

Request: The client sends data that is a request, the server responds to the requested data. Requests can be canceled as long as a response has not been received.

The connection has channel and the tags.The tags are used to identify the data that is being sent or received.
we have 2 type de tag.

- Tag16: The maximum size of the tags is 16 bytes, use for Send and Hook
- Tag8: The maximum size of the tags is 8 bytes, use for (req) request  and reqPoint

 TAG cannot start with numbers.

In order to transmit several channels simultaneously, small data units are processed, which are identified with a TAG. Each unit has a different id, but several ids can be part of the same TAG.

Data Maximum Transmission Unit (DMTU) is the maximum size of the data units.can be sent in. Always lee than 16,777,215.

### The communications

 the communications use:
  2 bytes for the channel id,
 16 bytes for the tag and
 3 bytes (16,777,215) for the data size.

example:
```
id,    TAG                    ,  SIZE , DATA

_ _, _ _ _ _ _ _ _ _ _ _ _ _ _ , _ _ _ , AF02E...

01 00000000000000000000000074616731 000E10 AF02E...
```

