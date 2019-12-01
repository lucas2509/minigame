.text
	.globl Inicio
	Inicio:
		#Para ativar o display ir em Tools->Bitmap Display
		#Qualquer alteracao no display, o mars já plota diretamente os pixels
		#Configurar o bitmap Display em 16,15,512,512 base de endereço em $gp
		
		li $t0,0xffffffff #carrega a cor zero para o registrador $t0
		sw $t0,0($gp)     #Carrega a cor zero na posicao 0 da memoria $gp
		sw $t0,132($gp)     #Carrega a cor zero na posicao 0 da memoria $gp
		sw $t0,264($gp)    #Carrega a cor zero na posicao 0 da memoria $gp
		
		addi $v0,$zero,10 
		syscall	