    .data
a:  .word  0x91e6d6a5
c:  .word  0x91e6d6a5
x:  .word 0xfbfffffb
str:.asciz "valeur multiplication:  = %d\n"

    .text
    .globl  main
random:
        // calcul f(x)
        ldr r2, =a // r2 = adresse de a
        ldr r2,[r2] // r2 = ce qu'il y a à l'adresse pointee par r2 <-> a
        ldr r3,=c
        ldr r3,[r3]
        mla r4,r2,r1,r3 // a*x + c
        ldr r6,=x // on met l'adresse de x dans r6
        str r4,[r6] // modifie l'adresse pointe par r6 -> x (-> au prochain coup, x => f(x))

        // calcul g(x)
        umull r2,r3,r0,r1 // r1 et r0 sur 32 bits -> resultat long : 2 registres : partie basse et partie haute
        // ATTENTION r2 = partie basse, r3 = partie haute
        // divise32 -> prendre la partie haute (r3) des deux registres:comme stocké sur 2
        mov r0,r3 // recupère resultat dans r0

        mov pc,lr // revenir au programme, ou on en était dans l'execution (lr enregistre par BL)

main: stmfd sp!,{lr} // sauver link register

      mov r0, #1000 //n
      ldr r1,=x // sauve l'adresse de x
      ldr r1,[r1] // recupère la valeur à l'adresse
      bl random
      mov r1,r0 // ce qu'on voudra afficher
      ldr r0,=str
      stmfd sp!, {r0-r4}
      bl printf
      ldmfd sp!, {r0-r4}

      mov r0, #1000 //n
      ldr r1,=x
      ldr r1,[r1]
      bl random
      mov r1,r0 // ce qu'on voudra afficher
      ldr r0,=str
      stmfd sp!, {r0-r4} // car printf modifie les registres...
      bl printf
      ldmfd sp!, {r0-r4}

      mov r0, #1000 //n
      ldr r1,=x
      ldr r1,[r1]
      bl random
      mov r1,r0 // ce qu'on voudra afficher
      ldr r0,=str
      stmfd sp!, {r0-r4}
      bl printf
      ldmfd sp!, {r0-r4}

      mov r0,#0// revenir au systeme dexploitation
      ldmfd sp!, {lr}
      mov pc,lr
