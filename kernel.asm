org 0x8600
jmp 0x0000:start
data:
  ;Teste do contador
  valor_seg times 20 db 0
  instrucao1 db 'segundos: ', 0
  zero_str db '0', 0
  erro_ne db 'Nao houve pesquisas suficientes', 0
  erro_cantbuy db 'Nao pode mais comprar esse', 0
  pesps db 'p/seg'

  ;Unidades de numero
  counter dw 0
  counter2 dw 0
  counter3 dw 0 
  counter4 dw 0
  melhoria_click dw 1
  ;Valores normais
  CAC db 'CAC: '
  inc_CAC dw 2 
  inc_value_CAC dw 10
  inc_qt_CAC dw 10
  flag_CAC dw 0

  AREAII db 'AREAII: ', 0
  inc_AREAII dw 5 
  inc_value_AREAII dw 4500
  inc_qt_AREAII dw 8
  flag_AREAII dw 0

  CCEN db 'CCEN: ', 0
  inc_CCEN dw 13
  inc_value_CCEN dw 9572
  inc_qt_CCEN dw 6
  flag_CCEN dw 0

  CCS db 'CCS: ', 0
  inc_CCS dw 27
  inc_value_CCS dw 17000 
  inc_qt_CCS dw 5
  flag_CCS dw 0

  CIn db 'CIn: ', 0
  inc_CIn dw 49
  inc_value_CIn dw 23000 
  inc_qt_CIn dw 4
  flag_CIn dw 0

  money equ 0
  um equ 1

;------- LIBRARY
print_zero:
  mov si,zero_str
  call prints
  ret
  reverse:              ; mov si, string
    mov di, si
    xor cx, cx          ; zerar contador
    .loop1:             ; botar string na stack
      lodsb
      cmp al, 0
      je .endloop1
      inc cl
      push ax
      jmp .loop1
    .endloop1:
    .loop2:             ; remover string da stack        
      pop ax
      stosb
      loop .loop2
    ret

  tostring:              ; mov ax, int / mov di, string
    push di
    .loop1:
      cmp ax, 0
      je .endloop1
      xor dx, dx
      mov bx, 10
      div bx            ; ax = 9999 -> ax = 999, dx = 9
      xchg ax, dx       ; swap ax, dx
      add ax, 48        ; 9 + '0' = '9'
      stosb
      xchg ax, dx
      jmp .loop1
    .endloop1:
    pop si
    cmp si, di
    jne .done
    mov al, 48
    stosb
    .done:
    mov al, 0
    stosb
    call reverse
    ret

  putchar:
    mov ah, 0x0e
    int 10h
    ret

  prints:             ; mov si, string
    .loop:
      lodsb           ; bota character em al 
      cmp al, 0
      je .endloop
      call putchar
      jmp .loop
    .endloop:
    ret

  endl:
    mov al, 0x0a          ; line feed
    call putchar
    mov al, 0x0d          ; carriage return
    call putchar
    ret

  delay100ms:              ; 0.1 SEC DELAY
    mov cx, 01h
    mov dx, 86a0h
    mov ah, 86h
    int 15h
    ret

  delay:              
    mov cx, 01h
    mov dx, 0D76h
    mov ah, 86h
    int 15h
    ret
imprimir_numero: ; Coloca o numero em cx

  push ax
  cmp cx,10000 
  jge end_pz
  call print_zero
  cmp cx,1000
  jge end_pz
  call print_zero
  cmp cx,100
  jge end_pz
  call print_zero
  cmp cx,10
  jge end_pz
  call print_zero
  end_pz:
  mov ax,cx
  mov di,valor_seg
  call tostring
  mov si,valor_seg
  call prints
  pop ax 
  ret
incremente_counter:

  mov ax,[counter]
  cmp ax,9999
  jge counter_2f
  jmp end_1

  counter_2f:
    mov ax,0
    mov [counter],ax
    push ax
    mov ax,[counter2]
    inc ax
    cmp ax,9999
    mov [counter2],ax
    pop ax
    je counter_3f
    jmp end_1
  counter_3f:
    mov [counter2],ax
    push ax
    mov ax,[counter3]
    inc ax
    cmp ax,9999
    mov [counter3],ax
    pop ax
    je counter_4f
    jmp end_1
  counter_4f:
    mov [counter3],ax
    push ax
    mov ax,[counter4]
    inc ax
    cmp ax,9999
    mov [counter4],ax
    pop ax
  end_1:
  ret
get_click:
  push ax
  push bx
  push cx
  mov ah,1
  int 16h
  jz not_pressed  ; Verifica se tem algum botao sendo pressionado
  mov ah,0
  int 16h

  cmp al,32 ; Se tiver algum, verifica se é o espaco
  je pressed_space 

  cmp al,98
  je pressed_buy

  jmp not_pressed ; Caso nenhuma das teclas seja a correta

  pressed_space:  
    call aumentar_pesquisas_clique
    jmp not_pressed

  pressed_buy:
    call buy
    jmp not_pressed 

  not_pressed: ; Se nao, ele continua a execucao do código
    pop cx
    pop bx
    pop ax
  after_pop:
    ret
aumentar_pesquisas_clique:
  push bx
  push ax

  mov ax,[counter]
  add ax,[melhoria_click]
  mov [counter],ax
  call incremente_counter
  ; print
  pop ax
  pop bx
  ret

compare: ; flag em dx =, 1 foi suficiente
  mov dx,[counter]
  cmp ax,dx
  jg notenough
  ; se tem pesquisas suficientes
  sub dx,ax
  mov [counter],dx
  add ax,ax
  ; valor de incremento
  push cx
  mov cx,[melhoria_click]
  add cx,bx
  mov [melhoria_click],cx
  add bx,bx
  ; valor de decremento
  pop cx
  dec cx
  mov dx,0
  jmp end_9
  ; se nao
  notenough:
    mov dx,1
    mov si,erro_ne
    call prints 
  end_9:
  ret

buy:
  push ax
  push bx
  push cx
  push dx

  mov ax,[counter2]
  mov di,valor_seg
  call tostring
  mov si,valor_seg
  call prints

  mov ah,0
  int 16h
  mov cl,al


  cmp cl,107  
  je  m_5
  cmp cl,103
  je m_2 
  cmp cl,104
  je m_3
  cmp cl,106
  je m_4
  cmp cl,102
  jne pop_all 

  m_1:
    mov bx,[inc_CAC]
    mov ax,[inc_value_CAC]
    mov cx,[inc_qt_CAC]
    cmp cx,0 ; Caso chegue ao limite de itens, ele nao pode mais comprar
    je cant_buy_more
    call compare ; Chama a funcao que compara as pesquisas e compra blocos
    cmp dx,1
    je pop_all
    mov [inc_value_CAC],ax
    mov [inc_CAC],bx
    mov [inc_qt_CAC],cx
    mov dx,1
    mov [flag_CAC],dx
    jmp pop_all
  m_2:
    mov bx,[inc_AREAII]
    mov ax,[inc_value_AREAII]
    mov cx,[inc_qt_AREAII]
    cmp cx,0
    je cant_buy_more
    call compare
    cmp dx,1
    je pop_all
    mov [inc_value_AREAII],ax
    mov [inc_AREAII],bx
    mov [inc_qt_AREAII],cx
    mov dx,1
    mov [flag_AREAII],dx
    jmp pop_all
    jmp pop_all
  m_3:
    mov bx,[inc_CCEN]
    mov ax,[inc_value_CCEN]
    mov cx,[inc_qt_CCEN]
    cmp cx,0
    je cant_buy_more
    call compare
    cmp dx,1
    je pop_all
    mov [inc_value_CCEN],ax
    mov [inc_CCEN],bx
    mov [inc_qt_CCEN],cx
    mov dx,1
    mov [flag_CCEN],dx
    jmp pop_all
  m_4:
    mov bx,[inc_CCS]
    mov ax,[inc_value_CCS]
    mov cx,[inc_qt_CCS]
    cmp cx,0
    je cant_buy_more
    call compare
    cmp dx,1
    je pop_all
    mov [inc_value_CCS],ax
    mov [inc_CCS],bx
    mov [inc_qt_CCS],cx
    mov dx,1
    mov [flag_CCS],dx
    jmp pop_all
  m_5:
    mov bx,[inc_CIn]
    mov ax,[inc_value_CIn]
    mov cx,[inc_qt_CIn]
    cmp cx,0
    je cant_buy_more
    call compare
    cmp dx,1
    je pop_all
    mov [inc_value_CIn],ax
    mov [inc_CIn],ax
    mov [inc_qt_CIn],cx
    mov dx,1
    mov [flag_CIn],dx
    jmp pop_all

  cant_buy_more:
    mov si,erro_cantbuy
    call prints
  pop_all:
    pop dx
    pop cx
    pop bx
    pop ax
  ret

bought:
  ; Empilhando:
  push ax
  push dx
  mov dx,[flag_CIn]
  push dx
  mov dx,[flag_CCS]
  push dx
  mov dx,[flag_CCEN]
  push dx
  mov dx,[flag_AREAII]
  push dx
  mov dx,[flag_CAC]
  push dx

  print1:
    pop dx ; Verifica a flag
    cmp dx,1
    jne print2
    ; Aqui printa o que ja foi comprado
    mov si,CAC
    call prints
    mov ax,[inc_CAC]
    mov di,valor_seg
    call tostring
    mov si,valor_seg
    call prints
    mov si,pesps
    call prints
    call endl
  print2:
    pop dx
    cmp dx,1
    jne print3
    mov si,AREAII
    call prints
    mov ax,[inc_AREAII]
    mov di,valor_seg
    call tostring
    mov si,valor_seg
    call prints
    mov si,pesps
    call prints
    call endl
  print3:
    pop dx
    cmp dx,1
    jne print4
    mov si,CCEN
    call prints
    mov ax,[inc_CCEN]
    mov di,valor_seg
    call tostring
    mov si,valor_seg
    call prints
    mov si,pesps
    call prints
    call endl
  print4:
    pop dx
    cmp dx,1
    jne print5
    mov si,CCS
    call prints
    mov ax,[inc_CCS]
    mov di,valor_seg
    call tostring
    mov si,valor_seg
    call prints
    mov si,pesps
    call prints
    call endl
  print5:
    pop dx
    cmp dx,1
    jne pop_
    mov ax,[inc_CIn]
    mov di,valor_seg
  pop_:
    pop dx
    pop ax
  ret
start:
  xor ax, ax
  mov cx, ax
  mov bx, ax
  mov es, ax
  mov ds, ax
  mov dx, ax

  loopcounter:
    ; push ax                                  
    call delay                               
    ;pop ax                                   
    inc bx ; OU add bx, dx              
    call get_click ; Pega informacao do aperto de botoes
    mov cx, 10                                
    cmp bx, cx                                
    je game ; Atualiza game a cada segundo                                  
    jne continue 
                                
      ; ---------------- GAME MECHANICS CODE             
    continue:
      jmp loopcounter 
  ; --------------------------- Framecounter ENDs

    game:
      ; ---------- REINICIA TELA E PRINTA SEG
      call aumentar_pesquisas_clique
      inc ax

      push ax
      xor ax, ax
      mov ah, 0x0   ;setando o ah para especificar a prox interrupção
      int 10h       ;interrupção para limpar o terminal (não ficar printando várias linhas a mesma coisa)

      pop ax
      ; ---------- REINICIA TELA E PRINTA SEG
      
      push ax
      ; ---------- GAME SCREEN
      ; Printando valor
      call bought
      call aumentar_pesquisas_clique
      ; mov cx,[counter4]
      ;  call imprimir_numero
      ; mov cx,[counter3]
      ;  call imprimir_numero
      push ax
      mov cx,[counter4]
       call imprimir_numero
      mov cx,[counter3]
       call imprimir_numero
      mov cx,[counter2]
       call imprimir_numero
      mov cx,[counter]
       call imprimir_numero
       pop ax
      ; ;mov di, valor_seg
      ; call tostring
      ; mov si, valor_seg
      ; call prints
      call endl

      pop ax
      xor bx, bx 
      jmp loopcounter
  ; ------------------------- Game Loop END

jmp 0x7e00