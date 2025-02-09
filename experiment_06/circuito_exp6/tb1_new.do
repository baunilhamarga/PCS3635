onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 -radix decimal /jogo_desafio_memoria_tb1/caso
add wave -noupdate -divider Entradas
add wave -noupdate -height 30 /jogo_desafio_memoria_tb1/clock_in
add wave -noupdate -color Red -height 30 /jogo_desafio_memoria_tb1/reset_in
add wave -noupdate -color Red -height 30 /jogo_desafio_memoria_tb1/jogar_in
add wave -noupdate -color Red -height 30 /jogo_desafio_memoria_tb1/botoes_in
add wave -noupdate -divider {Deteccao de jogada}
add wave -noupdate -color Magenta -height 30 /jogo_desafio_memoria_tb1/dut/FD/tem_jogada
add wave -noupdate -divider Resultado
add wave -noupdate -color Cyan -height 30 /jogo_desafio_memoria_tb1/ganhou_out
add wave -noupdate -color Cyan -height 30 /jogo_desafio_memoria_tb1/perdeu_out
add wave -noupdate -color Cyan -height 30 /jogo_desafio_memoria_tb1/pronto_out
add wave -noupdate -divider Saidas
add wave -noupdate -color Cyan /jogo_desafio_memoria_tb1/db_timeout_out
add wave -noupdate -color Cyan /jogo_desafio_memoria_tb1/db_timeoutL_out
add wave -noupdate -color Cyan -height 30 /jogo_desafio_memoria_tb1/leds_out
add wave -noupdate -divider FD
add wave -noupdate -color Khaki -height 30 /jogo_desafio_memoria_tb1/dut/s_memoria
add wave -noupdate -color Khaki -height 30 /jogo_desafio_memoria_tb1/dut/FD/s_botoes
add wave -noupdate -color Khaki -height 30 -radix hexadecimal /jogo_desafio_memoria_tb1/dut/s_contagem
add wave -noupdate -color Khaki /jogo_desafio_memoria_tb1/dut/FD/s_sequencia
add wave -noupdate -divider UC
add wave -noupdate -radix ascii /jogo_desafio_memoria_tb1/dut/UC/Eatual_str
add wave -noupdate -color {Pale Green} /jogo_desafio_memoria_tb1/dut/UC/controla_leds
add wave -noupdate -divider Depuracao
add wave -noupdate -color Blue /jogo_desafio_memoria_tb1/db_chavesIgualMemoria_out
add wave -noupdate -color Blue /jogo_desafio_memoria_tb1/db_enderecoIgualSequencia_out
add wave -noupdate -color Blue /jogo_desafio_memoria_tb1/db_fimS_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {129914000000 ns} 0} {{Cursor 2} {145914000000 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 166
configure wave -valuecolwidth 98
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
configure wave -timelineunits ms
update
WaveRestoreZoom {128078110341 ns} {147732205772 ns}
