org 0x7e00
jmp 0x0000:start

;pesquisas geradas

data:
  ;Valores normais
  inc_CAC dw 5 
  inc_AREAII dw 10
  inc_CCEN dw 30 
  inc_CCS dw 70 
  inc_CIn dw 150 

  ;Diminuem o delay
  inc_teatro_CAC dw 
  inc_sapos_CCS dw
  inc_NERDS_CIn dw
  inc_compt_CIn dw
  inc_plantas_CAC dw
  inc_camara_CCEN dw

  ;Aumenta o numero de pesquisas

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ax,13h
    

jmp $
