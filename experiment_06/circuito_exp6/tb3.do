onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 -radix decimal /jogo_desafio_memoria_tb3/caso
add wave -noupdate -height 30 -radix decimal /jogo_desafio_memoria_tb3/clockPeriod
add wave -noupdate -height 30 /jogo_desafio_memoria_tb3/clock_in
add wave -noupdate -divider Entradas
add wave -noupdate -color Red -height 30 /jogo_desafio_memoria_tb3/reset_in
add wave -noupdate -color Red -height 30 /jogo_desafio_memoria_tb3/jogar_in
add wave -noupdate -color Red -height 30 /jogo_desafio_memoria_tb3/botoes_in
add wave -noupdate -color Red -height 30 /jogo_desafio_memoria_tb3/nivel_in
add wave -noupdate -divider {Deteccao de jogada}
add wave -noupdate -color Gold -height 30 /jogo_desafio_memoria_tb3/db_tem_jogada_out
add wave -noupdate -color Magenta -height 30 /jogo_desafio_memoria_tb3/dut/FD/tem_jogada
add wave -noupdate -divider Resultado
add wave -noupdate -color Cyan -height 30 /jogo_desafio_memoria_tb3/ganhou_out
add wave -noupdate -color Cyan -height 30 /jogo_desafio_memoria_tb3/perdeu_out
add wave -noupdate -color Cyan -height 30 /jogo_desafio_memoria_tb3/pronto_out
add wave -noupdate -color Cyan -height 30 /jogo_desafio_memoria_tb3/leds_out
add wave -noupdate -divider Saidas
add wave -noupdate -color Coral -height 30 /jogo_desafio_memoria_tb3/db_igualE_out
add wave -noupdate -color Coral -height 30 /jogo_desafio_memoria_tb3/db_igualL_out
add wave -noupdate -color Coral -height 30 /jogo_desafio_memoria_tb3/db_nivel_out
add wave -noupdate -divider FD
add wave -noupdate -color Khaki -height 30 /jogo_desafio_memoria_tb3/dut/s_memoria
add wave -noupdate -color Khaki -height 30 /jogo_desafio_memoria_tb3/dut/FD/s_botoes
add wave -noupdate -color Khaki -height 30 -radix hexadecimal /jogo_desafio_memoria_tb3/dut/s_contagem
add wave -noupdate -divider UC
add wave -noupdate -color Magenta -height 30 -radix hexadecimal /jogo_desafio_memoria_tb3/dut/s_limite
add wave -noupdate -color Magenta -height 30 -radix hexadecimal /jogo_desafio_memoria_tb3/dut/UC/Eatual
add wave -noupdate -color Magenta -height 30 /jogo_desafio_memoria_tb3/db_contaL_out
add wave -noupdate -color Magenta -height 30 /jogo_desafio_memoria_tb3/db_timeout_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {227500000 ns} 0} {{Cursor 2} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 164
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2531375100 ns} {2758875100 ns}
