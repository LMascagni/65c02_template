  .org $8000

message_ready:	.asciiz "  -  pronto  -  "

message1: .asciiz "1"
message2: .asciiz "2"

reset:
  ;setup
   
  jsr lcd_init

  lda #<message_ready
  sta MESSAGE_PTR
  lda #>message_ready 
  sta MESSAGE_PTR + 1
  jsr print_message  

  lda DDRA
  ora #%1
  sta DDRA

loop:
  ;main loop

  lda #%00000001
  jsr lcd_send_instruction

  lda #<message1
  sta MESSAGE_PTR
  lda #>message1 
  sta MESSAGE_PTR + 1
  jsr print_message

  lda #$E8
  sta time_delay_millis
  lda #$03
  sta time_delay_millis + 1
  jsr delay_millis

  lda #%00000001
  jsr lcd_send_instruction

  lda #<message2
  sta MESSAGE_PTR
  lda #>message2 
  sta MESSAGE_PTR + 1
  jsr print_message

  lda #$E8
  sta time_delay_millis
  lda #$03
  sta time_delay_millis + 1
  jsr delay_millis

  jmp loop


nmi:
irq:
  ;interrupt function
  rti


;libraries
  .include "lib/time.s"
  .include "lib/io.s"
  .include "lib/lcd.s"

  .org $fffa
  .word nmi
  .word reset
  .word irq
