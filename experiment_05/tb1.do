onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 35 /circuito_exp5_tb1/clockPeriod
add wave -noupdate -height 35 /circuito_exp5_tb1/clock_in
add wave -noupdate -height 35 /circuito_exp5_tb1/reset_in
add wave -noupdate -height 35 /circuito_exp5_tb1/jogar_in
add wave -noupdate -height 35 /circuito_exp5_tb1/botoes_in
add wave -noupdate -height 35 /circuito_exp5_tb1/acertou_out
add wave -noupdate -height 35 /circuito_exp5_tb1/errou_out
add wave -noupdate -height 35 /circuito_exp5_tb1/pronto_out
add wave -noupdate -height 35 /circuito_exp5_tb1/leds_out
add wave -noupdate -height 35 /circuito_exp5_tb1/db_igualE_out
add wave -noupdate -height 35 /circuito_exp5_tb1/db_igualL_out
add wave -noupdate -height 35 /circuito_exp5_tb1/db_contagem_out
add wave -noupdate -height 35 /circuito_exp5_tb1/db_memoria_out
add wave -noupdate -height 35 /circuito_exp5_tb1/db_estado_out
add wave -noupdate -height 35 /circuito_exp5_tb1/db_jogadafeita_out
add wave -noupdate -height 35 /circuito_exp5_tb1/db_clock_out
add wave -noupdate -height 35 /circuito_exp5_tb1/db_tem_jogada_out
add wave -noupdate -height 35 /circuito_exp5_tb1/db_timeout_out
add wave -noupdate -height 35 /circuito_exp5_tb1/db_contaL_out
add wave -noupdate -height 35 /circuito_exp5_tb1/db_limite_out
add wave -noupdate -height 35 /circuito_exp5_tb1/caso
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {49000000 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ns} {90152348 ns}
