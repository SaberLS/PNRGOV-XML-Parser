PROG = pnr

all: ${PROG} run

${PROG}.tab.c: ${PROG}.y
	bison -Wcounterexamples -d ${PROG}.y

lex.yy.c: ${PROG}lex.l
	flex ${PROG}lex.l

${PROG}: ${PROG}.tab.c lex.yy.c
	gcc -o ${PROG} ${PROG}.tab.c lex.yy.c -lfl

run: ${PROG}
	./${PROG} <test_pnr.xml
	./${PROG} <test_pnr_2.xml
	./${PROG} <test_pnr_3.xml

clean:
	rm -f ${PROG} ${PROG}.tab.c ${PROG}.tab.h lex.yy.c
