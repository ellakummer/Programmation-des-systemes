// compter le nombre de bit à 1 dans un registre : REGISTRE 6 (contenu)

// r0: compteur de bits à 1 dans le mot à compter
// r1: compteur de boucle 1->32
// r2: on met le bitfaible(0x0000001) pour pouvoir faire le and
// r3: ou on récupère le bit de poids faible (0 ou 1)
// r4: résultat division/décalage à enregistré dans contenu
// r6: mot dont on va compter les bits 1

         .data
contenu: .word  0xFFFFFFFE//0b101101 // mot à compter
bitfaible: .word  0x00000001
str:     .asciz "nombre de bits dans le registre:  = %d\n"

        .text
        .globl  main

done:   mov pc,lr
        // revenir au programme, ou on en était dans l'execution (lr enregistre par BL)


compte:
        // itérer sur les 32bits

        // ce que l'on va compter:
        ldr r6,=contenu
        ldr r6,[r6]

        // 32 fois :
        cmp r1,#33
        bge done // si on a fait nos 32 itérations, on finit

        // récupérer premier bit (dans r3)(AND 0...01 = 0x00000001 en hexadecimale = bitfaible)
        and r3,r6,r2

        // si le bit de poids faible = 1, compteur+=1 (compteur=r0)
        cmp r3,#1
        addeq r0,r0,#1

        // décaler de 1 à droite -> prendre prochain bit de poids faible (garder dans r4)
        mov r4,r6, LSR #1

        // garder le nouveau mot : (dont on prendra à nouveau le bit de poids faible)
        ldr r6,=contenu
        str r4,[r6]

        // itération suivante :
        add r1,r1,#1
        b compte

main: // sauver link register
      stmfd sp!,{lr}

      ldr r2,=bitfaible // récupère operateur comparaison AND
      ldr r2,[r2]
      mov r1,#1 // compteur de boucle 1->32
      mov r0,#0 // r0 sera notre compteur de bits1 dans la sous-routine
      bl compte // bl mets dans lr le pc qu'il faut pour qu'on revienne

      // affichage (dans printf : r0=string, r1 = valeur)
      mov r1,r0 // ce qu'on voudra afficher /r0 dans la routine)
      ldr r0,=str
      stmfd sp!, {r0-r4}
      bl printf
      ldmfd sp!, {r0-r4}

      // revenir au systeme dexploitation
      mov r0,#0
      ldmfd sp!, {lr}
      mov pc,lr
