    .data

T:  .word 3,1,2
str:.asciz "valeur:  = %d\n"

    .text
    .globl main

// r0: string d'affichage
// r1: compteur première boucle for
// r2 compteur deuxième boucle for
// r3: récupère contenu de T[j+1]
// r4: récupère contenu de T[j+1]
// r5: i-1 comparaison première boucle
// r6: compteur+1 deuxième boucle for (pour T[j+1])
// r7: adresse de T[0] (adresse de T)
// r8: adresse T[j]
// r9: adresse T[j+1]
// r10: sauvegarde pc pour le retour au main 


loop1 : // première boucle for : i=N-1;i>=1
      cmp r1, #1 // car tableau de 3 éléments (N éléments)
      // si le compteur arrive à <1, on finit la boucle
      blt done1 // lt: plus petit signé
      // sinon on entre dans la deuxième boucle :
      sub r5,r1,#1 // r5 = i-1 = condition arrêt boucle 2
      bl loop2

      sub r1,r1,#1 // r2-1 -> on veut aller de N-1 à 1
      b loop1


loop2:  // deuxième boucle for : j=0;j<=i-1
      cmp r2,r5
      bgt done2 // gt => plus grand signé

      add r6,r2,#1 // compteur+1 pour accéder à T[j+1] (r6)
      ldr r7,=T // adresse de T

      add r9,r7,r6,asl #2 // adresse = T+4*(compteur+1) : adresse T[j+1] (*4 car mot sur 32 bits=4*8bytes et on itère par bytes)
      ldr r3,[r9] // récupère contenu de T[j+1]

      add r8,r7,r2,asl #2 // adresse = T+4*compteur : adresse T[j]
      ldr r4,[r8] // récupère contenu de T[j]

      cmp r3,r4 // comparaison T[j+1]<T[j]
      // lt => plus petit ou égal -> échanger
      strlt r4,[r9] // on met le contenu de T[j] (r4) dans T[j+1]
      strlt r3,[r8]

      add r2,r2,#1
      b loop2

done2:
      mov pc,lr

done1:
      mov pc,r10

main: // sauvegarde environnement (sauver link register : revenir à la fin de la routine)
      stmfd sp!,{lr}

      // boucle
      mov r1,#2 // N-1 : compteur loop1
      mov r2,#0 // compteur loop 2

      mov r10,pc // on garde où on reviendra à la fin de la grosse boucle (bl gardera dans le link register, mais sera modifié à l'appel de la deuxième boucle for pour revenir dans la première )

      bl loop1

      // test modification array T :
      ldr r0,=str
      ldr r1,=T // adresse de T
      //add r1,r1,#4 //adresse deuxième elt de T
      //add r1,r1,#8// adresse troisième elt de T
      ldr r1,[r1]
      stmfd sp!, {r0-r4}
      bl printf
      ldmfd sp!, {r0-r4}

      // retour à l'environnement d'avant routine
      mov r0,#0
      ldmfd sp!, {lr}
      mov pc,lr
