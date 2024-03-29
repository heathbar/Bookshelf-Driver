CON
'***************************************
'  Hardware related settings
'***************************************
  _clkmode = xtal1 + pll16x                             'Use the PLL to multiple the external clock by 16
  _xinfreq = 5_000_000                                  'An external clock of 5MHz. is used (80MHz. operation)


'***************************************
'  I/O Definitions
'***************************************

  _rx        = 31
  _tx        = 30
  _gsclk     = 16             'gsclk
  _xlat      = 17             'xlat
  _blank     = 18             'blank
  _sin       = 19             'sin
  _sclk      = 20             'sclk
  _vprg      = 21             'vprg


  _OUTPUT       = 1             'Sets pin to output in DIRA register
  _INPUT        = 0             'Sets pin to input in DIRA register
  _HIGH         = 1             'High=ON=1=3.3v DC
  _LOW          = 0             'Low=OFF=0=0v DC
  _ON           = 1             'what the deuce do you think this means?
  _OFF          = 0             'As if this needs to be commented
  _ENABLE       = 1             'Enable (turn on) function/mode
  _DISABLE      = 0             'Disable (turn off) function/mode

'***************************************
'  Other Definitions
'***************************************
  _baseOffset = 0               'Number of TLC channels to skip, you probably want to leave this at zero.


OBJ

  TLC           : "TLC5940_Driver"
  Serial        : "FullDuplexSerial"

var
  long ledPin
PUB MAIN | i, ch, inByte, inWord

  Serial.start(_rx, _tx, 0, 38_400)

  TLC.Start(_sclk, _sin, _xlat, _gsclk, _blank, _vprg, _baseOffset)
  TLC.SetAllChannels(0)
  TLC.Update

'  ledPin := 15
'  dira[15] := 1
'  outa[15] := 1

  TLC.SetReds(2048)
  Pause(300)
  TLC.SetReds(0)
  TLC.SetGreens(2048)
  Pause(300)
  TLC.SetGreens(0)
  TLC.SetBlues(2048)
  Pause(300)
  TLC.SetBlues(0)

  TLC.SetAllChannels(1000)

  Serial.str(string("Ready..."))


  'Walk through each channel
  repeat
      ch := Serial.rx

      if (ch == $FF)
          TLC.Update
          next

      inByte := Serial.rx
      bytemove(@byte[@inWord][1], @inByte, 1)
      inByte := Serial.rx
      bytemove(@byte[@inWord][0], @inByte, 1)

      if (ch == $F0)
        TLC.SetAllChannels(inWord)
      elseif (ch == $F1)
        TLC.SetReds(inWord)
      elseif (ch == $F2)
        TLC.SetGreens(inWord)
      elseif (ch == $F3)
        TLC.SetBlues(inWord)
      else
        TLC.SetChannel(ch, inWord)


PRI FadeOut(


PRI Pause(Duration)
'' Pause execution in milliseconds.
'' Duration = number of milliseconds to delay

  waitcnt(((clkfreq / 1_000 * Duration)) + cnt)

'*************************************** 
{{
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                   TERMS OF USE: MIT License                                                  │ │                                                                                                                              │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    │ 
│files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,    │
│modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software│
│is furnished to do so, subject to the following conditions:                                                                   │
│                                                                                                                              │
│The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.│
│                                                                                                                              │
│THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          │
│WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         │
│COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   │
│ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
}}
