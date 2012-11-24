#CCFun - assorted programs for ComputerCraft 

##License

BSD

##Programs included

###Legion

Programm for mass installing programs on machines. Put this program on floppy as "startup", files that you need to install in disk/install and label for machines in disk/label.
Label may be a string with number (then number will auto-increment) or "id" for labels based on innate machine id.
Then just place machines by disk drive, and right-click on them.

###Sfx
This program makes a self-running archive from directory.
For example:

sfx disk disk.sfx

then swap disk and

disk.sfx disk

to get exact copy of first disk

###Ex

Program similar to default excavate, but 3x times better.

Controls:

ex f4r5d6 - excavate block 4 (f)orward, 5 (r)ight and 6 (d)own

ex back, ex right, ex left - turn

ex x1y2z-3 - move relative to statring point

At start: put fuel in first row, put junk specimens in second row, so they will be disposed of in stacks of 60.

###Slabber

Cuts cobble from top chest into slabs and drops them into front chest.
Slabs fit for IC2 recyclers, so if you have a cobble generator, this robot can double it's effectivity.

Recommended to put it in Startup.

###Gens

Places 32-height columns of windmills on tin cable, wiht horisontal step of 7. Can place up to 6 solumns at one load.
Load 128 mills per column in first 12 slots, 32 tin cable per column in slots 13-15 and any fuel in slot 16.

Any turtle can do this, no need for pickaxe or anything.