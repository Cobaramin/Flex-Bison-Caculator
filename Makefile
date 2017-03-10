fb_cal	:	fb_cal.l fb_cal.y
					bison -d fb_cal.y
					flex fb_cal.l
					cc -o $@ fb_cal.tab.c lex.yy.c -lfl -lm
