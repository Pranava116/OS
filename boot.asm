bits 16 
org 0x7c00
start: jmp loader


TIMES 0Bh-$+start DB 0
bpbBytesPerSector:  	DW 512
bpbSectorsPerCluster: 	DB 1
bpbReservedSectors: 	DW 1
bpbNumberOfFATs: 	    DB 2
bpbRootEntries: 	    DW 224
bpbTotalSectors: 	    DW 2880
bpbMedia: 	            DB 0xF0
bpbSectorsPerFAT: 	    DW 9
bpbSectorsPerTrack: 	DW 18
bpbHeadsPerCylinder: 	DW 2
bpbHiddenSectors: 	    DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber: 	        DB 0
bsUnused: 	            DB 0
bsExtBootSignature: 	DB 0x29
bsSerialNumber:	        DD 0xa0a1a2a3
bsVolumeLabel: 	        DB "MOS FLOPPY "
bsFileSystem: 	        DB "FAT12   "

msg db "potatOS", 0

Print: 
    lodsb
    or        al, al
    jz        PrintDone
    mov       ah, 0eh
    int       10h
    jmp Print
PrintDone:
    ret
loader: 
      xor ax, ax
      mov ds, ax
      mov es, ax
      mov si, msg
      call Print
      xor ax, ax
      int 0x12
      cli 
      hlt
times 510 - ($ - $$) db 0
 dw 0xAA55
-----------------------------------------------------------------------------------------------------------------------------
                                    -- SHELL (THE SIGMA 🗿🗿) --

shell - infinite loop of doom (basic shell working)

so now we made the shell which is basically the thing user screams at and expects the OS to obey

flow of execution:
 kernel_main -> calls shell_main -> now shell has full control and kernel is just chilling in the background

the shell is just a infinite loop (yes it never ends unless system dies)

while(1) // same as while True in Python 
{
 print("[potatOS] --> ");
 take input
 execute command
}

the "[potatOS] -->" is like saying "yo type something bro"


how input works:

we use get_char() to read input one by one

c = get_char();

what is actually happening:
 key press -> keyboard interrupt -> IDT -> kernel handler -> returns char -> shell grabs it

so we are not directly touching keyboard hardware (too scary), kernel does the dirty work


we store each char in buffer

buffer[i++] = c;

and we also print it instantly

print(str);

this is called echo (basically repeating what user types so they feel heard)


how do we know input is done?

if (c == '\n')

this means ENTER was pressed

so we:
 terminate string using '\0'
 break the loop
 move on


command execution part:

after input is taken we send it to the execution function

execute_command(input);

this is just comparing strings like:

if (strcmp(input, "help") == 0)

if match found -> run that function
else -> roast user with "Unknown command"


commands we added till now:

help -> shows commands
clear -> clears screen (calls kernel function)


important thing:

shell DOES NOT talk to hardware directly
it is too weak for that

it depends on kernel for everything:

print()
get_char()
clear_screen()

kernel is basically the middleman


internally what is happening:

user types key
 -> interrupt fired
 -> IDT handles it
 -> kernel stores char
 -> shell reads it
 -> shell processes it

basically a whole chain reaction just to print a letter 💀


why infinite loop?

because shell should never exit
if it exits = no interface = user stuck staring at nothing


future plans (if we survive):

- command history (so user doesn't have to retype like caveman)
- better parsing (commands with arguments)
- more commands
- file system support
- program execution (big stuff)


current state:

shell is alive
it listens (NOT YET)
it responds (NIT YET)
it judges user input (NOT YET)

OS slowly becoming real 👀
