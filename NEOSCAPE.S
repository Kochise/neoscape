; /////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////
; ///                                                                   ///
; ///                         >>> NEO SCAPE <<<                         ///
; ///                                                                   ///
; /////////////////////////////////////////////////////////////////////////
; ///                                                                   ///
; /// FIN AOUT 1995, JE VEUX FAIRE DES MONTAGNES FRACTALES POUR NEON.   ///
; /// JE FAIS UNE PETITE ROUTINE EN GFA QUI SAUVE UN OBJET AU FORMAT    ///
; /// ASCII. JE LANCE NEON, J'ESSAYE DE CHARGER LE FICHIER, MAIS IL Y A ///
; /// UNE ERREUR. JE PREND 7UP, JE VERIFIE MON FICHIER. CORRECT. J'AI   ///
; /// LES NERFS APRES QUELQUES AUTRES ESSAIS INFRUCTUEUX (J'AI SAUVER   ///
; /// DIRECTEMENT DES OBJETS AU FORMAT ASCII SOUS NEON, ET J'AI PAR LA  ///
; /// SUITE TENTE DE LES RECHARGER SOUS NEON). JE TELEPHONE A COMPOSCAN ///
; /// FRANCE, JE LEUR EXPOSE MON PROBLEME, ET ME DISENT QU'ILS VONT EN  ///
; /// PARLER AUX PROGRAMMEUR DE NEON. CINQ MINUTES PLUS TARD, ILS ME    ///
; /// RAPPELLENT ET ME DISENT QU'EN EFFET, NEON N'EST PAS TOUT A FAIT   ///
; /// FINI, ET QU'IL NE CHARGE PAS LES FICHIER ASCII (MEME CEUX QUE     ///
; /// NEON GENERES). JE ME LANCE DANS UN INTERFACAGE GFA-ASSEMBLEUR.    ///
; /// L'ENSEMBLE EST PLUTOT FOIREUX, ET DEBUT JANVIER 1996,             ///
; /// J'ABANDONNE. FIN JUIN 1996, JE ME REMET AU TRAVAIL POUR HONORER   ///
; /// MA PROMESSE DE FAIRE UN CREATEUR DE MONTAGNES FRACTALES POUR      ///
; /// NEON. JE BALANCE MES PREMIERES ROUTINES GFA ET ASSEMBLEUR, ET     ///
; /// DEBUT D'UN RUDE TRAVAIL, NEOSCAPE !                               ///
; ///                                                                   ///
; ///////////////////////////// REMERCIEMENTS /////////////////////////////
; ///                                                                   ///
; /// THANKS TO : ATARI FOR THE FALCON, GREATEST COMPUTER OF THE WORLD  ///
; ///             DIGITAL RESEARCH FOR THEIR FAILING BUT GOOD TOS 4.04  ///
; ///             HISOFT FOR THEIR EXCELLENT DEVPAC 3.1 AND DSP         ///
; ///             TEAM COMPUTER FOR THE SLOW BUT POWERFULL NEON GRAFIX  ///
; ///             ME, FOR MY GREAT AFX LABORATORY OS (AFX-LOS)          ///
; ///                                                                   ///
; ///////////////////////// HISTOIRE DU PROGRAMME /////////////////////////
; ///                                                                   ///
; /// > NEOSCAPE VERSION 0.01 DU 05/27/06/1996                          ///
; ///    |                                                              ///
; ///    | RECUPERATION DES ROUTINES D'INITIALISATION DE AFG VIEWER     ///
; ///    | (AFX-LOS) ET EN-TETE DU FICHIER PROGRAMME.                   ///
; ///    | '______________________________________________________'     ///
; ///    |                                 |                            ///
; ///    |-> VERSION 0.02 (15H31 -> 16H09)-' (00H38 : 00H38)            ///
; ///    |                                                              ///
; ///    | MODIFICATION DES ROUTINES D'INITIALISATIONS ET INCLUSION DE  ///
; ///    | LA ROUTINE GFA DU CALCULATEUR DE MONTAGNES FRACTALES.        ///
; ///    | '_________________________________________________________'  ///
; ///    |                                 |                            ///
; ///    |-> VERSION 0.03 (16H12 -> 16H31)-' (00H19 : 00H57)            ///
; ///    |                                                              ///
; ///    | MODIFICATION DU CALCUTATEUR DE MONTAGNES FRACTALES.          ///
; ///    | '_________________________________________________'          ///
; ///    |                                 |                            ///
; ///    |-> VERSION 0.03 (16H42 -> 16H58)-' (00H16 : 01H13)            ///
; ///    |                                                              ///
; ///    | AMELIORATION DE LA ROUTINE DE CALCUL ET MODIFICATION DE LA   ///
; ///    | ROUTINE D'INITIALISATION.                                    ///
; ///    | '________________________________________________________'   ///
; ///    |                                 |                            ///
; ///    '-> VERSION 0.04 (17H32 -> 18H22)-' (00H50 : 02H03)            ///
; ///                                                                   ///
; /// > NEOSCAPE VERSION 0.04 DU 06/28/06/1996                          ///
; ///    |                                                              ///
; ///    | ECRITURE DE LA ROUTINE DE CALCUL DE MONTAGNE FRACTALE.       ///
; ///    | '____________________________________________________'       ///
; ///    |                                 |                            ///
; ///    |-> VERSION 0.16 (13H07 -> 13H47)-' (00H40 : 02H43)            ///
; ///    |                                                              ///
; ///    | SUITE DE L'ECRITURE DE LA ROUTINE DE CALCUL.                 ///
; ///    | '__________________________________________'                 ///
; ///    |                                 |                            ///
; ///    |-> VERSION 0.42 (15H38 -> 16H07)-' (00H29 : 03H12)            ///
; ///    |                                                              ///
; ///    | JE TERMINE D'ECRIRE LA FIN DE MA ROUTINE DE CALCUL.          ///
; ///    | '_________________________________________________'          ///
; ///    |                                 |                            ///
; ///    |-> VERSION 0.65 (18H04 -> 18H21)-' (00H17 : 03H29)            /// 
; ///    |                                                              ///
; ///    | CREATION DE ROUTINES UTILES POUR LA GESTION DU PROGRAMME.    ///
; ///    | '_______________________________________________________'    ///
; ///    |                                 |                            ///
; ///    '-> VERSION 0.67 (18H29 -> 18H38)-' (00H09 : 03H38)            ///
; ///                                                                   ///
; /////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////
;

; /// RECHERCHE DE LA COMMAND-TAIL ///

START_PROG	move.l	4(SP),A6		; Adresse de la BASEPAGE
	lea	$80(A6),A6		; Adresse de la COMMAND-TAIL
	move.b	(A6)+,D0		; Taille de la COMMAND-TAIL (ATTENTION : Format PASCAL)
	lea	NSD_NAME,A5
	bne	COPY_NSD_NAME
	move.b	#0,(A5)+
	bra	INIT_PRG_MEM

; /// COPIE DE LA COMMAND-TAIL ///

COPY_NSD_NAME	move.b	(A6)+,(A5)+
	subq.b	#1,D0
	bne	COPY_NSD_NAME
	clr.b	(A5)		; Mets un OCTET nul � la fin de la chaine (ATTENTION : Transformation au format C)

; /// INITIALISATION DU PROGRAMME ///

INIT_PRG_MEM	movea.l	4(SP),A6		; Adresse de la BASEPAGE
	move.l	$C(A6),D0		; Taille du programme
	add.l	$14(A6),D0		; Additionne la taille du SEGMENT DATA � D0
	add.l	$1C(A6),D0		; Additionne la taille du SEGMENT BSS � D0
	addi.l	#$100,D0		; Additionne la taille de la BASEPAGE � D0
	addi.l	#$400,D0		; Additionne la taille de la future PILE (Ici, 256 positions longues (1024 OCTETS))
	move.l	D0,D1		; Copie D0 dans D1 (Taille � r�server)
	add.l	A6,D1		; Additionne l'adresse du d�but du programme avec D1 (La taille � r�server)
	andi.l	#-2,D1		; Rend D1 pair (Au cas o� il ne l'�tait pas)
	move.l	SP,OLD_STACK
	movea.l	D1,SP		; Installe l'adresse de fin du programme+place nouvelle PILE dans la PILE
	move.l	D0,-(SP)		; EmPILE la taille � reserver	\
	move.l	A6,-(SP)		; EmPILE l'adresse du programme |-> Rend le reste de la m�moire au syst�me
	clr.w	-(SP)		; R�serv�                       |
	move.w	#$4A,-(SP)		; - M_SHRINK -                  |
	trap	#1		; *** GEMDOS ***                /
	lea	12(SP),SP
	tst	D0		; Si D0<>0, probl�me grave
	bne	SYS_ERROR


; /// ROUTINE DE RESERVATION DE LA MEMOIRE ///

MEM_ALLOC

; /// ROUTINE DE LIBERATION DE LA MEMOIRE ///

MEM_FREE

; /// PROGRAMME DE GESTION PRINCIPAL ///

MAIN_PROG

; /// ROUTINE DE CHANGEMENT DE RESOLUTION (768*576 256 couleurs) ///

MAP_RESO

; /// LA PALETTE DE COULEURS ///

PAL_MONT	incbin	D:\LIB'ZONE.III\NEOSCAPE\PAL_MONT.DAC

; /// ROUTINE DE MISE EN PLACE DE LA PALETTE ///

PUT_PAL	lea	OLD_PAL,A6
	move.l	#$FF9800,A5
	move.b	#255,D0
SAVE_PAL	move.l	(A5)+,(A6)+
	dbf	D0,SAVE_PAL
	lea	PAL_MONT,A5
	move.l	#$FF9800,A6
	move.b	#255,D0
PAINT_PAL	move.l	(A5)+,D1
	move.l	D1,D2
	clr.b	D2
	rol.l	#8,D2
	move.b	D1,D2
	move.l	D2,(A6)+
	dbf	D0,PAINT_PAL
	rts

; /// ROUTINE DE RESTAURATION DE LA PALETTE ///

BEFORE_PAL	lea	OLD_PAL,A5
	move.l	#$FF9800,A6
	move.b	#255,D0
RESTORE_PAL	move.l	(A5)+,(A6)+
	dbf	D0,RESTORE_PAL
	rts

; /// ROUTINE DE REMISE A L'ANCIENNE RESOLUTION ///

OLD_RESO

; /// ROUTINE DE CHARGEMENT AU FORMAT NSD ///

LOAD_NSD

; /// ROUTINE DE SAUVEGARDE AU FORMAT NSD ///

SAVE_NSD

; /// ROUTINE DE SAUVEGARDE AU FORMAT NEON BINAIRE ///

SAVE_NEON

; /// INITIALISATION DU CALCUL AUTOMATIQUE DE LA MONTAGNE FRACTALE ///

AUTO_INIT	move.w	#256,AMP
	move.w	#2,NB

; /// ROUTINE DE CALCUL DE LA MONTAGNE FRACTALE ///

FRACTAL_CALC	move.w	AMP,D2
	fmove.w	D2,FP6
	move.w	NB,D7
	move.l	ITER,D6
	move.l	#1,D5
CALC_SESSION	move.l	D7,D4
	move.l	D7,D3
ECARTY	lea	TAB_ADR,A4	
ECARTX	move.l	D3,D0		; h%(i%,j%)
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	mulu.l	D4,D1
	add.l	D0,D1
	movea.l	A4,A5
 	adda.l	D1,A5
 	
 	move.l	D3,D0		; h%(i%*2,j%*2)
 	mulu.l	#8,D0
 	move.l	LINE_SIZE,D1
 	mulu.l	D4,D1
 	mulu.l	#2,D1
 	add.l	D0,D1
 	movea.l	A4,A6
 	adda.l	D1,A6
 	
 	move.l	(A5),(A6)		; =
 	
 	dbf	D3,ECARTX
 	dbf	D4,ECARTY
 	
 	mulu.w	#2,D7		; n%=n%*2
 	move.w	D7,NB
 
	move.l	#1,D4
	move.l	#1,D3
CALCY	lea	TAB_ADR,A4
CALCX	move.l	D3,D0		; h%(i%-1,j%)
	subq.l	#1,D0
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	mulu.l	D4,D1
	add.l	D0,D1
	move.l	A4,A6
	adda.l	D1,A6
	
	move.l	D3,D0		; h%(i%-1,j%-1)
	subq.l	#1,D0
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	move.l	D4,D2
	subq.l	#1,D2
	mulu.l	D2,D1
	add.l	D0,D1
	move.l	A4,A5
	adda.l	D1,A5
	move.l	(A5),D2
	fmove.s	D2,FP1
	
	move.l	D3,D0		; h%(i%-1,j%+1)
	subq.l	#1,D0
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	move.l	D4,D2
	addq.l	#1,D2
	mulu.l	D2,D1
	add.l	D0,D1
	move.l	A4,A5
	adda.l	D1,A5
	move.l	(A5),D2
	fmove.s	D2,FP2
	
	fadd.x	FP2,FP1
	fdiv.x	#2,FP1
	fmove.s	FP1,D2
	move.l	D2,(A6)
	
	move.l	D3,D0		; h%(i%-1,j%)
	subq.l	#1,D0
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	mulu.l	D4,D1
	add.l	D0,D1
	move.l	A4,A6
	adda.l	D1,A6
	move.l	(A6),D2
	fmove.s	D2,FP1
	
	bsr	RANDOM_NUM
	
	fmove.x	FP7,FP5
	fmul.x	FP6,FP5
	fmove.x	FP6,FP4
	fdiv.x	#2,FP4
	fsub.x	FP4,FP5
	fadd.x	FP5,FP1
	fmove.s	FP1,D2
	move.l	D2,(A6)

	move.l	D3,D0		; h%(i%1,j%-1)
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	move.l	D4,D2
	subq.l	#1,D2
	mulu.l	D2,D1
	add.l	D0,D1
	move.l	A4,A6
	adda.l	D1,A6
	
	move.l	D3,D0		; h%(i%-1,j%-1)
	subq.l	#1,D0
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	move.l	D4,D2
	subq.l	#1,D2
	mulu.l	D2,D1
	add.l	D0,D1
	move.l	A4,A5
	adda.l	D1,A5
	move.l	(A5),D2
	fmove.s	D2,FP1
	
	move.l	D3,D0		; h%(i%+1,j%-1)
	addq.l	#1,D0
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	move.l	D4,D2
	subq.l	#1,D2
	mulu.l	D2,D1
	add.l	D0,D1
	move.l	A4,A5
	adda.l	D1,A5
	move.l	(A5),D2
	fmove.s	D2,FP2
	
	fadd.x	FP2,FP1
	fdiv.x	#2,FP1
	fmove.s	FP1,D2
	move.l	D2,(A6)

	move.l	D3,D0		; h%(i%,j%-1)
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	move.l	D4,D2
	subq.l	#1,D2
	mulu.l	D2,D1
	add.l	D0,D1
	move.l	A4,A6
	adda.l	D1,A6
	move.l	(A6),D2
	fmove.s	D2,FP1
	
	bsr	RANDOM_NUM
	
	fmove.x	FP7,FP5
	fmul.x	FP6,FP5
	fmove.x	FP6,FP4
	fdiv.x	#2,FP4
	fsub.x	FP4,FP5
	fadd.x	FP5,FP1
	fmove.s	FP1,D2
	move.l	D2,(A6)
	
	move.l	D3,D0		; h%(i%,j%)
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	mulu.l	D4,D1
	add.l	D0,D1
	movea.l	A4,A6
 	adda.l	D1,A6

	move.l	D3,D0		; h%(i%-1,j%-1)
	subq.l	#1,D0
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	move.l	D4,D2
	subq.l	#1,D2
	mulu.l	D2,D1
	add.l	D0,D1
	move.l	A4,A5
	adda.l	D1,A5
	move.l	(A5),D2
	fmove.s	D2,FP1
	
	move.l	D3,D0		; h%(i%-1,j%+1)
	subq.l	#1,D0
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	move.l	D4,D2
	addq.l	#1,D2
	mulu.l	D2,D1
	add.l	D0,D1
	move.l	A4,A5
	adda.l	D1,A5
	move.l	(A5),D2
	fmove.s	D2,FP2

	fadd.x	FP2,FP1
	fmove.s	FP1,D2
	move.l	D2,(A6)
	
	move.l	D3,D0		; h%(i%,j%)
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	mulu.l	D4,D1
	add.l	D0,D1
	movea.l	A4,A6
 	adda.l	D1,A6
	move.l	(A6),D2
	fmove.s	D2,FP1

	move.l	D3,D0		; h%(i%+1,j%-1)
	addq.l	#1,D0
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	move.l	D4,D2
	subq.l	#1,D2
	mulu.l	D2,D1
	add.l	D0,D1
	move.l	A4,A5
	adda.l	D1,A5
	move.l	(A5),D2
	fmove.s	D2,FP2
	
	move.l	D3,D0		; h%(i%+1,j%+1)
	addq.l	#1,D0
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	move.l	D4,D2
	addq.l	#1,D2
	mulu.l	D2,D1
	add.l	D0,D1
	move.l	A4,A5
	adda.l	D1,A5
	move.l	(A5),D2
	fmove.s	D2,FP3
	
	fadd.x	FP3,FP2
	fadd.x	FP2,FP1
	fmove.s	FP1,D2
	move.l	D2,(A6)
	
	move.l	D3,D0		; h%(i%,j%)
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	mulu.l	D4,D1
	add.l	D0,D1
	movea.l	A4,A6
 	adda.l	D1,A6
	move.l	(A6),D2
	fmove.s	D2,FP1
	
	bsr	RANDOM_NUM
	
	fdiv.x	#4,FP1
	fmove.x	FP7,FP5
	fmul.x	FP6,FP5
	fmove.x	FP6,FP4
	fdiv.x	#2,FP4
	fsub.x	FP4,FP5
	fadd.x	FP5,FP1
	fmove.s	FP1,D2
	move.l	D2,(A6)
		
	addq.l	#2,D3
	move.l	D7,D2
	addq.l	#1,D2
	cmp.l	D2,D3
	bne	CALCX
	addq.l	#2,D4
	move.l	D7,D2
	addq.l	#1,D2
	cmp.l	D2,D4
	bne	CALCY

	move.l	#1,D4
RESTORE_ALT	move.l	D7,D0		; h%(n%,i%)
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	mulu.l	D4,D1
	add.l	D0,D1
	move.l	A4,A6
	adda.l	D1,A6
	
	move.l	D7,D0		; h%(n%,i%-1)
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	move.l	D4,D2
	subq.l	#1,D2
	mulu.l	D2,D1
	add.l	D0,D1
	move.l	A4,A5
	adda.l	D1,A5
	move.l	(A5),D2
	fmove.s	D2,FP1
	
	move.l	D7,D0		; h%(n%,i%+1)
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	move.l	D4,D2
	addq.l	#1,D2
	mulu.l	D2,D1
	add.l	D0,D1
	move.l	A4,A5
	adda.l	D1,A5
	move.l	(A5),D2
	fmove.s	D2,FP2
	
	bsr	RANDOM_NUM
	
	fadd.x	FP2,FP1
	fdiv.x	#2,FP1
	fmove.x	FP7,FP5
	fmul.x	FP6,FP5
	fmove.x	FP6,FP4
	fdiv.x	#2,FP4
	fsub.x	FP4,FP5
	fadd.x	FP5,FP1
	fmove.s	FP1,D2
	move.l	D2,(A6)
	
	move.l	D4,D0		; h%(i%,n%)
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	mulu.l	D7,D1
	add.l	D0,D1
	move.l	A4,A6
	adda.l	D1,A6
	
	move.l	D4,D0		; h%(i%-1,n%)
	subq.l	#1,D0
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	mulu.l	D7,D1
	add.l	D0,D1
	move.l	A4,A5
	adda.l	D1,A5
	move.l	(A5),D2
	fmove.s	D2,FP1
	
	move.l	D4,D0		; h%(i%+1,n%)
	addq.l	#1,D0
	mulu.l	#4,D0
	move.l	LINE_SIZE,D1
	mulu.l	D7,D1
	add.l	D0,D1
	move.l	A4,A5
	adda.l	D1,A5
	move.l	(A5),D2
	fmove.s	D2,FP2
	
	bsr	RANDOM_NUM
	
	fadd.x	FP2,FP1
	fdiv.x	#2,FP1
	fmove.x	FP7,FP5
	fmul.x	FP6,FP5
	fmove.x	FP6,FP4
	fdiv.x	#2,FP4
	fsub.x	FP4,FP5
	fadd.x	FP5,FP1
	fmove.s	FP1,D2
	move.l	D2,(A6)
	
	addq.l	#2,D4
	move.l	D7,D2
	addq.l	#1,D2
	cmp.l	D2,D3
	bne	RESTORE_ALT
	
	fdiv.x	#2,FP6		; amp%=amp%/2
	fmove.w	FP6,D2
	move.w	D2,AMP
	
	addq.l	#1,D5
	move.l	D6,D2
	addq.l	#1,D2
	cmp.l	D2,D5
	bne	CALC_SESSION

	RTS

; /// NOMBRE ALEATOIRE 0=<X<1 ///

RANDOM_NUM	movem.l	D0-7/A0-6,-(SP)
	clr.l	D0
	move.w	#$11,-(SP)		; - RANDOM -    \-> Obtient un nombre al�atoire
	trap	#14		; *** XBIOS *** /
	addq.w	#2,SP
	fmove.l	D0,FP7
	movem.l	(SP)+,D0-7/A0-6
	fdiv.x	#16777215,FP7		; Format BASIC	
	RTS

; /// SORTIE DU PROGRAMME ///

SYS_ERROR	move.l	OLD_STACK,SP		; Restaure l'ancienne PILE
EXIT_PROG	move.w	D0,-(SP)		; EmPILE le code de l'erreur \
	move.w	#$4C,-(SP)		; - P_TERM -                 |-> Quitte proprement
	trap	#1		; *** GEMDOS ***             /

; /// VARIABLES ///

OLD_STACK	ds.l	1		; Ancienne PILE
NSD_NAME	ds.b	256		; Un peu de place pour la COMMAND-TAIL
TAB_ADR	ds.l	1
LINE_SIZE	ds.l	1
OLD_MODE	ds.w	1
OLD_PAL	ds.l	256
ITER	ds.b	1
AMP	ds.w	1
NB	ds.w	1
