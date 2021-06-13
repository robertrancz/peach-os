#include "kernel.h"
#include <stdint.h>

uint16_t* video_mem = 0;

uint16_t terminal_make_char(char c, char colour)
{
    return (colour << 8) | c;
}

void terminal_initialize()
{
    video_mem = (uint16_t*)(0xB8000);

    // set a blank black display
    for (int y = 0; y < VGA_HEIGHT; y++)
    {
        for (int x = 0; x < VGA_WIDTH; x++)
        {
            video_mem[(y * VGA_WIDTH) + x] = terminal_make_char(' ', 0);
        }
    }
}

void kernel_main()
{
    terminal_initialize();

    // Put a white B on screen
    video_mem[0] = terminal_make_char('B', 15);

    /*
    char* video_mem = (char*)(0xB8000);
    video_mem[0] = 'A';     // code byte
    video_mem[1] = 2;       // attribute byte (2 = green)
    */
}