.text

	.globl Inicio
	#Lucas William Marques dos Santos - 92426 - Turma AOC Noturno
	#Codigo em assembly do jogo da cesta
	
	Inicio: #Configurar o display bitmap como 16,16,512,512 e base dos pixels em $gp
		#Cada pixel ocupa 4bytes sendo necessario então iterar a posicao de 4 em quatro bytes
		#Uma linha possui 124 bytes ou seja 32 pixels		
		
				
		li $s0,0
		la $s1,buffer_pos
		la $s2,buffer_cor
		la $s3,buffer_estado
		
		jal Adicionar_bloco
		jal Adicionar_bloco
		j Rodar_jogo
		
		
		addi $v0,$zero,10 #Chamada pra encerrar o programa
		syscall		  #chamada para encerrar o programa
				
	Adicionar_bloco:
		addi $s0,$s0,1		
		li $t0,-1
		li $t1,10
		
		iteracao_addbloco:
		addi $t0,$t0,1
		slt $t2,$s0,$t1
		beq $t2,$zero,fim_addbloco
		sll $t2,$t0,2
		add $t2,$t2,$s3
		lw  $t2,0($t2)
		li $t3,1
		beq $t2,$t3,iteracao_addbloco		
		sll $t0,$t0,2
		move $t3,$t0		
				
		li $a0,100
		li $a1,32
		li $v0,42
		syscall
					
		
		sll $t0,$a0,2
		add $t0,$t0,$gp
		li $t1,0xff00ffff # Atribui a cor branca ao registrado $t0
		li $t2,1
		add $t4,$t3,$s1
		add $t5,$t3,$s2	
		add $t6,$t3,$s3			
		sw $t0,0($t4)   # Pinta o pixel da pos 128 com a cor do registrador t0
		sw $t1,0($t5)
		sw $t2,0($t6)
		
		fim_addbloco:
		jr $ra
	Pintar_tela_preta:
		li $t0,0x00000000		
		move $t1,$gp
		addi $t2,$t1,16380
		
		
		iterar_tpreta:
		slt $t3,$t1,$t2
		beq $t3,$zero,finaliza_tpreta
		sw $t0,0($t1)
		addi $t1,$t1,4
		j iterar_tpreta
		
		finaliza_tpreta:
		jr $ra
		
		
	Pintar_jogo:
		li $a0,100
		li $v0,32
		syscall
		
		li $t0,-1
		li $t1,10
		
		iteracao:
		addi $t0,$t0,1
		slt $t2,$t0,$t1
		beq $t2,$zero,finaliza
		sll $t2,$t0,2
		add $t2,$t2,$s3
		lw  $t2,0($t2)
		li $t3,1
		bne $t2,$t3,iteracao
		sll $t2,$t0,2
		add $t2,$t2,$s2
		lw $t2,0($t2)
		sll $t3,$t0,2
		add $t3,$t3,$s1
		lw $t3,0($t3)
		
		sw $t2,0($t3)
		j iteracao	
		
		finaliza:
		jr $ra
		
	Rodar_jogo:
		li $a0,500
		li $v0,32
		syscall
		
		li $t0,-1
		li $t1,10
		
		iteracao2:
		addi $t0,$t0,1
		slt $t2,$t0,$t1
		beq $t2,$zero,finaliza
		sll $t2,$t0,2
		add $t2,$t2,$s3
		lw  $t2,0($t2)
		li $t3,1
		bne $t2,$t3,iteracao2
		descer_linha:
		sll $t3,$t0,2
		add $t3,$t3,$s1
		lw $t2,0($t3)
		addi $t2,$t2,128
		sw $t2,0($t3)
		
		jal Pintar_tela_preta
		jal Pintar_jogo
		j Rodar_jogo
		
		
	
		
	
	.data
	buffer_pos: .space 40  #Buffer 1 contem a string a ser criptografada
	buffer_cor: .space 40 #Buffer 2 ira conter a string ja criptografada
	buffer_estado: .space 40

	
