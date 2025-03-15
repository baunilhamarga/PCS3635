onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 -radix decimal /jogo_playseq_tb2/caso
add wave -noupdate -divider Entradas
add wave -noupdate -height 30 /jogo_playseq_tb2/clock_in
add wave -noupdate -color Red -height 30 /jogo_playseq_tb2/reset_in
add wave -noupdate -color Red -height 30 /jogo_playseq_tb2/jogar_in
add wave -noupdate -color Red -height 30 /jogo_playseq_tb2/botoes_in
add wave -noupdate -color Red -height 30 /jogo_playseq_tb2/memoria_in
add wave -noupdate -divider {Deteccao de jogada}
add wave -noupdate -color Magenta -height 30 /jogo_playseq_tb2/dut/FD/tem_jogada
add wave -noupdate -divider Resultado
add wave -noupdate -color Cyan -height 30 /jogo_playseq_tb2/ganhou_out
add wave -noupdate -color Cyan -height 30 /jogo_playseq_tb2/perdeu_out
add wave -noupdate -color Cyan -height 30 /jogo_playseq_tb2/pronto_out
add wave -noupdate -divider Saidas
add wave -noupdate -color {Medium Orchid} -height 30 /jogo_playseq_tb2/leds_out
add wave -noupdate -divider FD
add wave -noupdate -color Khaki -height 30 /jogo_playseq_tb2/dut/s_memoria
add wave -noupdate -color Khaki -height 30 /jogo_playseq_tb2/dut/FD/s_botoes
add wave -noupdate -color Khaki -height 30 -radix hexadecimal /jogo_playseq_tb2/dut/s_contagem
add wave -noupdate -color Khaki -height 30 /jogo_playseq_tb2/dut/FD/s_sequencia
add wave -noupdate -divider UC
add wave -noupdate -radix ascii -height 30 /jogo_playseq_tb2/dut/UC/Eatual_str
add wave -noupdate -color {Pale Green} /jogo_playseq_tb2/dut/UC/controla_leds
add wave -noupdate -divider Depuracao
add wave -noupdate -color Blue -height 30 /jogo_playseq_tb2/db_chavesIgualMemoria_out
add wave -noupdate -color Blue -height 30 /jogo_playseq_tb2/db_enderecoIgualSequencia_out
add wave -noupdate -color Blue -height 30 /jogo_playseq_tb2/db_fimS_out
add wave -noupdate -color Blue -height 30 /jogo_playseq_tb2/db_seletor_memoria_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {146529500000 ns} 0} {{Cursor 2} {296203174716 ns} 0}
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
WaveRestoreZoom {143874748658 ns} {149188051737 ns}
