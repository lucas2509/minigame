.text
	.globl Inicio
	
	Inicio: #display em 4,2,512,512
		jal Inicializar_vetorestado
		
		li $t0,0
		li $t1,10
		li $t3,0
		
		
		loop:
		slt $t2,$t0,$t1
		beq $t2,$zero,fim_inicio
		li $v0,32
		li $a0,1000
		syscall
		addi $t3,$t3,2000
		move $v0,$t3
		
		addi $sp,$sp,-12
		sw $t0,0($sp)
		sw $t1,4($sp)
		sw $t3,8($sp)
		jal Adicionar_maca
		jal Pintar_tela
		lw $t0,0($sp)
		lw $t1,4($sp)
		lw $t3,8($sp)
		addi $sp,$sp,12
			
		add $t0,$t0,1
		j loop
		fim_inicio:			
		

		
		
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
	Adicionar_maca: # Adiciona Maca no pixel em $v0
		li $t0,0
		li $t1,11		
		la $t2,vetor_estado
		la $t6,vetor_pos
		
		loop_addmaca:
		slt $t3,$t0,$t1
		beq $t3,$zero,fim_loop_addmaca
		lw $t4,0($t2)
		li $t3,0
		beq $t4,$t3,add_maca
		addi $t6,$t6,4
		addi $t2,$t2,4
		addi $t0,$t0,1
		j loop_addmaca
		
		add_maca:
		li $t5,1
		sw $t5,0($t2)
		sw $v0,0($t6)
		
		fim_loop_addmaca:
		jr $ra
	#####################################
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
		
	sw $t0,-2564($s0) #-2564 = 3160 - 5724 (referencia antinga - referencia do pixel central)
        sw $t0,-2560($s0)
        sw $t0,-2556($s0)
        sw $t0,-2552($s0)
        sw $t0,-2548($s0)
        sw $t0,-2052($s0)
        sw $t0,-2048($s0)
        sw $t0,-2044($s0)
        sw $t0,-2040($s0)
        sw $t0,-2036($s0)
        sw $t0,-1540($s0)
        sw $t0,-1536($s0)
        sw $t0,-1532($s0)
        sw $t0,-1528($s0)
        sw $t0,-1524($s0)
        sw $t0,-1028($s0)
        sw $t0,-1024($s0)
        sw $t0,-1020($s0)
        sw $t0,-1016($s0)
        sw $t0,-1012($s0)
        sw $t0,-516($s0)
        sw $t0,-512($s0)
        sw $t0,-508($s0)
        sw $t0,-504($s0)
        sw $t0,-500($s0)
        sw $t0,-4($s0)
        sw $t0,0($s0)
        sw $t0,4($s0)
        sw $t0,8($s0)
        sw $t0,12($s0)
        sw $t0,508($s0)
        sw $t0,512($s0)
        sw $t0,516($s0)
        sw $t0,520($s0)
        sw $t0,524($s0)
        sw $t0,1020($s0)
        sw $t0,1024($s0)
        sw $t0,1028($s0)
        sw $t0,1032($s0)
        sw $t0,1036($s0)
        sw $t0,1532($s0)
        sw $t0,1536($s0)
        sw $t0,1540($s0)
        sw $t0,1544($s0)
        sw $t0,1548($s0)
        sw $t0,2044($s0)
        sw $t0,2048($s0)
        sw $t0,2052($s0)
        sw $t0,2056($s0)
        sw $t0,2060($s0)
        sw $t0,-2544($s0)
        sw $t0,-2032($s0)
        sw $t0,-1520($s0)
        sw $t0,-1008($s0)
        sw $t0,-496($s0)
        sw $t0,16($s0)
        sw $t0,528($s0)
        sw $t0,1040($s0)
        sw $t0,1552($s0)
        sw $t0,-2028($s0)
        sw $t0,-1516($s0)
        sw $t0,-1004($s0)
        sw $t0,-492($s0)
        sw $t0,20($s0)
        sw $t0,532($s0)
        sw $t0,1044($s0)
        sw $t0,1556($s0)
        sw $t0,-1512($s0)
        sw $t0,-1000($s0)
        sw $t0,-488($s0)
        sw $t0,24($s0)
        sw $t0,536($s0)
        sw $t0,1048($s0)
        sw $t0,-996($s0)
        sw $t0,-484($s0)
        sw $t0,28($s0)
        sw $t0,540($s0)
        sw $t0,-2568($s0)
        sw $t0,-2056($s0)
        sw $t0,-1544($s0)
        sw $t0,-520($s0)
        sw $t0,-8($s0)
        sw $t0,504($s0)
        sw $t0,1016($s0)
        sw $t0,1528($s0)
        sw $t0,2040($s0)
        sw $t0,-536($s0)
        sw $t0,-532($s0)
        sw $t0,-528($s0)
        sw $t0,-524($s0)
        sw $t0,-24($s0)
        sw $t0,-20($s0)
        sw $t0,-16($s0)
        sw $t0,-12($s0)
        sw $t0,488($s0)
        sw $t0,492($s0)
        sw $t0,496($s0)
        sw $t0,500($s0)
        sw $t0,1004($s0)
        sw $t0,1008($s0)
        sw $t0,1012($s0)
        sw $t0,1520($s0)
        sw $t0,1524($s0)
        sw $t0,-1048($s0)
        sw $t0,-1044($s0)
        sw $t0,-1040($s0)
        sw $t0,-1556($s0)
        sw $t0,-1552($s0)
        sw $t0,-2064($s0)
        sw $t0,-2060($s0)

        sw $t1,-4096($s0)
        sw $t1,-3584($s0)
        sw $t1,-3072($s0)

        sw $t2,-4092($s0)
        sw $t2,-4088($s0)
        sw $t2,-4084($s0)

        sw $t3,-3572($s0)

        sw $t4,-4600($s0)

        sw $t5,-1548($s0)
        sw $t5,-1036($s0)
        sw $t5,-1032($s0)
        
        
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
	vetor_pos: .space 40
	vetor_estado: .space 40
	teste: .asciiz "dfaijdfoaij"
	prompt2: .asciiz " "
	prompt3: .asciiz " O vetor de posicao esta na seguinte configuracao: "
	prompt1: .asciiz "O vetor de estado esta na seguinte configuracao: "
	passou: .asciiz " Passou aqui... "
