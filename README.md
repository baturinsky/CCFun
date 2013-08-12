#CCFun - assorted programs for ComputerCraft 

##License

BSD

##Programs included

###Legion

This is a program that makes installing programs on new turtles (or computers) very easy. 
Put this program on floppy as "disk/startup", and files that you need to install in "disk/install" directory.
Then just place computer or turtle beside disk drive, and right-click on it to activate.

If there is a file "disk/label" with text, then it will be used to label each turtle/computer. 
If it is a string with number, then this string will be the id, with number auto-incrementing each time.
If it is just a single word "id" (two letters), then labels will be set, based on innate turtle/computer id.

###Sfx
This program makes a self-extracting archive from a directory, to make sharing libraries via pastebin easier.

First argument is source directory, second is target file.

Created file is a program, that takes one argument - target directory.

For example:

```
sfx disk disk.sfx
pastebin put disk.sfx
```

Then on some other computer on some other server:

```
pastebin get D0YXE0qX disk.sfx
disk.sfx disk
```

to get exact copy of the first disk

###Ex

This program id similar to default digging program "excavate", but is up to 3x times more effective, because it digs three rows at once.

Controls:

```
ex f4r5d6 - excavate block 4 (f)orward, 5 (r)ight and 6 (d)own

ex back, ex right, ex left - turn turtle

ex x1y2z-3 - move relative to starting point
```  

Put fuel in first row
You can put junk (dirt, cobble, etc) specimens in second row, then they will be disposed in stacks of 60. Saves fuel, time and storage space.

###Slabber

Takes cobble (or some other slab-able blocks) from top chest and "cuts" it into cobble slabs and drops them into front chest.
Slabs fit for IndustrialCraft2 recyclers, so if you have a cobble generator, this robot can double it's effectivity.
Any turtle can do this, no need for diamond tools.
I recommend to put it in Startup.

###Gens

Another program for IndustrialCraft2. Places "forests" of windmill generators, connected with tin cable.

Places one or more 32-height columns of windmills, with horisontal step of 7. Can place up to 6 columns.
Load 128 mills per column in first 12 slots, 32 tin cable per column in slots 13-15 and any fuel in slot 16.

Again, any turtle can do this.
