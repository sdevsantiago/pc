#include "pc.h"
#include <unistd.h>
#include <signal.h>
#include <curses.h>
#include <string.h>

static void	draw_pc(void);
static void	draw_text(int frame);

int main(
	int argc,
	char const *argv[])
{
	int	frame = (int)strlen(TEXT) + 10;

	(void)argc;
	if (!argv[1] || strncmp(argv[1], "-e", 3) != 0)
		signal(SIGINT, SIG_IGN);
	initscr();
	noecho();
	curs_set(0);
	nodelay(stdscr, TRUE);
	leaveok(stdscr, TRUE);
	scrollok(stdscr, FALSE);
	draw_pc();
	while (frame--)
	{
		draw_text(frame);
		refresh();
		getch();
		usleep(250000);
	}
	mvcur(0, COLS - 1, LINES - 1, 0);
	endwin();
	return (0);
}

static void	draw_pc(void)
{
	const char	*pc[] = {PC1, PC2, PC3, PC4, PC5, PC6, PC7, PC8};
	const char	*kb[] = {KB1, KB2, KB3, KB4, KB5, KB6, KB7, KB8};
	int			cursor_x = COLS / 2 - WIDTH / 2;
	int			cursor_y = 0;
	int			i, j;

	for (i = 0; i < 5; i++)
		mvaddstr(cursor_y + i, cursor_x, pc[i]);
	for (; i < LINES - 11; i++)
		mvaddstr(cursor_y + i, cursor_x, PC4);
	for (j = 0; j < 4; j++)
		mvaddstr(cursor_y + i + j, cursor_x, pc[j + 5]);
	for (j = 0; j < 8; j++)
		mvaddstr(cursor_y + i + j + 3, cursor_x, kb[j]);
}

static void	draw_text(
	int frame)
{
	int	i = (int)strlen(TEXT) - frame - 1 + 10;
	int	cursor_x = COLS / 2 - WIDTH / 2 + 20 + i;
	int	cursor_y = 4;

	if (frame - 10 >= 0)
		mvaddch(cursor_y, cursor_x, TEXT[i]);
	else if (-(frame - 10) % 2)
		mvaddch(cursor_y, COLS / 2 - WIDTH / 2 + 20 + strlen(TEXT), '|');
	else
		mvaddch(cursor_y, COLS / 2 - WIDTH / 2 + 20 + strlen(TEXT), ' ');
}
