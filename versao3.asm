
.text
	.globl Inicio
	
	Inicio: #display em 4,2,512,512		
		
		li $s2,0x223399 ## Cor de fundo
		jal Apagar_tela		
		
		li $s3,3 #quantidade de vidas
		li $s4,25 #Velocidade do jogo
		
		li $k0,100100
		li $v1,1
		jal Pintar_boneca
		

			
		li $t0,0
		li $t1,1000
		
		
		loop_inicio:
		slt $t2,$t0,$t1
		beq $t2,$zero,fim_loop_inicio
		
		move $a0,$s4
		li $v0,32
		syscall
		
		li $t3,100
		div $t0,$t3
		li $t3,1
		mfhi $t4
		bne $t3,$t4,cont1_inicio
		
		addi $sp,$sp,-8
		sw $t0,0($sp)
		sw $t1,4($sp)
		jal Adicionar_fruta_aleatoria
		lw $t0,0($sp)
		lw $t1,4($sp)
		addi $sp,$sp,8
			
		cont1_inicio:		
		addi $sp,$sp,-8
		sw $t0,0($sp)
		sw $t1,4($sp)
		
		jal Controle_teclado
		li $v1,1
		jal Pintar_boneca
		jal Confronto_cesta
		jal Apagar_figuras
		jal Mover_figuras
		jal Pintar_tela
		jal Confronto_chao
		
		lw $t0,0($sp)
		lw $t1,4($sp)
		addi $sp,$sp,8
		
		addi $t0,$t0,1
		j loop_inicio
		
		fim_loop_inicio:
		li $t0,0
		j loop_inicio	
		
		
		addi $v0,$zero,10 
		syscall	
	Fim:
	######### Funcoes utilizadas ###########
	Inicializar_vetorestado:
		li $t0,0
		li $t1,11
		li $t2,0
		la $t3,vetor_estado
		
		loop_ini_vetestado:
		slt $t4,$t0,$t1
		beq $t4,$zero,fim_ini_vetestado		
		sw $t2,0,($t3)
		addi $t3,$t3,4
		addi $t0,$t0,1
		j loop_ini_vetestado
		
		fim_ini_vetestado:
		jr $ra
	#######################################
	######## Funcao Perdeu !!! ###########
	Perdeu:
		subi $s3,$s3,1
		bne $s3,$zero,fim_perdeu
		
		addi $v0,$zero,10 
		syscall
		
		fim_perdeu:
		jr $ra
	######################################	
	Controle_teclado:
		addi $sp,$sp,-4	
		sw $ra,0($sp)
		
		la $t0,0xffff0004		
		lw $t2,0($t0)
		li $t0,97
		
		
		
		bne $t0,$t2,cont1_controle
		li $v1,0
		jal Pintar_boneca		
		addi $k0,$k0,-8
		
		
		li $t0,0xffff0004
		li $t1,0
		sw $t1,0($t0)	
						
		cont1_controle:
		li $t0,100
		bne $t0,$t2,cont2_controle
		li $v1,0
		jal Pintar_boneca		
		addi $k0,$k0,8
		
		li $t0,0xffff0004
		li $t1,0
		sw $t1,0($t0)
		
		cont2_controle:
		
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
		
	Confronto_cesta:
		li $t0,0
		li $t1,10		
		la $t2,vetor_estado
		la $t3,vetor_pos
		li $t5,116736
		
		
		loop_confcesta:
		slt $t4,$t0,$t1
		beq $t4,$zero,fim_loop_confcesta
		lw $t4,0($t2)
		beq $t4,$zero,cont1_loop_confcesta
		lw $t4,0($t3)
		slt $t6,$t5,$t4
		beq $t6,$zero,cont1_loop_confcesta
		
		li $t6,512
		div $t4,$t6
		mfhi $t4		
		div $k0,$t6
		mfhi $t6
		
		slt $t7,$t4,$t6
		beq $t7,$zero,t4_maior
		sub $t4,$t6,$t4
		j cont_maior
		t4_maior:
		sub $t4,$t4,$t6
		cont_maior:
		
		li $t6,60
		slt $t6,$t4,$t6
		beq $t6,$zero,cont1_loop_confcesta		
		
		lw $t4,0($t2)
		li $t6,4
		bne $t4,$t6,cont2_loop_confcesta
		jal Perdeu
		cont2_loop_confcesta:
		li $t4,0
		sw $t4,0($t2)
		subi $s4,$s4,2
		
		cont1_loop_confcesta:
		addi $t0,$t0,1
		addi $t2,$t2,4
		addi $t3,$t3,4
		j loop_confcesta
		fim_loop_confcesta:
		
		jr $ra
		
	Confronto_chao:
		addi $sp,$sp,-4
		sw $ra,0($sp)
		
		li $t0,0
		li $t1,10
		la $t2,vetor_estado
		la $t3,vetor_pos
		
	
		loop_confronto:
		slt $t4,$t0,$t1
		beq $t4,$zero,fim_loop_confronto
		lw $t4,0($t2)
		lw $t5,0($t3)
		
		li $t6,1
		bne $t4,$t6,cont1_loop_confronto		
		li $t6,130560
		slt $t6,$t5,$t6
		bne $t6,$zero,cont1_loop_confronto		
		li $t6,0
		sw $t6,0($t2)
		move $v0,$t5
		jal Apagar_maca
		jal Perdeu	
		
		cont1_loop_confronto:
		li $t6,2
		bne $t4,$t6,cont2_loop_confronto		
		li $t6,130560
		slt $t6,$t5,$t6
		bne $t6,$zero,cont2_loop_confronto		
		li $t6,0
		sw $t6,0($t2)
		move $v0,$t5
		jal Apagar_banana
		jal Perdeu
		
		cont2_loop_confronto:
		li $t6,3
		bne $t4,$t6,cont3_loop_confronto		
		li $t6,130560
		slt $t6,$t5,$t6
		bne $t6,$zero,cont3_loop_confronto		
		li $t6,0
		sw $t6,0($t2)
		move $v0,$t5
		jal Apagar_cereja
		jal Perdeu
		
		cont3_loop_confronto:
		li $t6,4
		bne $t4,$t6,cont4_loop_confronto		
		li $t6,130560
		slt $t6,$t5,$t6
		bne $t6,$zero,cont4_loop_confronto		
		li $t6,0
		sw $t6,0($t2)
		move $v0,$t5
		jal Apagar_bomba
		
		cont4_loop_confronto:
		li $t6,5
		bne $t4,$t6,cont5_loop_confronto		
		li $t6,130560
		slt $t6,$t5,$t6
		bne $t6,$zero,cont5_loop_confronto		
		li $t6,0
		sw $t6,0($t2)
		move $v0,$t5
		jal Apagar_moeda
		jal Perdeu
		
		cont5_loop_confronto:																
		addi $t0,$t0,1
		addi $t2,$t2,4
		addi $t3,$t3,4
		j loop_confronto
		fim_loop_confronto:
		
		
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
	########################################
	Adicionar_fruta_aleatoria:
		addi $sp,$sp,-4
		sw $ra,0($sp)
		
		li $a1,116
		li $v0,42
		syscall
		addi $a0,$a0,4
		mul $a0,$a0,4
		move $t0,$a0
		
		li $a1,5
		li $v0,42
		syscall
		addi $a0,$a0,1	
			
		move $v1,$a0
		move $v0,$t0		
		jal Adicionar_frutas
		
		
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
	########################################
	Mover_figuras:
		li $t0,0
		li $t1,10
		la $t2,vetor_estado
		la $t3,vetor_pos
		
		loop_movfiguras:
		slt $t4,$t0,$t1
		beq $t4,$zero,fim_loop_movfiguras
		lw $t4,0($t2)
		beq $t4,$zero,cont1_loop_movfiguras
		lw $t4,0($t3)
		addi $t4,$t4,512
		sw $t4,0($t3)		
		cont1_loop_movfiguras:
		addi $t0,$t0,1
		addi $t2,$t2,4
		addi $t3,$t3,4
		j loop_movfiguras
		fim_loop_movfiguras:
		
		jr $ra
		
	Adicionar_frutas: # Adiciona Maca no pixel em $v0
		li $t0,0
		li $t1,11		
		la $t2,vetor_estado
		la $t6,vetor_pos
		
		loop_addfruta:
		slt $t3,$t0,$t1
		beq $t3,$zero,fim_loop_addfruta
		lw $t4,0($t2)
		li $t3,0
		beq $t4,$t3,add_fruta
		addi $t6,$t6,4
		addi $t2,$t2,4
		addi $t0,$t0,1
		j loop_addfruta
		
		add_fruta:
		sw $v1,0($t2)
		sw $v0,0($t6)
		
		fim_loop_addfruta:
		jr $ra
	#####################################
	Apagar_figuras:
		addi $sp,$sp,-4
		sw $ra,0($sp)
		
		li $t0,0
		li $t1,10
		la $t2,vetor_estado
		la $t3,vetor_pos
		
		loop_apagfrutas:
		slt $t4,$t0,$t1
		beq $t4,$zero,fim_loop_apagfrutas
		lw $t4,0($t2)
		
		li $t5,1
		bne $t4,$t5,cont1_loop_apagfrutas
		lw $v0,0($t3)
		jal Apagar_maca
		
		cont1_loop_apagfrutas:
		li $t5,2
		bne $t4,$t5,cont2_loop_apagfrutas
		lw $v0,0($t3)
		jal Apagar_banana
		
		
		cont2_loop_apagfrutas:
		li $t5,3
		bne $t4,$t5,cont3_loop_apagfrutas
		lw $v0,0($t3)
		jal Apagar_cereja
		
		cont3_loop_apagfrutas:
		li $t5,4
		bne $t4,$t5,cont4_loop_apagfrutas
		lw $v0,0($t3)
		jal Apagar_bomba
		
		cont4_loop_apagfrutas:
		li $t5,5
		bne $t4,$t5,cont5_loop_apagfrutas
		lw $v0,0($t3)
		jal Apagar_moeda
		
		cont5_loop_apagfrutas:
		
		addi $t0,$t0,1
		addi $t2,$t2,4
		addi $t3,$t3,4
		j loop_apagfrutas	
		fim_loop_apagfrutas:
		
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr  $ra
        #########################################
	Apagar_tela:
		
		move $t1,$gp
		addi $t2,$t1,131072
		
		loop_apagatela:
		slt $t3,$t1,$t2
		beq $t3,$zero,desvia_loop_apagatela
		sw $s2,0($t1)
		addi $t1,$t1,4
		j loop_apagatela
		desvia_loop_apagatela:		
		
		jr $ra
	#######################################	
	Pintar_tela:		
		add $sp,$sp,-4
		sw $ra,0($sp)		
	
		li $t0,0
		li $t1,10		
		la $t2,vetor_estado
		la $t6,vetor_pos	
		
		loop_pintatela:			
		slt $t3,$t0,$t1
		beq $t3,$zero,fim_pintatela				
		lw $t4,0($t2)	
			
		li $t5,1
		bne $t4,$t5,continue1_loop_pintatela			
		lw $t5,0($t6)		
		move $v0,$t5				
		jal Pintar_maca
				
		continue1_loop_pintatela:
		li $t5,2
		bne $t4,$t5,continue2_loop_pintatela			
		lw $t5,0($t6)		
		move $v0,$t5				
		jal Pintar_banana
		
		continue2_loop_pintatela:
		li $t5,3
		bne $t4,$t5,continue3_loop_pintatela			
		lw $t5,0($t6)		
		move $v0,$t5				
		jal Pintar_cereja
		
		
		continue3_loop_pintatela:
		li $t5,4
		bne $t4,$t5,continue4_loop_pintatela			
		lw $t5,0($t6)		
		move $v0,$t5				
		jal Pintar_bomba
		
		continue4_loop_pintatela:
		li $t5,5
		bne $t4,$t5,continue5_loop_pintatela			
		lw $t5,0($t6)		
		move $v0,$t5				
		jal Pintar_moeda
		
		continue5_loop_pintatela:
								
		addi $t6,$t6,4
		addi $t2,$t2,4
		addi $t0,$t0,1
		j loop_pintatela
		
		fim_pintatela:
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr $ra
	
	################ Funcoes de pintar objetos ####################
	###### Pintar Maca ############
	Pintar_maca:
	#maça
	addi $sp,$sp,-32
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $t4,16($sp)
	sw $t5,20($sp)
	sw $t6,24($sp)
	sw $t7,28($sp)
	
	li $t0,0xff0000 #vermelho  
	li $t1,0xB8860B #marrom  
	li $t2,0x008000 #verde  
	li $t3,0x006400 #verde escuro  
	li $t4,0x90EE90 #verde claro 
	li $t5,0xFFFAFA #gelo 
	li $t6,0xffff00	#amarelo
	li $t7,0x000000 #preto	
	li $t8,0x595959 #cinza	
	li $t9,0xffaa00 #laranja
	li $s1,0x86592d #marrom escuro
				
	add $s0,$gp,$v0 #Atribui ao registrador $s0 o endereco do pixel central da maca
		
        sw $t0,-4616($s0)
        sw $t0,-4612($s0)
        sw $t0,-4608($s0)
        sw $t0,-4604($s0)
        sw $t0,-4600($s0)
        sw $t0,-4104($s0)
        sw $t0,-4100($s0)
        sw $t0,-4096($s0)
        sw $t0,-4092($s0)
        sw $t0,-4088($s0)
        sw $t0,-3592($s0)
        sw $t0,-3588($s0)
        sw $t0,-3584($s0)
        sw $t0,-3580($s0)
        sw $t0,-3576($s0)
        sw $t0,-3080($s0)
        sw $t0,-3076($s0)
        sw $t0,-3072($s0)
        sw $t0,-3068($s0)
        sw $t0,-3064($s0)
        sw $t0,-2568($s0)
        sw $t0,-2564($s0)
        sw $t0,-2560($s0)
        sw $t0,-2556($s0)
        sw $t0,-2552($s0)
        sw $t0,-2056($s0)
        sw $t0,-2052($s0)
        sw $t0,-2048($s0)
        sw $t0,-2044($s0)
        sw $t0,-2040($s0)
        sw $t0,-1544($s0)
        sw $t0,-1540($s0)
        sw $t0,-1536($s0)
        sw $t0,-1532($s0)
        sw $t0,-1528($s0)
        sw $t0,-1032($s0)
        sw $t0,-1028($s0)
        sw $t0,-1024($s0)
        sw $t0,-1020($s0)
        sw $t0,-1016($s0)
        sw $t0,-520($s0)
        sw $t0,-516($s0)
        sw $t0,-512($s0)
        sw $t0,-508($s0)
        sw $t0,-504($s0)
        sw $t0,-8($s0)
        sw $t0,-4($s0)
        sw $t0,0($s0)
        sw $t0,4($s0)
        sw $t0,8($s0)
        sw $t0,-4596($s0)
        sw $t0,-4084($s0)
        sw $t0,-3572($s0)
        sw $t0,-3060($s0)
        sw $t0,-2548($s0)
        sw $t0,-2036($s0)
        sw $t0,-1524($s0)
        sw $t0,-1012($s0)
        sw $t0,-500($s0)
        sw $t0,-4080($s0)
        sw $t0,-3568($s0)
        sw $t0,-3056($s0)
        sw $t0,-2544($s0)
        sw $t0,-2032($s0)
        sw $t0,-1520($s0)
        sw $t0,-1008($s0)
        sw $t0,-496($s0)
        sw $t0,-3564($s0)
        sw $t0,-3052($s0)
        sw $t0,-2540($s0)
        sw $t0,-2028($s0)
        sw $t0,-1516($s0)
        sw $t0,-1004($s0)
        sw $t0,-3048($s0)
        sw $t0,-2536($s0)
        sw $t0,-2024($s0)
        sw $t0,-1512($s0)
        sw $t0,-4620($s0)
        sw $t0,-4108($s0)
        sw $t0,-3596($s0)
        sw $t0,-2572($s0)
        sw $t0,-2060($s0)
        sw $t0,-1548($s0)
        sw $t0,-1036($s0)
        sw $t0,-524($s0)
        sw $t0,-12($s0)
        sw $t0,-2588($s0)
        sw $t0,-2584($s0)
        sw $t0,-2580($s0)
        sw $t0,-2576($s0)
        sw $t0,-2076($s0)
        sw $t0,-2072($s0)
        sw $t0,-2068($s0)
        sw $t0,-2064($s0)
        sw $t0,-1564($s0)
        sw $t0,-1560($s0)
        sw $t0,-1556($s0)
        sw $t0,-1552($s0)
        sw $t0,-1048($s0)
        sw $t0,-1044($s0)
        sw $t0,-1040($s0)
        sw $t0,-532($s0)
        sw $t0,-528($s0)
        sw $t0,-3100($s0)
        sw $t0,-3096($s0)
        sw $t0,-3092($s0)
        sw $t0,-3608($s0)
        sw $t0,-3604($s0)
        sw $t0,-4116($s0)
        sw $t0,-4112($s0)

        sw $t1,-6148($s0)
        sw $t1,-5636($s0)
        sw $t1,-5124($s0)

        sw $t2,-6144($s0)
        sw $t2,-6140($s0)
        sw $t2,-6136($s0)

        sw $t3,-5624($s0)

        sw $t4,-6652($s0)

        sw $t5,-3600($s0)
        sw $t5,-3088($s0)
        sw $t5,-3084($s0)

        
        
	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $t4,16($sp)
	lw $t5,20($sp)
	lw $t6,24($sp)
	lw $t7,28($sp)
	addi $sp,$sp,32
	jr $ra
	
	###### Apagar Maca ############
	Apagar_maca:
	#maça
	addi $sp,$sp,-32
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $t4,16($sp)
	sw $t5,20($sp)
	sw $t6,24($sp)
	sw $t7,28($sp)
	
	move $t0,$s2
	move $t1,$s2
	move $t2,$s2
	move $t3,$s2
	move $t4,$s2
	move $t5,$s2
	move $t6,$s2
	move $t7,$s2
	move $t8,$s2
	move $t9,$s2
	move $s1,$s2
				
	add $s0,$gp,$v0 #Atribui ao registrador $s0 o endereco do pixel central da maca
		
        sw $t0,-4616($s0)
        sw $t0,-4612($s0)
        sw $t0,-4608($s0)
        sw $t0,-4604($s0)
        sw $t0,-4600($s0)
        sw $t0,-4104($s0)
        sw $t0,-4100($s0)
        sw $t0,-4096($s0)
        sw $t0,-4092($s0)
        sw $t0,-4088($s0)
        sw $t0,-3592($s0)
        sw $t0,-3588($s0)
        sw $t0,-3584($s0)
        sw $t0,-3580($s0)
        sw $t0,-3576($s0)
        sw $t0,-3080($s0)
        sw $t0,-3076($s0)
        sw $t0,-3072($s0)
        sw $t0,-3068($s0)
        sw $t0,-3064($s0)
        sw $t0,-2568($s0)
        sw $t0,-2564($s0)
        sw $t0,-2560($s0)
        sw $t0,-2556($s0)
        sw $t0,-2552($s0)
        sw $t0,-2056($s0)
        sw $t0,-2052($s0)
        sw $t0,-2048($s0)
        sw $t0,-2044($s0)
        sw $t0,-2040($s0)
        sw $t0,-1544($s0)
        sw $t0,-1540($s0)
        sw $t0,-1536($s0)
        sw $t0,-1532($s0)
        sw $t0,-1528($s0)
        sw $t0,-1032($s0)
        sw $t0,-1028($s0)
        sw $t0,-1024($s0)
        sw $t0,-1020($s0)
        sw $t0,-1016($s0)
        sw $t0,-520($s0)
        sw $t0,-516($s0)
        sw $t0,-512($s0)
        sw $t0,-508($s0)
        sw $t0,-504($s0)
        sw $t0,-8($s0)
        sw $t0,-4($s0)
        sw $t0,0($s0)
        sw $t0,4($s0)
        sw $t0,8($s0)
        sw $t0,-4596($s0)
        sw $t0,-4084($s0)
        sw $t0,-3572($s0)
        sw $t0,-3060($s0)
        sw $t0,-2548($s0)
        sw $t0,-2036($s0)
        sw $t0,-1524($s0)
        sw $t0,-1012($s0)
        sw $t0,-500($s0)
        sw $t0,-4080($s0)
        sw $t0,-3568($s0)
        sw $t0,-3056($s0)
        sw $t0,-2544($s0)
        sw $t0,-2032($s0)
        sw $t0,-1520($s0)
        sw $t0,-1008($s0)
        sw $t0,-496($s0)
        sw $t0,-3564($s0)
        sw $t0,-3052($s0)
        sw $t0,-2540($s0)
        sw $t0,-2028($s0)
        sw $t0,-1516($s0)
        sw $t0,-1004($s0)
        sw $t0,-3048($s0)
        sw $t0,-2536($s0)
        sw $t0,-2024($s0)
        sw $t0,-1512($s0)
        sw $t0,-4620($s0)
        sw $t0,-4108($s0)
        sw $t0,-3596($s0)
        sw $t0,-2572($s0)
        sw $t0,-2060($s0)
        sw $t0,-1548($s0)
        sw $t0,-1036($s0)
        sw $t0,-524($s0)
        sw $t0,-12($s0)
        sw $t0,-2588($s0)
        sw $t0,-2584($s0)
        sw $t0,-2580($s0)
        sw $t0,-2576($s0)
        sw $t0,-2076($s0)
        sw $t0,-2072($s0)
        sw $t0,-2068($s0)
        sw $t0,-2064($s0)
        sw $t0,-1564($s0)
        sw $t0,-1560($s0)
        sw $t0,-1556($s0)
        sw $t0,-1552($s0)
        sw $t0,-1048($s0)
        sw $t0,-1044($s0)
        sw $t0,-1040($s0)
        sw $t0,-532($s0)
        sw $t0,-528($s0)
        sw $t0,-3100($s0)
        sw $t0,-3096($s0)
        sw $t0,-3092($s0)
        sw $t0,-3608($s0)
        sw $t0,-3604($s0)
        sw $t0,-4116($s0)
        sw $t0,-4112($s0)

        sw $t1,-6148($s0)
        sw $t1,-5636($s0)
        sw $t1,-5124($s0)

        sw $t2,-6144($s0)
        sw $t2,-6140($s0)
        sw $t2,-6136($s0)

        sw $t3,-5624($s0)

        sw $t4,-6652($s0)

        sw $t5,-3600($s0)
        sw $t5,-3088($s0)
        sw $t5,-3084($s0)

        
        
	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $t4,16($sp)
	lw $t5,20($sp)
	lw $t6,24($sp)
	lw $t7,28($sp)
	addi $sp,$sp,32        
        jr $ra
        ##############################################
        ####### Pintar Banana ##############
        Pintar_banana:
	addi $sp,$sp,-32
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $t4,16($sp)
	sw $t5,20($sp)
	sw $t6,24($sp)
	sw $t7,28($sp)
	
	li $t0,0xff0000 #vermelho  
	li $t1,0xB8860B #marrom  
	li $t2,0x008000 #verde  
	li $t3,0x006400 #verde escuro  
	li $t4,0x90EE90 #verde claro 
	li $t5,0xFFFAFA #gelo 
	li $t6,0xffff00	#amarelo
	li $t7,0x000000 #preto	
	li $t8,0x595959 #cinza	
	li $t9,0xffaa00 #laranja
	li $s1,0x86592d #marrom escuro
				
	add $s0,$gp,$v0 #Atribui ao registrador $s0 o endereco do pixel central da banana
        
        sw $t7,-5116($s0)
        sw $t7,-5112($s0)
        sw $t7,-4604($s0)
        sw $t7,-4600($s0)
        sw $t7,-4084($s0)
        sw $t7,-3572($s0)
        sw $t7,-3060($s0)
        sw $t7,-2548($s0)
        sw $t7,-2036($s0)
        sw $t7,-4096($s0)
        sw $t7,-3584($s0)
        sw $t7,-3072($s0)
        sw $t7,-2564($s0)
        sw $t7,-2048($s0)
        sw $t7,-1528($s0)
        sw $t7,-1020($s0)
        sw $t7,-512($s0)
        sw $t7,-2056($s0)
        sw $t7,-4($s0)
        sw $t7,-1556($s0)
        sw $t7,-1552($s0)
        sw $t7,-1548($s0)
        sw $t7,-1048($s0)
        sw $t7,-536($s0)
        sw $t7,-20($s0)
        sw $t7,496($s0)
        sw $t7,500($s0)
        sw $t7,504($s0)

        sw $t6,-4092($s0)
        sw $t6,-4088($s0)
        sw $t6,-3580($s0)
        sw $t6,-3576($s0)
        sw $t6,-3068($s0)
        sw $t6,-3064($s0)
        sw $t6,-2556($s0)
        sw $t6,-2552($s0)
        sw $t6,-2044($s0)
        sw $t6,-2040($s0)
        sw $t6,-1044($s0)
        sw $t6,-1040($s0)
        sw $t6,-1036($s0)
        sw $t6,-1032($s0)
        sw $t6,-1028($s0)
        sw $t6,-532($s0)
        sw $t6,-528($s0)
        sw $t6,-524($s0)
        sw $t6,-1024($s0)
        sw $t6,-520($s0)
        sw $t6,-516($s0)
        sw $t6,-16($s0)
        sw $t6,-12($s0)
        sw $t5,-8($s0)
        sw $t6,-1544($s0)
        sw $t6,-1540($s0)
        sw $t6,-1536($s0)
        sw $t6,-1532($s0)
        sw $t6,-2052($s0)
        sw $t6,-516($s0)
        sw $t6,-2560($s0)

	
	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $t4,16($sp)
	lw $t5,20($sp)
	lw $t6,24($sp)
	lw $t7,28($sp)
	addi $sp,$sp,32
	jr $ra
	##########################################
	
	####### Apagar Banana ##############
        Apagar_banana:
	addi $sp,$sp,-32
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $t4,16($sp)
	sw $t5,20($sp)
	sw $t6,24($sp)
	sw $t7,28($sp)
	
	move $t0,$s2
	move $t1,$s2
	move $t2,$s2
	move $t3,$s2
	move $t4,$s2
	move $t5,$s2
	move $t6,$s2
	move $t7,$s2
	move $t8,$s2
	move $t9,$s2
	move $s1,$s2
				
	add $s0,$gp,$v0 #Atribui ao registrador $s0 o endereco do pixel central da banana
        
        sw $t7,-5116($s0)
        sw $t7,-5112($s0)
        sw $t7,-4604($s0)
        sw $t7,-4600($s0)
        sw $t7,-4084($s0)
        sw $t7,-3572($s0)
        sw $t7,-3060($s0)
        sw $t7,-2548($s0)
        sw $t7,-2036($s0)
        sw $t7,-4096($s0)
        sw $t7,-3584($s0)
        sw $t7,-3072($s0)
        sw $t7,-2564($s0)
        sw $t7,-2048($s0)
        sw $t7,-1528($s0)
        sw $t7,-1020($s0)
        sw $t7,-512($s0)
        sw $t7,-2056($s0)
        sw $t7,-4($s0)
        sw $t7,-1556($s0)
        sw $t7,-1552($s0)
        sw $t7,-1548($s0)
        sw $t7,-1048($s0)
        sw $t7,-536($s0)
        sw $t7,-20($s0)
        sw $t7,496($s0)
        sw $t7,500($s0)
        sw $t7,504($s0)

        sw $t6,-4092($s0)
        sw $t6,-4088($s0)
        sw $t6,-3580($s0)
        sw $t6,-3576($s0)
        sw $t6,-3068($s0)
        sw $t6,-3064($s0)
        sw $t6,-2556($s0)
        sw $t6,-2552($s0)
        sw $t6,-2044($s0)
        sw $t6,-2040($s0)
        sw $t6,-1044($s0)
        sw $t6,-1040($s0)
        sw $t6,-1036($s0)
        sw $t6,-1032($s0)
        sw $t6,-1028($s0)
        sw $t6,-532($s0)
        sw $t6,-528($s0)
        sw $t6,-524($s0)
        sw $t6,-1024($s0)
        sw $t6,-520($s0)
        sw $t6,-516($s0)
        sw $t6,-16($s0)
        sw $t6,-12($s0)
        sw $t5,-8($s0)
        sw $t6,-1544($s0)
        sw $t6,-1540($s0)
        sw $t6,-1536($s0)
        sw $t6,-1532($s0)
        sw $t6,-2052($s0)
        sw $t6,-516($s0)
        sw $t6,-2560($s0)

	
	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $t4,16($sp)
	lw $t5,20($sp)
	lw $t6,24($sp)
	lw $t7,28($sp)
	addi $sp,$sp,32
	jr $ra
	##############################################
        #### Pintar Cereja #########
        Pintar_cereja:     
	addi $sp,$sp,-32
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $t4,16($sp)
	sw $t5,20($sp)
	sw $t6,24($sp)
	sw $t7,28($sp)
	
	li $t0,0xff0000 #vermelho  
	li $t1,0xB8860B #marrom  
	li $t2,0x008000 #verde  
	li $t3,0x006400 #verde escuro  
	li $t4,0x90EE90 #verde claro 
	li $t5,0xFFFAFA #gelo 
	li $t6,0xffff00	#amarelo
	li $t7,0x000000 #preto	
	li $t8,0x595959 #cinza	
	li $t9,0xffaa00 #laranja
	li $s1,0x86592d #marrom escuro
				
	add $s0,$gp,$v0 #Atribui ao registrador $s0 o endereco do pixel central da cereja
	
	sw $t0,-2576($s0)
        sw $t0,-2572($s0)
        sw $t0,-2064($s0)
        sw $t0,-2060($s0)
        sw $t0,-1552($s0)
        sw $t0,-1548($s0)
        sw $t0,-1040($s0)
        sw $t0,-1036($s0)
        sw $t0,-528($s0)
        sw $t0,-524($s0)
        sw $t0,-16($s0)
        sw $t0,-12($s0)
        sw $t0,-2056($s0)
        sw $t0,-1544($s0)
        sw $t0,-1032($s0)
        sw $t0,-520($s0)
        sw $t0,-1540($s0)
        sw $t0,-1028($s0)
        sw $t0,-2068($s0)
        sw $t0,-1556($s0)
        sw $t0,-1044($s0)
        sw $t0,-532($s0)
        sw $t0,-1560($s0)
        sw $t0,-1048($s0)
        sw $t0,-1528($s0)
        sw $t0,-1016($s0)
        sw $t0,-2036($s0)
        sw $t0,-1524($s0)
        sw $t0,-1012($s0)
        sw $t0,-500($s0)
        sw $t0,-2544($s0)
        sw $t0,-2540($s0)
        sw $t0,-2032($s0)
        sw $t0,-2028($s0)
        sw $t0,-1520($s0)
        sw $t0,-1516($s0)
        sw $t0,-1008($s0)
        sw $t0,-1004($s0)
        sw $t0,-496($s0)
        sw $t0,-492($s0)
        sw $t0,16($s0)
        sw $t0,20($s0)
        sw $t0,-2024($s0)
        sw $t0,-1512($s0)
        sw $t0,-1000($s0)
        sw $t0,-488($s0)
        sw $t0,-1508($s0)
        sw $t0,-996($s0)


        sw $t1,-5120($s0)
        sw $t1,-5116($s0)
        sw $t1,-4612($s0)
        sw $t1,-4600($s0)
        sw $t1,-4104($s0)
        sw $t1,-4084($s0)
        sw $t1,-3596($s0)
        sw $t1,-3568($s0)
        sw $t1,-3088($s0)
        sw $t1,-3052($s0)

	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $t4,16($sp)
	lw $t5,20($sp)
	lw $t6,24($sp)
	lw $t7,28($sp)
	addi $sp,$sp,32
	jr $ra
	################################################
	#### Apagar Cereja #########
        Apagar_cereja:     
	addi $sp,$sp,-32
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $t4,16($sp)
	sw $t5,20($sp)
	sw $t6,24($sp)
	sw $t7,28($sp)
	
	move $t0,$s2
	move $t1,$s2
	move $t2,$s2
	move $t3,$s2
	move $t4,$s2
	move $t5,$s2
	move $t6,$s2
	move $t7,$s2
	move $t8,$s2
	move $t9,$s2
	move $s1,$s2
				
	add $s0,$gp,$v0 #Atribui ao registrador $s0 o endereco do pixel central da cereja
	
	sw $t0,-2576($s0)
        sw $t0,-2572($s0)
        sw $t0,-2064($s0)
        sw $t0,-2060($s0)
        sw $t0,-1552($s0)
        sw $t0,-1548($s0)
        sw $t0,-1040($s0)
        sw $t0,-1036($s0)
        sw $t0,-528($s0)
        sw $t0,-524($s0)
        sw $t0,-16($s0)
        sw $t0,-12($s0)
        sw $t0,-2056($s0)
        sw $t0,-1544($s0)
        sw $t0,-1032($s0)
        sw $t0,-520($s0)
        sw $t0,-1540($s0)
        sw $t0,-1028($s0)
        sw $t0,-2068($s0)
        sw $t0,-1556($s0)
        sw $t0,-1044($s0)
        sw $t0,-532($s0)
        sw $t0,-1560($s0)
        sw $t0,-1048($s0)
        sw $t0,-1528($s0)
        sw $t0,-1016($s0)
        sw $t0,-2036($s0)
        sw $t0,-1524($s0)
        sw $t0,-1012($s0)
        sw $t0,-500($s0)
        sw $t0,-2544($s0)
        sw $t0,-2540($s0)
        sw $t0,-2032($s0)
        sw $t0,-2028($s0)
        sw $t0,-1520($s0)
        sw $t0,-1516($s0)
        sw $t0,-1008($s0)
        sw $t0,-1004($s0)
        sw $t0,-496($s0)
        sw $t0,-492($s0)
        sw $t0,16($s0)
        sw $t0,20($s0)
        sw $t0,-2024($s0)
        sw $t0,-1512($s0)
        sw $t0,-1000($s0)
        sw $t0,-488($s0)
        sw $t0,-1508($s0)
        sw $t0,-996($s0)


        sw $t1,-5120($s0)
        sw $t1,-5116($s0)
        sw $t1,-4612($s0)
        sw $t1,-4600($s0)
        sw $t1,-4104($s0)
        sw $t1,-4084($s0)
        sw $t1,-3596($s0)
        sw $t1,-3568($s0)
        sw $t1,-3088($s0)
        sw $t1,-3052($s0)

	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $t4,16($sp)
	lw $t5,20($sp)
	lw $t6,24($sp)
	lw $t7,28($sp)
	addi $sp,$sp,32
	jr $ra
	##################################
	#### Pintar Bomba #########
        Pintar_bomba:     
	addi $sp,$sp,-32
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $t4,16($sp)
	sw $t5,20($sp)
	sw $t6,24($sp)
	sw $t7,28($sp)
	
	li $t0,0xff0000 #vermelho  
	li $t1,0xB8860B #marrom  
	li $t2,0x008000 #verde  
	li $t3,0x006400 #verde escuro  
	li $t4,0x90EE90 #verde claro 
	li $t5,0xFFFAFA #gelo 
	li $t6,0xffff00	#amarelo
	li $t7,0x000000 #preto	
	li $t8,0x595959 #cinza	
	li $t9,0xffaa00 #laranja
	li $s1,0x86592d #marrom escuro
				
	add $s0,$gp,$v0 #Atribui ao registrador $s0 o endereco do pixel central da cereja
	
       sw $t7,-7180($s0)
       sw $t7,-7176($s0)
       sw $t7,-7172($s0)
       sw $t7,-7168($s0)
       sw $t7,-7164($s0)
       sw $t7,-7160($s0)
       sw $t7,-7156($s0)
       sw $t7,-6668($s0)
       sw $t7,-6664($s0)
       sw $t7,-6660($s0)
       sw $t7,-6656($s0)
       sw $t7,-6652($s0)
       sw $t7,-6648($s0)
       sw $t7,-6644($s0)
       sw $t7,-6156($s0)
       sw $t7,-6152($s0)
       sw $t7,-6148($s0)
       sw $t7,-6144($s0)
       sw $t7,-6140($s0)
       sw $t7,-6136($s0)
       sw $t7,-6132($s0)
       sw $t7,-5644($s0)
       sw $t7,-5640($s0)
       sw $t7,-5636($s0)
       sw $t7,-5632($s0)
       sw $t7,-5628($s0)
       sw $t7,-5624($s0)
       sw $t7,-5620($s0)
       sw $t7,-7680($s0)
       sw $t7,-7676($s0)
       sw $t7,-5128($s0)
       sw $t7,-5124($s0)
       sw $t7,-5120($s0)
       sw $t7,-5116($s0)
       sw $t7,-5112($s0)
       sw $t7,-5108($s0)
       sw $t7,-4612($s0)
       sw $t7,-4608($s0)
       sw $t7,-4604($s0)
       sw $t7,-4600($s0)
       sw $t7,-4096($s0)
       sw $t7,-4092($s0)
       sw $t7,-4592($s0)
       sw $t7,-4588($s0)
       sw $t7,-4584($s0)
       sw $t7,-4580($s0)
       sw $t7,-4576($s0)
       sw $t7,-4080($s0)
       sw $t7,-4076($s0)
       sw $t7,-4072($s0)
       sw $t7,-4068($s0)
       sw $t7,-4064($s0)
       sw $t7,-3568($s0)
       sw $t7,-3564($s0)
       sw $t7,-3560($s0)
       sw $t7,-3556($s0)
       sw $t7,-3552($s0)
       sw $t7,-3056($s0)
       sw $t7,-3052($s0)
       sw $t7,-3048($s0)
       sw $t7,-3044($s0)
       sw $t7,-3040($s0)
       sw $t7,-2544($s0)
       sw $t7,-2540($s0)
       sw $t7,-2536($s0)
       sw $t7,-2532($s0)
       sw $t7,-2528($s0)
       sw $t7,-2032($s0)
       sw $t7,-2028($s0)
       sw $t7,-2024($s0)
       sw $t7,-2020($s0)
       sw $t7,-2016($s0)
       sw $t7,-3576($s0)
       sw $t7,-3064($s0)
       sw $t7,-4084($s0)
       sw $t7,-3572($s0)
       sw $t7,-3060($s0)
       sw $t7,-2548($s0)
       sw $t7,-5100($s0)
       sw $t7,-5096($s0)
       sw $t7,-5092($s0)
       sw $t7,-5608($s0)
       sw $t7,-1516($s0)
       sw $t7,-1512($s0)
       sw $t7,-1508($s0)
       sw $t7,-1000($s0)
       sw $t7,-488($s0)
       sw $t7,-1036($s0)
       sw $t7,-1032($s0)
       sw $t7,-1028($s0)
       sw $t7,-1024($s0)
       sw $t7,-1020($s0)
       sw $t7,-1016($s0)
       sw $t7,-1012($s0)
       sw $t7,-524($s0)
       sw $t7,-520($s0)
       sw $t7,-516($s0)
       sw $t7,-512($s0)
       sw $t7,-508($s0)
       sw $t7,-504($s0)
       sw $t7,-500($s0)
       sw $t7,-12($s0)
       sw $t7,-8($s0)
       sw $t7,-4($s0)
       sw $t7,0($s0)
       sw $t7,4($s0)
       sw $t7,8($s0)
       sw $t7,12($s0)
       sw $t7,500($s0)
       sw $t7,504($s0)
       sw $t7,508($s0)
       sw $t7,512($s0)
       sw $t7,516($s0)
       sw $t7,520($s0)
       sw $t7,524($s0)
       sw $t7,-1008($s0)
       sw $t7,-496($s0)
       sw $t7,16($s0)
       sw $t7,-492($s0)
       sw $t7,20($s0)
       sw $t7,-1544($s0)
       sw $t7,-1540($s0)
       sw $t7,-1536($s0)
       sw $t7,-1532($s0)
       sw $t7,-1528($s0)
       sw $t7,-1524($s0)
       sw $t7,-2052($s0)
       sw $t7,-2048($s0)
       sw $t7,-2044($s0)
       sw $t7,-2040($s0)
       sw $t7,-2560($s0)
       sw $t7,-2556($s0)
       sw $t7,-528($s0)
       sw $t7,-16($s0)
       sw $t7,-1044($s0)
       sw $t7,-532($s0)
       sw $t7,-5148($s0)
       sw $t7,-5144($s0)
       sw $t7,-5140($s0)
       sw $t7,-5136($s0)
       sw $t7,-4636($s0)
       sw $t7,-4632($s0)
       sw $t7,-4628($s0)
       sw $t7,-4624($s0)
       sw $t7,-4124($s0)
       sw $t7,-4120($s0)
       sw $t7,-4116($s0)
       sw $t7,-4112($s0)
       sw $t7,-3612($s0)
       sw $t7,-3608($s0)
       sw $t7,-3604($s0)
       sw $t7,-3600($s0)
       sw $t7,-3100($s0)
       sw $t7,-3096($s0)
       sw $t7,-3092($s0)
       sw $t7,-3088($s0)
       sw $t7,-2588($s0)
       sw $t7,-2584($s0)
       sw $t7,-2580($s0)
       sw $t7,-2576($s0)
       sw $t7,-2076($s0)
       sw $t7,-2072($s0)
       sw $t7,-2068($s0)
       sw $t7,-2064($s0)
       sw $t7,-1560($s0)
       sw $t7,-1048($s0)
       sw $t7,-1556($s0)
       sw $t7,-1552($s0)
       sw $t7,-4620($s0)
       sw $t7,-4108($s0)
       sw $t7,-3596($s0)
       sw $t7,-3084($s0)
       sw $t7,-2572($s0)
       sw $t7,-2060($s0)
       sw $t7,-4104($s0)
       sw $t7,-3592($s0)
       sw $t7,-3080($s0)
       sw $t7,-2568($s0)
       sw $t7,-3588($s0)
       sw $t7,-3076($s0)
       sw $t7,-5656($s0)
       sw $t7,-5652($s0)
       sw $t7,-6164($s0)
       sw $t7,-6160($s0)
       sw $t7,-6672($s0)

       sw $t8,-8188($s0)
       sw $t8,-8184($s0)


       sw $t0,-5648($s0)
       sw $t0,-5612($s0)
       sw $t0,-5132($s0)
       sw $t0,-5104($s0)
       sw $t0,-4616($s0)
       sw $t0,-4596($s0)
       sw $t0,-4100($s0)
       sw $t0,-4088($s0)
       sw $t0,-3584($s0)
       sw $t0,-3580($s0)
       sw $t0,-3072($s0)
       sw $t0,-3068($s0)
       sw $t0,-2564($s0)
       sw $t0,-2552($s0)
       sw $t0,-2056($s0)
       sw $t0,-2036($s0)
       sw $t0,-1548($s0)
       sw $t0,-1520($s0)
       sw $t0,-1040($s0)
       sw $t0,-1004($s0)



	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $t4,16($sp)
	lw $t5,20($sp)
	lw $t6,24($sp)
	lw $t7,28($sp)
	addi $sp,$sp,32
	jr $ra
        #########################
	#### Apagar Bomba #########
        Apagar_bomba:     
	addi $sp,$sp,-32
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $t4,16($sp)
	sw $t5,20($sp)
	sw $t6,24($sp)
	sw $t7,28($sp)
	
	move $t0,$s2
	move $t1,$s2
	move $t2,$s2
	move $t3,$s2
	move $t4,$s2
	move $t5,$s2
	move $t6,$s2
	move $t7,$s2
	move $t8,$s2
	move $t9,$s2
	move $s1,$s2
				
	add $s0,$gp,$v0 #Atribui ao registrador $s0 o endereco do pixel central da cereja
	
       sw $t7,-7180($s0)
       sw $t7,-7176($s0)
       sw $t7,-7172($s0)
       sw $t7,-7168($s0)
       sw $t7,-7164($s0)
       sw $t7,-7160($s0)
       sw $t7,-7156($s0)
       sw $t7,-6668($s0)
       sw $t7,-6664($s0)
       sw $t7,-6660($s0)
       sw $t7,-6656($s0)
       sw $t7,-6652($s0)
       sw $t7,-6648($s0)
       sw $t7,-6644($s0)
       sw $t7,-6156($s0)
       sw $t7,-6152($s0)
       sw $t7,-6148($s0)
       sw $t7,-6144($s0)
       sw $t7,-6140($s0)
       sw $t7,-6136($s0)
       sw $t7,-6132($s0)
       sw $t7,-5644($s0)
       sw $t7,-5640($s0)
       sw $t7,-5636($s0)
       sw $t7,-5632($s0)
       sw $t7,-5628($s0)
       sw $t7,-5624($s0)
       sw $t7,-5620($s0)
       sw $t7,-7680($s0)
       sw $t7,-7676($s0)
       sw $t7,-5128($s0)
       sw $t7,-5124($s0)
       sw $t7,-5120($s0)
       sw $t7,-5116($s0)
       sw $t7,-5112($s0)
       sw $t7,-5108($s0)
       sw $t7,-4612($s0)
       sw $t7,-4608($s0)
       sw $t7,-4604($s0)
       sw $t7,-4600($s0)
       sw $t7,-4096($s0)
       sw $t7,-4092($s0)
       sw $t7,-4592($s0)
       sw $t7,-4588($s0)
       sw $t7,-4584($s0)
       sw $t7,-4580($s0)
       sw $t7,-4576($s0)
       sw $t7,-4080($s0)
       sw $t7,-4076($s0)
       sw $t7,-4072($s0)
       sw $t7,-4068($s0)
       sw $t7,-4064($s0)
       sw $t7,-3568($s0)
       sw $t7,-3564($s0)
       sw $t7,-3560($s0)
       sw $t7,-3556($s0)
       sw $t7,-3552($s0)
       sw $t7,-3056($s0)
       sw $t7,-3052($s0)
       sw $t7,-3048($s0)
       sw $t7,-3044($s0)
       sw $t7,-3040($s0)
       sw $t7,-2544($s0)
       sw $t7,-2540($s0)
       sw $t7,-2536($s0)
       sw $t7,-2532($s0)
       sw $t7,-2528($s0)
       sw $t7,-2032($s0)
       sw $t7,-2028($s0)
       sw $t7,-2024($s0)
       sw $t7,-2020($s0)
       sw $t7,-2016($s0)
       sw $t7,-3576($s0)
       sw $t7,-3064($s0)
       sw $t7,-4084($s0)
       sw $t7,-3572($s0)
       sw $t7,-3060($s0)
       sw $t7,-2548($s0)
       sw $t7,-5100($s0)
       sw $t7,-5096($s0)
       sw $t7,-5092($s0)
       sw $t7,-5608($s0)
       sw $t7,-1516($s0)
       sw $t7,-1512($s0)
       sw $t7,-1508($s0)
       sw $t7,-1000($s0)
       sw $t7,-488($s0)
       sw $t7,-1036($s0)
       sw $t7,-1032($s0)
       sw $t7,-1028($s0)
       sw $t7,-1024($s0)
       sw $t7,-1020($s0)
       sw $t7,-1016($s0)
       sw $t7,-1012($s0)
       sw $t7,-524($s0)
       sw $t7,-520($s0)
       sw $t7,-516($s0)
       sw $t7,-512($s0)
       sw $t7,-508($s0)
       sw $t7,-504($s0)
       sw $t7,-500($s0)
       sw $t7,-12($s0)
       sw $t7,-8($s0)
       sw $t7,-4($s0)
       sw $t7,0($s0)
       sw $t7,4($s0)
       sw $t7,8($s0)
       sw $t7,12($s0)
       sw $t7,500($s0)
       sw $t7,504($s0)
       sw $t7,508($s0)
       sw $t7,512($s0)
       sw $t7,516($s0)
       sw $t7,520($s0)
       sw $t7,524($s0)
       sw $t7,-1008($s0)
       sw $t7,-496($s0)
       sw $t7,16($s0)
       sw $t7,-492($s0)
       sw $t7,20($s0)
       sw $t7,-1544($s0)
       sw $t7,-1540($s0)
       sw $t7,-1536($s0)
       sw $t7,-1532($s0)
       sw $t7,-1528($s0)
       sw $t7,-1524($s0)
       sw $t7,-2052($s0)
       sw $t7,-2048($s0)
       sw $t7,-2044($s0)
       sw $t7,-2040($s0)
       sw $t7,-2560($s0)
       sw $t7,-2556($s0)
       sw $t7,-528($s0)
       sw $t7,-16($s0)
       sw $t7,-1044($s0)
       sw $t7,-532($s0)
       sw $t7,-5148($s0)
       sw $t7,-5144($s0)
       sw $t7,-5140($s0)
       sw $t7,-5136($s0)
       sw $t7,-4636($s0)
       sw $t7,-4632($s0)
       sw $t7,-4628($s0)
       sw $t7,-4624($s0)
       sw $t7,-4124($s0)
       sw $t7,-4120($s0)
       sw $t7,-4116($s0)
       sw $t7,-4112($s0)
       sw $t7,-3612($s0)
       sw $t7,-3608($s0)
       sw $t7,-3604($s0)
       sw $t7,-3600($s0)
       sw $t7,-3100($s0)
       sw $t7,-3096($s0)
       sw $t7,-3092($s0)
       sw $t7,-3088($s0)
       sw $t7,-2588($s0)
       sw $t7,-2584($s0)
       sw $t7,-2580($s0)
       sw $t7,-2576($s0)
       sw $t7,-2076($s0)
       sw $t7,-2072($s0)
       sw $t7,-2068($s0)
       sw $t7,-2064($s0)
       sw $t7,-1560($s0)
       sw $t7,-1048($s0)
       sw $t7,-1556($s0)
       sw $t7,-1552($s0)
       sw $t7,-4620($s0)
       sw $t7,-4108($s0)
       sw $t7,-3596($s0)
       sw $t7,-3084($s0)
       sw $t7,-2572($s0)
       sw $t7,-2060($s0)
       sw $t7,-4104($s0)
       sw $t7,-3592($s0)
       sw $t7,-3080($s0)
       sw $t7,-2568($s0)
       sw $t7,-3588($s0)
       sw $t7,-3076($s0)
       sw $t7,-5656($s0)
       sw $t7,-5652($s0)
       sw $t7,-6164($s0)
       sw $t7,-6160($s0)
       sw $t7,-6672($s0)

       sw $t8,-8188($s0)
       sw $t8,-8184($s0)


       sw $t0,-5648($s0)
       sw $t0,-5612($s0)
       sw $t0,-5132($s0)
       sw $t0,-5104($s0)
       sw $t0,-4616($s0)
       sw $t0,-4596($s0)
       sw $t0,-4100($s0)
       sw $t0,-4088($s0)
       sw $t0,-3584($s0)
       sw $t0,-3580($s0)
       sw $t0,-3072($s0)
       sw $t0,-3068($s0)
       sw $t0,-2564($s0)
       sw $t0,-2552($s0)
       sw $t0,-2056($s0)
       sw $t0,-2036($s0)
       sw $t0,-1548($s0)
       sw $t0,-1520($s0)
       sw $t0,-1040($s0)
       sw $t0,-1004($s0)



	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $t4,16($sp)
	lw $t5,20($sp)
	lw $t6,24($sp)
	lw $t7,28($sp)
	addi $sp,$sp,32
	jr $ra
	
	###### Pintar Moeda ############
	Pintar_moeda:
	#maça
	addi $sp,$sp,-32
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $t4,16($sp)
	sw $t5,20($sp)
	sw $t6,24($sp)
	sw $t7,28($sp)
	
	li $t0,0xff0000 #vermelho  
	li $t1,0xB8860B #marrom  
	li $t2,0x008000 #verde  
	li $t3,0x006400 #verde escuro  
	li $t4,0x90EE90 #verde claro 
	li $t5,0xFFFAFA #gelo 
	li $t6,0xffff00	#amarelo
	li $t7,0x000000 #preto	
	li $t8,0x595959 #cinza	
	li $t9,0xffaa00 #laranja
	li $s1,0x86592d #marrom escuro
				
	add $s0,$gp,$v0 #Atribui ao registrador $s0 o endereco do pixel central da maca
		
        sw $t6,-5640($s0)
        sw $t6,-5128($s0)
        sw $t6,-4616($s0)
        sw $t6,-6160($s0)
        sw $t6,-6156($s0)
        sw $t6,-5648($s0)
        sw $t6,-5644($s0)
        sw $t6,-5136($s0)
        sw $t6,-5132($s0)
        sw $t6,-4624($s0)
        sw $t6,-4620($s0)
        sw $t6,-5620($s0)
        sw $t6,-5616($s0)
        sw $t6,-5612($s0)
        sw $t6,-5108($s0)
        sw $t6,-5104($s0)
        sw $t6,-5100($s0)
        sw $t6,-4596($s0)
        sw $t6,-4592($s0)
        sw $t6,-4588($s0)
        sw $t6,-1540($s0)
        sw $t6,-1536($s0)
        sw $t6,-1532($s0)
        sw $t6,-1028($s0)
        sw $t6,-1024($s0)
        sw $t6,-1020($s0)
        sw $t6,-516($s0)
        sw $t6,-512($s0)
        sw $t6,-508($s0)
        sw $t6,-5652($s0)
        sw $t6,-5140($s0)
        sw $t6,-5624($s0)
        sw $t6,-5112($s0)
        sw $t6,-6160($s0)
        sw $t6,-6156($s0)
        sw $t6,-6132($s0)
        sw $t6,-6128($s0)
        sw $t6,-2052($s0)
        sw $t6,-2048($s0)
        sw $t6,-1544($s0)
        sw $t6,-1032($s0)

        sw $t9,-6676($s0)
        sw $t9,-6164($s0)
        sw $t9,-6168($s0)
        sw $t9,-5656($s0)
        sw $t9,-5144($s0)
        sw $t9,-4628($s0)
        sw $t9,-4112($s0)
        sw $t9,-4108($s0)
        sw $t9,-4104($s0)
        sw $t9,-7184($s0)
        sw $t9,-7180($s0)
        sw $t9,-6672($s0)
        sw $t9,-6668($s0)
        sw $t9,-6664($s0)
        sw $t9,-6152($s0)
        sw $t9,-6148($s0)
        sw $t9,-5636($s0)
        sw $t9,-5124($s0)
        sw $t9,-4612($s0)
        sw $t9,-6140($s0)
        sw $t9,-5628($s0)
        sw $t9,-5116($s0)
        sw $t9,-6648($s0)
        sw $t9,-6136($s0)
        sw $t9,-7156($s0)
        sw $t9,-7152($s0)
        sw $t9,-6644($s0)
        sw $t9,-6640($s0)
        sw $t9,-6636($s0)
        sw $t9,-6124($s0)
        sw $t9,-6120($s0)
        sw $t9,-5608($s0)
        sw $t9,-5096($s0)
        sw $t9,-4584($s0)
        sw $t9,-4084($s0)
        sw $t9,-4080($s0)
        sw $t9,-4076($s0)
        sw $t9,-4600($s0)
        sw $t9,-2060($s0)
        sw $t9,-1548($s0)
        sw $t9,-1036($s0)
        sw $t9,-2568($s0)
        sw $t9,-2056($s0)
        sw $t9,-3076($s0)
        sw $t9,-3072($s0)
        sw $t9,-2564($s0)
        sw $t9,-2560($s0)
        sw $t9,-2556($s0)
        sw $t9,-2044($s0)
        sw $t9,-1528($s0)
        sw $t9,-1016($s0)
        sw $t9,-504($s0)
        sw $t9,-4($s0)
        sw $t9,0($s0)
        sw $t9,4($s0)
        sw $t9,-520($s0)       
        
	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $t4,16($sp)
	lw $t5,20($sp)
	lw $t6,24($sp)
	lw $t7,28($sp)
	addi $sp,$sp,32
	jr $ra
        #########################
        ###### Apagar Moeda ############
	Apagar_moeda:
	#maça
	addi $sp,$sp,-32
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $t4,16($sp)
	sw $t5,20($sp)
	sw $t6,24($sp)
	sw $t7,28($sp)
	
	move $t0,$s2
	move $t1,$s2
	move $t2,$s2
	move $t3,$s2
	move $t4,$s2
	move $t5,$s2
	move $t6,$s2
	move $t7,$s2
	move $t8,$s2
	move $t9,$s2
	move $s1,$s2
				
	add $s0,$gp,$v0 #Atribui ao registrador $s0 o endereco do pixel central da maca
		
        sw $t6,-5640($s0)
        sw $t6,-5128($s0)
        sw $t6,-4616($s0)
        sw $t6,-6160($s0)
        sw $t6,-6156($s0)
        sw $t6,-5648($s0)
        sw $t6,-5644($s0)
        sw $t6,-5136($s0)
        sw $t6,-5132($s0)
        sw $t6,-4624($s0)
        sw $t6,-4620($s0)
        sw $t6,-5620($s0)
        sw $t6,-5616($s0)
        sw $t6,-5612($s0)
        sw $t6,-5108($s0)
        sw $t6,-5104($s0)
        sw $t6,-5100($s0)
        sw $t6,-4596($s0)
        sw $t6,-4592($s0)
        sw $t6,-4588($s0)
        sw $t6,-1540($s0)
        sw $t6,-1536($s0)
        sw $t6,-1532($s0)
        sw $t6,-1028($s0)
        sw $t6,-1024($s0)
        sw $t6,-1020($s0)
        sw $t6,-516($s0)
        sw $t6,-512($s0)
        sw $t6,-508($s0)
        sw $t6,-5652($s0)
        sw $t6,-5140($s0)
        sw $t6,-5624($s0)
        sw $t6,-5112($s0)
        sw $t6,-6160($s0)
        sw $t6,-6156($s0)
        sw $t6,-6132($s0)
        sw $t6,-6128($s0)
        sw $t6,-2052($s0)
        sw $t6,-2048($s0)
        sw $t6,-1544($s0)
        sw $t6,-1032($s0)

        sw $t9,-6676($s0)
        sw $t9,-6164($s0)
        sw $t9,-6168($s0)
        sw $t9,-5656($s0)
        sw $t9,-5144($s0)
        sw $t9,-4628($s0)
        sw $t9,-4112($s0)
        sw $t9,-4108($s0)
        sw $t9,-4104($s0)
        sw $t9,-7184($s0)
        sw $t9,-7180($s0)
        sw $t9,-6672($s0)
        sw $t9,-6668($s0)
        sw $t9,-6664($s0)
        sw $t9,-6152($s0)
        sw $t9,-6148($s0)
        sw $t9,-5636($s0)
        sw $t9,-5124($s0)
        sw $t9,-4612($s0)
        sw $t9,-6140($s0)
        sw $t9,-5628($s0)
        sw $t9,-5116($s0)
        sw $t9,-6648($s0)
        sw $t9,-6136($s0)
        sw $t9,-7156($s0)
        sw $t9,-7152($s0)
        sw $t9,-6644($s0)
        sw $t9,-6640($s0)
        sw $t9,-6636($s0)
        sw $t9,-6124($s0)
        sw $t9,-6120($s0)
        sw $t9,-5608($s0)
        sw $t9,-5096($s0)
        sw $t9,-4584($s0)
        sw $t9,-4084($s0)
        sw $t9,-4080($s0)
        sw $t9,-4076($s0)
        sw $t9,-4600($s0)
        sw $t9,-2060($s0)
        sw $t9,-1548($s0)
        sw $t9,-1036($s0)
        sw $t9,-2568($s0)
        sw $t9,-2056($s0)
        sw $t9,-3076($s0)
        sw $t9,-3072($s0)
        sw $t9,-2564($s0)
        sw $t9,-2560($s0)
        sw $t9,-2556($s0)
        sw $t9,-2044($s0)
        sw $t9,-1528($s0)
        sw $t9,-1016($s0)
        sw $t9,-504($s0)
        sw $t9,-4($s0)
        sw $t9,0($s0)
        sw $t9,4($s0)
        sw $t9,-520($s0)       
        
	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $t2,8($sp)
	lw $t3,12($sp)
	lw $t4,16($sp)
	lw $t5,20($sp)
	lw $t6,24($sp)
	lw $t7,28($sp)
	addi $sp,$sp,32
	jr $ra
        #########################
        ####### Pintar_boneca ###########
        	
        Pintar_boneca:      	
        	addi $sp,$sp,-68
		sw $t0,0($sp)
		sw $t1,4($sp)
		sw $s4,8($sp)
		sw $t2,12($sp)
		sw $t3,16($sp)
		sw $t4,20($sp)
		sw $t5,24($sp)
		sw $t6,28($sp)
		sw $t7,32($sp)
		sw $t8,36($sp)
		sw $t9,40($sp)
		sw $s1,44($sp)
		sw $s2,48($sp)
		sw $s3,52($sp)
		sw $s6,56($sp)
		sw $s7,60($sp)
		sw $a0,64($sp)
		
		
		

	beq $v1,$zero,apagar_boneca
	li $t0,0xff0000 #vermelho  
	li $t1,0xB8860B #marrom  
	li $s4,0x83350C #marrom médio  
	li $s4,0x4F1D02 #marrom muito escuro  
	li $t2,0x008000 #verde  
	li $t3,0x006400 #verde escuro  
	li $t4,0x90EE90 #verde claro 
	li $t5,0xFFFAFA #gelo 
	li $t6,0xffff00	#amarelo
	li $t7,0x000000 #preto	
	li $t8,0x595959 #cinza	
	li $t9,0xffaa00 #laranja
	li $s1,0x86592d #marrom escuro
	li $s2,0xFFF8DC #pele
	li $s3,0xD2691E #cabelo
	li $s6,0x11D8F8 #azul olhos
	li $s7,0xF8D1E8 #nariz pink
	li $a0,0x000000 #branco
	j cont1_pintar_boneca
	
	apagar_boneca:	
	move $t0,$s2
	move $t1,$s2
	move $s4,$s2
	move $s4,$s2
	move $t2,$s2
	move $t3,$s2
	move $t4,$s2
	move $t5,$s2
	move $t6,$s2
	move $t7,$s2 #preto	
	move $t8,$s2
	move $t9,$s2
	move $s1,$s2
	move $s2,$s2
	move $s3,$s2
	move $s6,$s2
	move $s7,$s2
	move $a0,$s2 
	move $s5,$s2

	cont1_pintar_boneca:
	
	add $s0,$gp,$k0 #Atribui ao registrador $s0 o endereco do pixel central da maca
	addi $s0,$s0,-6168
	

#personagem
	#verde
     sw $t2,15352($s0)	
     sw $t2,15356($s0)
     sw $t2,15864($s0)	
     sw $t2,15868($s0)
     sw $t2,16376($s0)	
     sw $t2,16380($s0)
     sw $t2,16888($s0)	
     sw $t2,16892($s0)
     sw $t2,17400($s0)	
     sw $t2,17404($s0)
     sw $t2,17912($s0)	
     sw $t2,17916($s0)
     sw $t2,18424($s0)	
     sw $t2,18428($s0)
     sw $t2,18936($s0)	
     sw $t2,18940($s0)
     sw $t2,19448($s0)	
     sw $t2,19452($s0)
     sw $t2,19960($s0)	
     sw $t2,19964($s0)
     sw $t2,26100($s0)
     sw $t2,26612($s0)
     sw $t2,27124($s0)
     sw $t2,27636($s0)
     sw $t2,28148($s0)
     sw $t2,28660($s0)
     sw $t2,29172($s0)
     sw $t2,29684($s0)
     sw $t2,30196($s0)
     sw $t2,30708($s0)
     sw $t2,31220($s0)
     sw $t2,31732($s0)
     sw $t2,32244($s0)
     sw $t2,32756($s0)
     sw $t2,33268($s0)
     sw $t2,33780($s0)
     sw $t2,34804($s0)
     sw $t2,34296($s0)
     sw $t2,34808($s0)
     sw $t2,26616($s0)
     sw $t2,27128($s0)
     sw $t2,27640($s0)
     sw $t2,28152($s0)
     sw $t2,28664($s0)
     sw $t2,29176($s0)
     sw $t2,29688($s0)
     sw $t2,30200($s0)
     sw $t2,30712($s0)
     sw $t2,31224($s0)
     sw $t2,31736($s0)
     sw $t2,32248($s0)
     sw $t2,32760($s0)
     sw $t2,33272($s0)
     sw $t2,27132($s0)
     sw $t2,27644($s0)
     sw $t2,28156($s0)
     sw $t2,28668($s0)
     sw $t2,29180($s0)
     sw $t2,29692($s0)
     sw $t2,30204($s0)
     sw $t2,30716($s0)
     sw $t2,31228($s0)
     sw $t2,31740($s0)
     sw $t2,32252($s0)
     sw $t2,32764($s0)
     sw $t2,33276($s0)
     sw $t2,34300($s0)
     sw $t2,34812($s0)
     sw $t2,35324($s0)
     sw $t2,34304($s0)
     sw $t2,34816($s0)
     sw $t2,35328($s0)
     sw $t2,27648($s0)
     sw $t2,28160($s0)
     sw $t2,28672($s0)
     sw $t2,29184($s0)
     sw $t2,29696($s0)
     sw $t2,30208($s0)
     sw $t2,30720($s0)
     sw $t2,31232($s0)
     sw $t2,31744($s0)
     sw $t2,32256($s0)
     sw $t2,32768($s0)
     sw $t2,33280($s0)
     sw $t2,28164($s0)
     sw $t2,28676($s0)
     sw $t2,29188($s0)
     sw $t2,29700($s0)
     sw $t2,30212($s0)
     sw $t2,30724($s0)
     sw $t2,31236($s0)
     sw $t2,31748($s0)
     sw $t2,32260($s0)
     sw $t2,32772($s0)
     sw $t2,33284($s0)
     sw $t2,33796($s0)
     sw $t2,28168($s0)
     sw $t2,28680($s0)
     sw $t2,29192($s0)
     sw $t2,29704($s0)
     sw $t2,30216($s0)
     sw $t2,30728($s0)
     sw $t2,31240($s0)
     sw $t2,31752($s0)
     sw $t2,32264($s0)
     sw $t2,32776($s0)
     sw $t2,33288($s0)
     sw $t2,34824($s0)
     sw $t2,35336($s0)
     sw $t2,28172($s0)
     sw $t2,28684($s0)
     sw $t2,29196($s0)
     sw $t2,29708($s0)
     sw $t2,30220($s0)
     sw $t2,30732($s0)
     sw $t2,31244($s0)
     sw $t2,31756($s0)
     sw $t2,32268($s0)
     sw $t2,32780($s0)
     sw $t2,33804($s0)
     sw $t2,34316($s0)
     sw $t2,34828($s0)
     sw $t2,35340($s0)
     sw $t2,33808($s0)
     sw $t2,34320($s0)
     sw $t2,34832($s0)
     sw $t2,35344($s0)
     sw $t2,28176($s0)
     sw $t2,28688($s0)
     sw $t2,29200($s0)
     sw $t2,29712($s0)
     sw $t2,30224($s0)
     sw $t2,30736($s0)
     sw $t2,31248($s0)
     sw $t2,31760($s0)
     sw $t2,32272($s0)
     sw $t2,32784($s0)
     sw $t2,28180($s0)
     sw $t2,28692($s0)
     sw $t2,29204($s0)
     sw $t2,29716($s0)
     sw $t2,30228($s0)
     sw $t2,30740($s0)
     sw $t2,31252($s0)
     sw $t2,31764($s0)
     sw $t2,32276($s0)
     sw $t2,32788($s0)
     sw $t2,33812($s0)
     sw $t2,34324($s0)
     sw $t2,34836($s0)
     sw $t2,35348($s0)
     sw $t2,34328($s0)
     sw $t2,34840($s0)
     sw $t2,35352($s0)
     sw $t2,28184($s0)
     sw $t2,28696($s0)
     sw $t2,29208($s0)
     sw $t2,29720($s0)
     sw $t2,30232($s0)
     sw $t2,30744($s0)
     sw $t2,31256($s0)
     sw $t2,31768($s0)
     sw $t2,32280($s0)
     sw $t2,32792($s0)
     sw $t2,33304($s0)
     sw $t2,28188($s0)
     sw $t2,28700($s0)
     sw $t2,29212($s0)
     sw $t2,29724($s0)
     sw $t2,30236($s0)
     sw $t2,30748($s0)
     sw $t2,31260($s0)
     sw $t2,31772($s0)
     sw $t2,32284($s0)
     sw $t2,32796($s0)
     sw $t2,33308($s0)
     sw $t2,28192($s0)
     sw $t2,28704($s0)
     sw $t2,29216($s0)
     sw $t2,29728($s0)
     sw $t2,30240($s0)
     sw $t2,30752($s0)
     sw $t2,31264($s0)
     sw $t2,31776($s0)
     sw $t2,32288($s0)
     sw $t2,32800($s0)
     sw $t2,33312($s0)
     sw $t2,33824($s0)
     sw $t2,34848($s0)
     sw $t2,35360($s0)
     sw $t2,34340($s0)
     sw $t2,34852($s0)
     sw $t2,35364($s0)
     sw $t2,28196($s0)
     sw $t2,28708($s0)
     sw $t2,29220($s0)
     sw $t2,29732($s0)
     sw $t2,30244($s0)
     sw $t2,30756($s0)
     sw $t2,31268($s0)
     sw $t2,31780($s0)
     sw $t2,32292($s0)
     sw $t2,32804($s0)
     sw $t2,28200($s0)
     sw $t2,28712($s0)
     sw $t2,29224($s0)
     sw $t2,29736($s0)
     sw $t2,30248($s0)
     sw $t2,30760($s0)
     sw $t2,31272($s0)
     sw $t2,31784($s0)
     sw $t2,32296($s0)
     sw $t2,32808($s0)
     sw $t2,33832($s0)
     sw $t2,34344($s0)
     sw $t2,34856($s0)
     sw $t2,35368($s0)
     sw $t2,33836($s0)
     sw $t2,34348($s0)
     sw $t2,34860($s0)
     sw $t2,35372($s0)
     sw $t2,28204($s0)
     sw $t2,28716($s0)
     sw $t2,29228($s0)
     sw $t2,29740($s0)
     sw $t2,30252($s0)
     sw $t2,30764($s0)
     sw $t2,31276($s0)
     sw $t2,31788($s0)
     sw $t2,32300($s0)
     sw $t2,32812($s0)
     sw $t2,27696($s0)
     sw $t2,28208($s0)
     sw $t2,28720($s0)
     sw $t2,29232($s0)
     sw $t2,29744($s0)
     sw $t2,30256($s0)
     sw $t2,30768($s0)
     sw $t2,31280($s0)
     sw $t2,31792($s0)
     sw $t2,32304($s0)
     sw $t2,32816($s0)
     sw $t2,33328($s0)
     sw $t2,34864($s0)
     sw $t2,35376($s0)
     sw $t2,34868($s0)
     sw $t2,27188($s0)
     sw $t2,27700($s0)
     sw $t2,28212($s0)
     sw $t2,28724($s0)
     sw $t2,29236($s0)
     sw $t2,29748($s0)
     sw $t2,30260($s0)
     sw $t2,30772($s0)
     sw $t2,31284($s0)
     sw $t2,31796($s0)
     sw $t2,32308($s0)
     sw $t2,32820($s0)
     sw $t2,33332($s0)
     sw $t2,33844($s0)
     sw $t2,26680($s0)
     sw $t2,27192($s0)
     sw $t2,27704($s0)
     sw $t2,28216($s0)
     sw $t2,28728($s0)
     sw $t2,29240($s0)
     sw $t2,29752($s0)
     sw $t2,30264($s0)
     sw $t2,30776($s0)
     sw $t2,31288($s0)
     sw $t2,31800($s0)
     sw $t2,32312($s0)
     sw $t2,32824($s0)
     sw $t2,33336($s0)
     sw $t2,34360($s0)
     sw $t2,34364($s0)
     sw $t2,34876($s0)
     sw $t2,26172($s0)
     sw $t2,26684($s0)
     sw $t2,27196($s0)
     sw $t2,27708($s0)
     sw $t2,28220($s0)
     sw $t2,28732($s0)
     sw $t2,29244($s0)
     sw $t2,29756($s0)
     sw $t2,30268($s0)
     sw $t2,30780($s0)
     sw $t2,31292($s0)
     sw $t2,31804($s0)
     sw $t2,32316($s0)
     sw $t2,32828($s0)
     sw $t2,15360($s0)
     sw $t2,15872($s0)
     sw $t2,16384($s0)
     sw $t2,14852($s0)
     sw $t2,15364($s0)
     sw $t2,15876($s0)
     sw $t2,16388($s0)
     sw $t2,16900($s0)
     sw $t2,17412($s0)
     sw $t2,17924($s0)
     sw $t2,18436($s0)
     sw $t2,19460($s0)
     sw $t2,19972($s0)
     sw $t2,20484($s0)
     sw $t2,14856($s0)
     sw $t2,15368($s0)
     sw $t2,15880($s0)
     sw $t2,16392($s0)
     sw $t2,16904($s0)
     sw $t2,17416($s0)
     sw $t2,17928($s0)
     sw $t2,18440($s0)
     sw $t2,18952($s0)
     sw $t2,19976($s0)
     sw $t2,20488($s0)
     sw $t2,14860($s0)
     sw $t2,15372($s0)
     sw $t2,15884($s0)
     sw $t2,16396($s0)
     sw $t2,16908($s0)
     sw $t2,17420($s0)
     sw $t2,17932($s0)
     sw $t2,18444($s0)
     sw $t2,18956($s0)
     sw $t2,19468($s0)
     sw $t2,20492($s0)
     sw $t2,20496($s0)	
     sw $t2,20500($s0)	
     sw $t2,20504($s0)	
     sw $t2,20508($s0)	
     sw $t2,20512($s0)	
     sw $t2,20516($s0)	
     sw $t2,20520($s0)	
     sw $t2,20524($s0)
     sw $t2,19988($s0)	
     sw $t2,19992($s0)	
     sw $t2,19996($s0)
     sw $t2,20008($s0)	
     sw $t2,20012($s0)
     sw $t2,19480($s0)
     sw $t2,19500($s0)
     sw $t2,15388($s0)	
     sw $t2,15392($s0)	
     sw $t2,15396($s0)	
     sw $t2,15400($s0)
     sw $t2,15900($s0)	
     sw $t2,15904($s0)	
     sw $t2,15908($s0)	
     sw $t2,15912($s0)
     sw $t2,16412($s0)	
     sw $t2,16416($s0)	
     sw $t2,16420($s0)	
     sw $t2,16424($s0)
     sw $t2,16924($s0)	
     sw $t2,16928($s0)	
     sw $t2,16932($s0)	
     sw $t2,16936($s0)
     sw $t2,17436($s0)	
     sw $t2,17440($s0)	
     sw $t2,17444($s0)	
     sw $t2,17448($s0)
     sw $t2,17948($s0)	
     sw $t2,17952($s0)	
     sw $t2,17956($s0)	
     sw $t2,17960($s0)
     sw $t2,18460($s0)	
     sw $t2,18464($s0)	
     sw $t2,18468($s0)	
     sw $t2,18472($s0)
     sw $t2,18972($s0)	
     sw $t2,18976($s0)	
     sw $t2,18980($s0)	
     sw $t2,18984($s0)
     sw $t2,19488($s0)	
     sw $t2,19492($s0)
     sw $t2,14884($s0)	
     sw $t2,14888($s0)
     sw $t2,15404($s0)	
     sw $t2,15408($s0)	
     sw $t2,15412($s0)
     sw $t2,15916($s0)	
     sw $t2,15920($s0)	
     sw $t2,15924($s0)
     sw $t2,16428($s0)	
     sw $t2,16432($s0)	
     sw $t2,16436($s0)
     sw $t2,16948($s0)
     sw $t2,17460($s0)
     sw $t2,17972($s0)
     sw $t2,18484($s0)
     sw $t2,18996($s0)
     sw $t2,19508($s0)
     sw $t2,20020($s0)
     sw $t2,14864($s0)
     sw $t2,15376($s0)
     sw $t2,15888($s0)
     sw $t2,16400($s0)
     sw $t2,16912($s0)
     sw $t2,17424($s0)
     sw $t2,17936($s0)
     sw $t2,18448($s0)
     sw $t2,18960($s0)
     sw $t2,19472($s0)
     sw $t2,15380($s0)
     sw $t2,15892($s0)
     sw $t2,16404($s0)
     sw $t2,16916($s0)
     sw $t2,17428($s0)
     sw $t2,17940($s0)
     sw $t2,18452($s0)
     sw $t2,18964($s0)
     sw $t2,15384($s0)
     sw $t2,15896($s0)
     sw $t2,16408($s0)
     sw $t2,16920($s0)	 

	#verde escuro

     sw $t3,20472($s0)	
     sw $t3,20476($s0)	
     sw $t3,20480($s0)
     sw $t3,20528($s0)	
     sw $t3,20532($s0)
     sw $t3,16896($s0)
     sw $t3,17408($s0)
     sw $t3,17920($s0)
     sw $t3,18432($s0)
     sw $t3,18944($s0)
     sw $t3,19456($s0)
     sw $t3,19968($s0)
     sw $t3,16940($s0)
     sw $t3,17452($s0)
     sw $t3,17964($s0)
     sw $t3,18476($s0)
     sw $t3,18988($s0)
     sw $t3,17432($s0)
     sw $t3,17944($s0)
     sw $t3,18456($s0)
     sw $t3,18968($s0)
     sw $t3,18948($s0)
     sw $t3,19464($s0)
     sw $t3,19980($s0)	
     sw $t3,19984($s0)
     sw $t3,19476($s0)
     sw $t3,19484($s0)
     sw $t3,20000($s0)	
     sw $t3,20004($s0)
     sw $t3,19496($s0)
     sw $t3,33784($s0)	
     sw $t3,33788($s0)	
     sw $t3,33792($s0)
     sw $t3,34292($s0)
     sw $t3,34308($s0)
     sw $t3,34820($s0)
     sw $t3,35332($s0)
     sw $t3,33800($s0)
     sw $t3,34312($s0)
     sw $t3,33292($s0)	
     sw $t3,33296($s0)	
     sw $t3,33300($s0)
     sw $t3,33816($s0)	
     sw $t3,33820($s0)
     sw $t3,34332($s0)
     sw $t3,34844($s0)
     sw $t3,35356($s0)
     sw $t3,34336($s0)
     sw $t3,33316($s0)
     sw $t3,33828($s0)
     sw $t3,33320($s0)	
     sw $t3,33324($s0)
     sw $t3,33840($s0)
     sw $t3,34352($s0)
     sw $t3,34356($s0)
     sw $t3,34872($s0)
     sw $t3,33848($s0)	
     sw $t3,33852($s0)
     sw $t3,33340($s0)
				   
	#verde claro   
	 sw $t4,16944($s0)
	 sw $t4,17456($s0)
	 sw $t4,17968($s0)
	 sw $t4,18480($s0)
	 sw $t4,18992($s0)
	 sw $t4,19504($s0)
	 sw $t4,20016($s0)
	 sw $t4,14892($s0)	
	 sw $t4,14896($s0)
	 sw $t4,14844($s0)	
	 sw $t4,14848($s0)
#labios
	
	
	sw $t0,12824($s0)
    sw $t0,12828($s0)

	#pele
	
     sw $s2,35848($s0)
     sw $s2,35852($s0)
     sw $s2,35856($s0)
     sw $s2,35868($s0)
     sw $s2,35872($s0)
     sw $s2,35876($s0)
     sw $s2,36360($s0)
     sw $s2,36364($s0)
     sw $s2,36368($s0)
     sw $s2,36380($s0)
     sw $s2,36384($s0)
     sw $s2,36388($s0)
     sw $s2,36872($s0)
     sw $s2,36876($s0)
     sw $s2,36880($s0)
     sw $s2,36892($s0)
     sw $s2,36896($s0)
     sw $s2,36900($s0)
     sw $s2,8200($s0)	
     sw $s2,8204($s0)	
     sw $s2,8208($s0)	
     sw $s2,8212($s0)	
     sw $s2,8216($s0)	
     sw $s2,8220($s0)	
     sw $s2,8224($s0)	
     sw $s2,8228($s0)	
     sw $s2,8232($s0)
     sw $s2,8712($s0)	
     sw $s2,8716($s0)	
     sw $s2,8720($s0)	
     sw $s2,8724($s0)	
     sw $s2,8728($s0)	
     sw $s2,8732($s0)	            	
     sw $s2,8744($s0)
     sw $s2,9224($s0)	
     sw $s2,9228($s0)	
     sw $s2,9232($s0)	
     sw $s2,9236($s0)	
     sw $s2,9240($s0)	
     sw $s2,9244($s0)	
     sw $s2,9248($s0)	
     sw $s2,9252($s0)	
     sw $s2,9256($s0)
     sw $s2,9736($s0)	
     sw $s2,9740($s0)	
     sw $s2,9744($s0)	
     sw $s2,9748($s0)	
     sw $s2,9752($s0)	
     sw $s2,9756($s0)	
     sw $s2,9760($s0)	
     sw $s2,9764($s0)	
     sw $s2,9768($s0)
     sw $s2,10248($s0)	            	
     sw $s2,10260($s0)	
     sw $s2,10264($s0)	
     sw $s2,10268($s0)	            	
     sw $s2,10280($s0)
     sw $s2,10760($s0)	
     sw $s2,10764($s0)	
     sw $s2,10768($s0)	
     sw $s2,10772($s0)	
     sw $s2,10776($s0)	
     sw $s2,10780($s0)	
     sw $s2,10784($s0)	
     sw $s2,10788($s0)	
     sw $s2,10792($s0)
     sw $s2,11272($s0)	
     sw $s2,11276($s0)	
     sw $s2,11280($s0)	
     sw $s2,11284($s0)	
     sw $s2,11288($s0)	
     sw $s2,11292($s0)	
     sw $s2,11296($s0)	
     sw $s2,11300($s0)	
     sw $s2,11304($s0)
     sw $s2,11784($s0)	
     sw $s2,11788($s0)	
     sw $s2,11792($s0)	
     sw $s2,11796($s0)	            	
     sw $s2,11808($s0)	
     sw $s2,11812($s0)	
     sw $s2,11816($s0)
     sw $s2,12296($s0)	
     sw $s2,12300($s0)	
     sw $s2,12304($s0)	
     sw $s2,12308($s0)	
     sw $s2,12312($s0)	
     sw $s2,12316($s0)	
     sw $s2,12320($s0)	
     sw $s2,12324($s0)	
     sw $s2,12328($s0)
     sw $s2,12808($s0)	
     sw $s2,12812($s0)	
     sw $s2,12816($s0)	
     sw $s2,12820($s0)	            	
     sw $s2,12832($s0)	
     sw $s2,12836($s0)	
     sw $s2,12840($s0)
     sw $s2,13320($s0)	
     sw $s2,13324($s0)	
     sw $s2,13328($s0)	
     sw $s2,13332($s0)	
     sw $s2,13336($s0)	
     sw $s2,13340($s0)	
     sw $s2,13344($s0)	
     sw $s2,13348($s0)	
     sw $s2,13352($s0)
     sw $s2,9772($s0)
     sw $s2,9776($s0)
     sw $s2,10288($s0)
     sw $s2,10800($s0)
     sw $s2,11308($s0)	
     sw $s2,11312($s0)
     sw $s2,11820($s0)	 
     sw $s2,9728($s0)
     sw $s2,9732 ($s0)
     sw $s2,10240($s0)	 
     sw $s2,10752($s0)	 
     sw $s2,11264($s0)	
     sw $s2,11268($s0)
     sw $s2,11780($s0)
     sw $s2,13844($s0)	
     sw $s2,13848($s0)	
     sw $s2,13852($s0)	
     sw $s2,13856($s0)
     sw $s2,14356($s0)	
     sw $s2,14360($s0)	
     sw $s2,14364($s0)	
     sw $s2,14368($s0)
     sw $s2,14868($s0)	
     sw $s2,14872($s0)	
     sw $s2,14876($s0)	
     sw $s2,14880($s0)
	 
	 #cabelo
      sw $s3,6144  ($s0)
      sw $s3,8192  ($s0)
      sw $s3,8196  ($s0)
      sw $s3,12332 ($s0)
      sw $s3,12844 ($s0)
      sw $s3,12848 ($s0)
      sw $s3,8236  ($s0)
      sw $s3,8240  ($s0)
      sw $s3,8748  ($s0)
      sw $s3,8752  ($s0)
      sw $s3,9260  ($s0)
      sw $s3,9264  ($s0)
      sw $s3,13356 ($s0)
      sw $s3,13360 ($s0)
      sw $s3,13868 ($s0)
      sw $s3,13872 ($s0)
      sw $s3,8244  ($s0)
      sw $s3,8756  ($s0)
      sw $s3,9268  ($s0)
      sw $s3,9780  ($s0)
      sw $s3,10292 ($s0)
      sw $s3,10804 ($s0)
      sw $s3,11316 ($s0)
      sw $s3,11828 ($s0)
      sw $s3,12340 ($s0)
      sw $s3,12852 ($s0)
      sw $s3,8704  ($s0)
      sw $s3,8708  ($s0)
      sw $s3,9216  ($s0)
      sw $s3,9220  ($s0)
      sw $s3,8700  ($s0)
      sw $s3,9212  ($s0)
      sw $s3,9724  ($s0)
      sw $s3,10236 ($s0)
      sw $s3,10748 ($s0)
      sw $s3,11260 ($s0)
      sw $s3,11772 ($s0)
      sw $s3,12284 ($s0)
      sw $s3,12796 ($s0)
      sw $s3,12292 ($s0)
      sw $s3,12800 ($s0)
      sw $s3,12804 ($s0)
      sw $s3,13312 ($s0)
      sw $s3,13316 ($s0)
      sw $s3,13824 ($s0)
      sw $s3,13828 ($s0)
      sw $s3,6148  ($s0)
      sw $s3,6152  ($s0)
      sw $s3,6156  ($s0)
      sw $s3,6160  ($s0)
      sw $s3,6164  ($s0)
      sw $s3,6168  ($s0)
      sw $s3,6172  ($s0)
      sw $s3,6176  ($s0)
      sw $s3,6180  ($s0)
      sw $s3,6184  ($s0)
      sw $s3,6656  ($s0)
      sw $s3,6660  ($s0)
      sw $s3,6664  ($s0)
      sw $s3,6668  ($s0)
      sw $s3,6672  ($s0)
      sw $s3,6676  ($s0)
      sw $s3,6680  ($s0)
      sw $s3,6684  ($s0)
      sw $s3,6688  ($s0)
      sw $s3,6692  ($s0)
      sw $s3,6696  ($s0)
      sw $s3,7168  ($s0)
      sw $s3,7172  ($s0)
      sw $s3,7176  ($s0)
      sw $s3,7180  ($s0)
      sw $s3,7184  ($s0)
      sw $s3,7188  ($s0)
      sw $s3,7192  ($s0)
      sw $s3,7196  ($s0)
      sw $s3,7200  ($s0)
      sw $s3,7204  ($s0)
      sw $s3,7208  ($s0)
      sw $s3,7680  ($s0)
      sw $s3,7684  ($s0)
      sw $s3,7688  ($s0)
      sw $s3,7692  ($s0)
      sw $s3,7696  ($s0)
      sw $s3,7700  ($s0)
      sw $s3,7704  ($s0)
      sw $s3,7708  ($s0)
      sw $s3,7712  ($s0)
      sw $s3,7716  ($s0)
      sw $s3,7720  ($s0)
	  
#cesta
	#marrom médio 
      sw $t1,20972($s0)
      sw $t1,24060($s0)
      sw $t1,21484($s0)
      sw $t1,21996($s0)
      sw $t1,25080($s0)
      sw $t1,25588($s0)
      sw $t1,27144($s0)
      sw $t1,20976($s0)
      sw $t1,24064($s0)
      sw $t1,22000($s0)
      sw $t1,22512($s0)
      sw $t1,25088($s0)
      sw $t1,25596($s0)
      sw $t1,27152($s0)
      sw $t1,20980($s0)
      sw $t1,24068($s0)
      sw $t1,22516($s0)
      sw $t1,23028($s0)
      sw $t1,25096($s0)
      sw $t1,25604($s0)
      sw $t1,27160($s0)
      sw $t1,20984($s0)
      sw $t1,24072($s0)
      sw $t1,23032($s0)
      sw $t1,23544($s0)
      sw $t1,25104($s0)
      sw $t1,25612($s0)
      sw $t1,27168($s0)
      sw $t1,20988($s0)
      sw $t1,24076($s0)
      sw $t1,23548($s0)
      sw $t1,24060($s0)
      sw $t1,25112($s0)
      sw $t1,25620($s0)
      sw $t1,27176($s0)
      sw $t1,20992($s0)
      sw $t1,24080($s0)
      sw $t1,23604($s0)
      sw $t1,23096($s0)
      sw $t1,25120($s0)
      sw $t1,25628($s0)
      sw $t1,27652($s0)
      sw $t1,20996($s0)
      sw $t1,24084($s0)
      sw $t1,23608($s0)
      sw $t1,23100($s0)
      sw $t1,25128($s0)
      sw $t1,25636($s0)
      sw $t1,27660($s0)
      sw $t1,21000($s0)
      sw $t1,24088($s0)
      sw $t1,22588($s0)
      sw $t1,21008($s0)
      sw $t1,24096($s0)
      sw $t1,21568($s0)
      sw $t1,22080($s0)
      sw $t1,21004($s0)
      sw $t1,24092($s0)
      sw $t1,22592($s0)
      sw $t1,25144($s0)
      sw $t1,25652($s0)
      sw $t1,27676($s0)
      sw $t1,21012($s0)
      sw $t1,24100($s0)
      sw $t1,21016($s0)
      sw $t1,24104($s0)
      sw $t1,21020($s0)
      sw $t1,24108($s0)
      sw $t1,21024($s0)
      sw $t1,24112($s0)
      sw $t1,21028($s0) 
      sw $t1,24116($s0)
      sw $t1,25136($s0)
      sw $t1,25644($s0)
      sw $t1,27668($s0)
      sw $t1,25660($s0)
      sw $t1,27684($s0)
      sw $t1,27692($s0)
      sw $t1,21032($s0)
      sw $t1,21036($s0)
      sw $t1,21040($s0)
	  #marrom médio
      sw $s4,21492($s0)
      sw $s4,22004($s0)
      sw $s4,21488($s0)
      sw $s4,24564($s0)
      sw $s4,25076($s0)
      sw $s4,25592($s0)
      sw $s4,26104($s0)
      sw $s4,26620($s0)
      sw $s4,27136($s0)
      sw $s4,27656($s0)
      sw $s4,21504($s0)
      sw $s4,22016($s0)
      sw $s4,23024($s0)
      sw $s4,24576($s0)
      sw $s4,25100($s0)
      sw $s4,25616($s0)
      sw $s4,26116($s0)
      sw $s4,26632($s0)
      sw $s4,27156($s0)
      sw $s4,27680($s0)
      sw $s4,21512($s0) 
      sw $s4,22024($s0)
      sw $s4,23536($s0)
      sw $s4,24584($s0)
      sw $s4,25116($s0)
      sw $s4,25632($s0)
      sw $s4,26124($s0)
      sw $s4,26640($s0)
      sw $s4,27172($s0)
      sw $s4,21528($s0)
      sw $s4,22040($s0)
      sw $s4,24056($s0)
      sw $s4,24600($s0)
      sw $s4,25148($s0)
      sw $s4,21564($s0)
      sw $s4,22076($s0)
      sw $s4,21496($s0)
      sw $s4,22008($s0)
      sw $s4,22520($s0)
      sw $s4,24568($s0)
      sw $s4,25084($s0)
      sw $s4,25600($s0)
      sw $s4,26108($s0)
      sw $s4,26624($s0)
      sw $s4,27140($s0)
      sw $s4,27664($s0)
      sw $s4,21508($s0)
      sw $s4,22020($s0)
      sw $s4,23104($s0)
      sw $s4,24580($s0)
      sw $s4,25108($s0)
      sw $s4,25624($s0)
      sw $s4,26120($s0)
      sw $s4,26636($s0)
      sw $s4,27164($s0)
      sw $s4,27688($s0)
      sw $s4,21516($s0)
      sw $s4,22028($s0)
      sw $s4,23540($s0)
      sw $s4,24588($s0)
      sw $s4,25124($s0)
      sw $s4,25640($s0)
      sw $s4,26128($s0)
      sw $s4,26644($s0)
      sw $s4,27180($s0)
      sw $s4,21532($s0)
      sw $s4,22044($s0)
      sw $s4,24120($s0)
      sw $s4,24604($s0)
      sw $s4,26140($s0)
      sw $s4,21552($s0)
      sw $s4,22064($s0)
      sw $s4,26668($s0)
      sw $s4,24624($s0)
      sw $s4,26160($s0)
      sw $s4,21500($s0)
      sw $s4,22012($s0)
      sw $s4,22584($s0)
      sw $s4,24572($s0)
      sw $s4,25092($s0)
      sw $s4,25608($s0)
      sw $s4,26112($s0)
      sw $s4,26628($s0)
      sw $s4,27148($s0)
      sw $s4,27672($s0)
      sw $s4,21520($s0)
      sw $s4,22032($s0)
      sw $s4,23612($s0)
      sw $s4,24592($s0)
      sw $s4,25132($s0)
      sw $s4,25648($s0)
      sw $s4,26132($s0)
      sw $s4,26648($s0)
      sw $s4,27184($s0)
      sw $s4,21544($s0)
      sw $s4,22056($s0)
      sw $s4,26660($s0)
      sw $s4,24616($s0)
      sw $s4,26152($s0)
      sw $s4,21556($s0)
      sw $s4,22068($s0)
      sw $s4,26672($s0)
      sw $s4,24628($s0)
      sw $s4,26164($s0)
      sw $s4,21536($s0)
      sw $s4,22048($s0)
      sw $s4,24124($s0)
      sw $s4,24608($s0)
      sw $s4,26144($s0)
      sw $s4,21524($s0)
      sw $s4,22036($s0)
      sw $s4,24052($s0)
      sw $s4,24596($s0)
      sw $s4,25140($s0)
      sw $s4,25656($s0)
      sw $s4,26136($s0)
      sw $s4,26652($s0)
      sw $s4,24636($s0)
      sw $s4,21548($s0)
      sw $s4,22060($s0)
      sw $s4,26664($s0)
      sw $s4,24620($s0)
      sw $s4,26156($s0)
      sw $s4,21560($s0)
      sw $s4,22072($s0)
      sw $s4,26676($s0)
      sw $s4,24632($s0)
      sw $s4,26168($s0)
      sw $s4,21540($s0)
      sw $s4,22052($s0)
      sw $s4,26656($s0)
      sw $s4,24612($s0)
      sw $s4,26148($s0)
	  
	  #marrom Escuro
	  
      sw $s5,22572($s0)
      sw $s5,23084($s0)
      sw $s5,23596($s0)
      sw $s5,22528($s0)
      sw $s5,23040($s0)
      sw $s5,23552($s0)
      sw $s5,22524($s0)
      sw $s5,23036($s0)
      sw $s5,22536($s0)
      sw $s5,23048($s0)
      sw $s5,23560($s0)
      sw $s5,22548($s0)
      sw $s5,23060($s0)
      sw $s5,23572($s0)
      sw $s5,22564($s0)
      sw $s5,23076($s0)
      sw $s5,23588($s0)
      sw $s5,22544($s0)
      sw $s5,23056($s0)
      sw $s5,23568($s0)
      sw $s5,22556($s0)
      sw $s5,23068($s0)
      sw $s5,23580($s0)
      sw $s5,22560($s0)
      sw $s5,23072($s0)
      sw $s5,23584($s0)
      sw $s5,22576($s0)
      sw $s5,23088($s0)
      sw $s5,23600($s0)
      sw $s5,22532($s0)
      sw $s5,23044($s0)
      sw $s5,23556($s0)
      sw $s5,22580($s0)
      sw $s5,23092($s0)
      sw $s5,22540($s0)
      sw $s5,23052($s0)
      sw $s5,23564($s0)
      sw $s5,22552($s0)
      sw $s5,23064($s0)
      sw $s5,23576($s0)
      sw $s5,22568($s0)
      sw $s5,23080($s0)
      sw $s5,23592($s0)

#olhos azuis

	  sw $s6,10252($s0)
	  sw $s6,10256($s0)
	  sw $s6,10272($s0)
	  sw $s6,10276($s0)
	  
	  
# nariz

	  sw $s7,11800($s0)
	  sw $s7,11804($s0)
	  sw $s7,10244($s0)
	  sw $s7,10756($s0)
	  sw $s7,10284($s0)
	  sw $s7,10796($s0)
	  
#brincos laranja
	sw $t9,11776($s0)
        sw $t9,12288($s0)
        sw $t9,11824($s0)
        sw $t9,12336($s0)
	#branco
	sw $a0,36376($s0)
	sw $a0,36888($s0)

	
	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $s4,8($sp)
	lw $t2,12($sp)
	lw $t3,16($sp)
	lw $t4,20($sp)
	lw $t5,24($sp)
	lw $t6,28($sp)
	lw $t7,32($sp)
	lw $t8,36($sp)
	lw $t9,40($sp)
	lw $s1,44($sp)
	lw $s2,48($sp)
	lw $s3,52($sp)
	lw $s6,56($sp)
	lw $s7,60($sp)
	lw $a0,64($sp)
	addi $sp,$sp,68
	jr $ra
########################################
        
        
        
	.data
	espaco_display: .space 99232
	vetor_pos: .space 40
	vetor_estado: .space 40
