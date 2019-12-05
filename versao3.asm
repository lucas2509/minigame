.text
	.globl Inicio
	
	Inicio: #display em 4,2,512,512		
		li $v0,80000
		li $v1,1
		jal Adicionar_frutas
		
		li $t0,0
		li $t1,1000
		
		loop_inicio:
		slt $t2,$t0,$t1
		beq $t2,$zero,fim_loop_inicio
		li $a0,10
		li $v0,32
		syscall
		
		addi $sp,$sp,-8
		sw $t0,0($sp)
		sw $t1,4($sp)
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
	Confronto_chao:
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
		
		cont1_loop_confronto:		
		addi $t0,$t0,1
		addi $t2,$t2,4
		addi $t3,$t3,4
		j loop_confronto
		fim_loop_confronto:
		
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
		
		addi $t0,$t0,1
		addi $t2,$t2,4
		addi $t3,$t3,4
		j loop_apagfrutas
		fim_loop_apagfrutas:
		
		lw $ra,0($sp)
		addi $sp,$sp,4
		jr  $ra
################################################
	Apagar_tela:
		li $t0,0x00000000
		move $t1,$gp
		addi $t2,$t1,131072
		
		loop_apagatela:
		slt $t3,$t1,$t2
		beq $t3,$zero,desvia_loop_apagatela
		sw $t0,0($t1)
		addi $t1,$t1,4
		j loop_apagatela
		desvia_loop_apagatela:		
		
		jr $ra
		
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
	
	li $t0,0x000000 #vermelho  
	li $t1,0x000000 #marrom  
	li $t2,0x000000 #verde  
	li $t3,0x000000 #verde escuro  
	li $t4,0x000000 #verde claro 
	li $t5,0x000000 #gelo 
	li $t6,0x000000	#amarelo
	li $t7,0x000000 #preto	
	li $t8,0x000000 #cinza	
	li $t9,0x000000 #laranja
	li $s1,0x000000 #marrom escuro
				
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
	.data
	espaco_display: .space 99232
	vetor_pos: .space 40
	vetor_estado: .space 40
	teste: .asciiz "dfaijdfoaij"
	prompt2: .asciiz " "
	prompt3: .asciiz " O vetor de posicao esta na seguinte configuracao: "
	prompt1: .asciiz "O vetor de estado esta na seguinte configuracao: "
	passou: .asciiz " Passou aqui... "
