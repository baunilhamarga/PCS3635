onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 -radix decimal /jogo_playseq_tb1/caso
add wave -noupdate -divider Entradas
add wave -noupdate -height 30 /jogo_playseq_tb1/clock_in
add wave -noupdate -color Red -height 30 /jogo_playseq_tb1/reset_in
add wave -noupdate -color Red -height 30 /jogo_playseq_tb1/jogar_in
add wave -noupdate -color Red -height 30 /jogo_playseq_tb1/botoes_in
add wave -noupdate -color Red -height 30 /jogo_playseq_tb1/memoria_in
add wave -noupdate -divider {Deteccao de jogada}
add wave -noupdate -color Magenta -height 30 /jogo_playseq_tb1/dut/FD/tem_jogada
add wave -noupdate -divider Resultado
add wave -noupdate -color Cyan -height 30 /jogo_playseq_tb1/ganhou_out
add wave -noupdate -color Cyan -height 30 /jogo_playseq_tb1/perdeu_out
add wave -noupdate -divider Saidas
add wave -noupdate -color {Medium Orchid} -height 30 /jogo_playseq_tb1/leds_out
add wave -noupdate -divider FD
add wave -noupdate -color Khaki -height 30 /jogo_playseq_tb1/dut/s_memoria
add wave -noupdate -color Khaki -height 30 /jogo_playseq_tb1/dut/FD/s_botoes
add wave -noupdate -color Khaki -height 30 -radix hexadecimal /jogo_playseq_tb1/dut/s_contagem
add wave -noupdate -color Khaki -height 30 /jogo_playseq_tb1/dut/FD/s_sequencia
add wave -noupdate -color Khaki -height 30 /jogo_playseq_tb1/dut/FD/buzzer
add wave -noupdate -divider UC
add wave -noupdate -height 30 -radix ascii /jogo_playseq_tb1/dut/UC/Eatual_str
add wave -noupdate -color {Pale Green} /jogo_playseq_tb1/dut/UC/controla_leds
add wave -noupdate -divider Buzzer
add wave -noupdate -color Gold -radix decimal /jogo_playseq_tb1/dut/FD/tone_freq
add wave -noupdate -color Gold -radix decimal /jogo_playseq_tb1/dut/FD/buzzer_inst/freq
add wave -noupdate -color Gold /jogo_playseq_tb1/dut/FD/buzzer_inst/out
add wave -noupdate -color Gold -radix decimal /jogo_playseq_tb1/dut/FD/buzzer_inst/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16034000000 ns} 0} {{Cursor 2} {83786116740 ns} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ns} {6072554539 ns}
