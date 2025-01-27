onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 35 /circuito_exp4_desafio_tb3/caso
add wave -noupdate -height 35 /circuito_exp4_desafio_tb3/clock_in
add wave -noupdate -divider Entradas
add wave -noupdate -color Red -height 35 /circuito_exp4_desafio_tb3/reset_in
add wave -noupdate -color Red -height 35 /circuito_exp4_desafio_tb3/iniciar_in
add wave -noupdate -color Red -height 35 /circuito_exp4_desafio_tb3/chaves_in
add wave -noupdate -divider {Detecao da Jogada}
add wave -noupdate -color Yellow -height 35 /circuito_exp4_desafio_tb3/db_tem_jogada_out
add wave -noupdate -color Yellow -height 35 /circuito_exp4_desafio_tb3/dut/s_jogada
add wave -noupdate -divider Depuracao
add wave -noupdate -color {Orange Red} -height 35 /circuito_exp4_desafio_tb3/db_igual_out
add wave -noupdate -divider Resultado
add wave -noupdate -color Cyan -height 35 /circuito_exp4_desafio_tb3/acertou_out
add wave -noupdate -color Cyan -height 35 /circuito_exp4_desafio_tb3/errou_out
add wave -noupdate -color Cyan -height 35 /circuito_exp4_desafio_tb3/pronto_out
add wave -noupdate -color Cyan -height 35 /circuito_exp4_desafio_tb3/db_timeout_out
add wave -noupdate -divider Saidas
add wave -noupdate -color Coral -height 35 /circuito_exp4_desafio_tb3/leds_out
add wave -noupdate -divider FD
add wave -noupdate -color {Pale Green} -height 35 /circuito_exp4_desafio_tb3/dut/s_contagem
add wave -noupdate -color {Pale Green} -height 35 /circuito_exp4_desafio_tb3/dut/s_memoria
add wave -noupdate -divider UC
add wave -noupdate -color Gray80 -height 35 /circuito_exp4_desafio_tb3/dut/s_estado
add wave -noupdate -color Gray80 -height 35 /circuito_exp4_desafio_tb3/dut/s_zeraC
add wave -noupdate -color Gray80 -height 35 /circuito_exp4_desafio_tb3/dut/s_contaC
add wave -noupdate -color Gray80 -height 35 /circuito_exp4_desafio_tb3/dut/s_zeraR
add wave -noupdate -color Gray80 -height 35 /circuito_exp4_desafio_tb3/dut/s_registraR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {205 ns} 0}
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
WaveRestoreZoom {0 ns} {1 us}
