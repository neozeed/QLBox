#ifndef QL_SDL_INPUT_H
#define QL_SDL_INPUT_H
#include <SDL.h>
int ql_sdl_speed_control(const SDL_Event *e);
int ql_sdl_mouse(const SDL_Event *e);
int ql_sdl_mouse_captured(void);
int ql_sdl_mouse_update(void);
void ql_sdl_mouse_speed(unsigned speed);
void ql_sdl_input(const SDL_Event *e);
#endif
