.data

T:  .word 4,3,1,2,5
i:
j:
str:.asciz "chaine de caractère%d\n"

.text
.globl main


main:
  // sauvegarde environnement (sauver link register : revenir à la fin de la routine)
  stmfd sp!,{lr}

  // preparation du write:
  // chaine de caractère :
  ldr r1,=str
  // mettre dans r0 la sortie (man syscall)
  // stdout = 1 (sortie standart = console)
  mov r0,#1
  // nbre de bites à afficher :
  mov r2,#20

  // appel système pour write
  // mettre dans r7 le numero de la procedure write :
  // https://gist.github.com/duckinator/278652
  // man syscall : mettre dans r7 le numero de la procedure
  //que l'on veut appeler (ici write)
  mov r7,#4
  // appel : MAN SYSCALL
  swi 0x0

  // retour à l'environnement d'avant routine
  mov r0,#0
  ldmfd sp!, {lr}
  mov pc,lr
