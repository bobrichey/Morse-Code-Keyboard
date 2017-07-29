/*
Program: Morse Code Keyboard
Name: Bob Richey
Date: 10/19/2014, updated 1/4/2015
*/

Hid hid;

HidMsg msg;

0 => int device;

if (hid.openKeyboard(device) == false) me.exit();

<<< "msg.asciiboard:", hid.name(), "ready!" >>>;

SinOsc sin => Envelope env => dac;

0.3 => sin.gain;
440 => sin.freq;

50::ms => dur dit;

dit / 10 => env.duration;

// morse code array
[
[0, 1], // A
[1, 0, 0, 0], // B
[1, 0, 1, 0], // C
[1, 0, 0], // D
[0], // E
[0, 0, 1, 0], // F
[1, 1, 0], // G
[0, 0, 0, 0], // H
[0, 0], // I
[0, 1, 1, 1], // J
[1, 0, 1], // K
[0, 1, 0, 0], // L
[1, 1], // M
[1, 0], // N
[1, 1, 1], // O
[0, 1, 1, 0], // P
[1, 1, 0, 1], // Q
[0, 1, 0], // R
[0, 0, 0], // S
[1], // T
[0, 0, 1], // U
[0, 0, 0, 1], // V
[0, 1, 1], // W
[1, 0, 0, 1], // X
[1, 0, 1, 1], // Y
[1, 1, 0, 0], // Z
[1, 1, 1, 1, 1], // 0
[0, 1, 1, 1, 1], // 1
[0, 0, 1, 1, 1], // 2
[0, 0, 0, 1, 1], // 3
[0, 0, 0, 0, 1], // 4
[0, 0, 0, 0, 0], // 5
[1, 0, 0, 0, 0], // 6
[1, 1, 0, 0, 0], // 7
[1, 1, 1, 0, 0], // 8
[1, 1, 1, 1, 0], // 9
[2], // SPACE
[2] // undefined character
] @=> int morse[][];

// character array (for printing to console)
[
"A:  ._", 
"B:  _...", 
"C:  _._.", 
"D:  _..", 
"E:  .",
"F:  .._.", 
"G:  __.", 
"H:  ....", 
"I:  ..", 
"J:  .___", 
"K:  _._", 
"L:  ._..", 
"M:  __", 
"N:  _.", 
"O:  ___", 
"P:  .__.", 
"Q:  __._",
"R:  ._.", 
"S:  ...", 
"T:  _", 
"U:  .._", 
"V:  ..._", 
"W:  .__", 
"X:  _.._", 
"Y:  _.__", 
"Z:  __..", 
"0:  _____", 
"1:  .____", 
"2:  ..___", 
"3:  ...__", 
"4:  ...._", 
"5:  .....", 
"6:  _....", 
"7:  __...", 
"8:  ___..", 
"9:  ____.", 
"", 
"ERROR: undefined character"
] @=> string chars[];

while (true)
{
    hid => now;
    
    while (hid.recv(msg))
    {
        if (msg.isButtonDown())
        {            
            if (msg.ascii > 64 && msg.ascii < 91)
            {
                65 -=> msg.ascii;
            }
            else if (msg.ascii > 47 && msg.ascii < 58)
            {
                22 -=> msg.ascii;
            }
            else if (msg.ascii == 32)
            {
                36 => msg.ascii;
            }
            else
            {
                37 => msg.ascii;
            }
            
            <<< chars[msg.ascii], "" >>>;
            
            for (0 => int i; i < morse[msg.ascii].cap(); i++)
            {
                playMorse(morse[msg.ascii][i]);
            }
            
            dit * 2 => now;
        }
    }
}

fun void playMorse(int dotOrDash)
{
    if (dotOrDash == 0)
    {
        1 => env.keyOn;
        dit => now;
        1 => env.keyOff;
        dit => now;
    }
    else if (dotOrDash == 1)
    {
        1 => env.keyOn;
        dit * 3 => now;
        1 => env.keyOff;
        dit => now;
    }   
    else
    {
        dit * 5 => now; 
    }
}