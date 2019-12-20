.data

n:  .word 16
str:.asciz "valeur:  = %u\n"

.text
.globl main


// r0: string d'affichage
// r1: resultat final division
// r2: q
// r3: r
// r4: N
// r5: d
// r6: r >> N
// r7: 0
// r8: d<<N
// r9: 1<<N
// r10: 1

// ATTENTION : faire en non-signé
// (sinon grands nombres négatifs)

boucle :
  // N--
  sub r4,r4,#1
  // r >> N
  mov r7,#0
  add r6,r7,r3,lsr r4
  //if ((r>>N) < d)
  cmp r5,r6 // changé ordre pour r6
  // si < (ls)
  // r -= (d<<N);
  addls r8,r7,r5, lsl r4
  subls r3,r3,r8
  // q += (1<<N);
  mov r10,#1
  addls r9,r7,r10, lsl r4
  addls r2,r2,r9

  // while(N)
  cmp r4,#0
  bne boucle
  mov pc,lr

main:
  // sauvegarde environnement (sauver link register : revenir à la fin de la routine)
  stmfd sp!,{lr}

  // CHARGEMENT VARIABLES :
  // q = 0
  mov r2,#0
  //r = n
  ldr r3,=n
  ldr r3,[r3]
  // N = 32
  mov r4,#32
  // d  = 5 (diviser 8 par 4)
  mov r5,#4

  // boucle :
  bl boucle

  // test division :
  ldr r0,=str
  mov r1,r2
  stmfd sp!, {r0-r4}
  bl printf
  ldmfd sp!, {r0-r4}

  // retour à l'environnement d'avant routine
  mov r0,#0
  ldmfd sp!, {lr}
  mov pc,lr
