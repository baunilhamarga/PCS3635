/*
 * ------------------------------------------------------------------
 *  Arquivo   : circuito_exp2_ativ2-PARCIAL.v
 *  Projeto   : Experiencia 2 - Um Fluxo de Dados Simples
 * ------------------------------------------------------------------
 *  Descricao : Circuito PARCIAL do fluxo de dados da Atividade 2
 * 
 *     1) COMPLETAR DESCRICAO
 * 
 * ------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      11/01/2024  1.0     Edson Midorikawa  versao inicial
 * ------------------------------------------------------------------
 */

module circuito_exp2_desafio (clock, zera, carrega, conta, chaves, 
                            menor, maior, igual, fim, db_contagem);
    input        clock;
    input        zera;
    input        carrega;
    input        conta;
    input  [3:0] chaves;
    output       menor;
    output       maior;
    output       igual;
    output       fim;
    output [6:0] db_contagem;

    wire   [3:0] s_contagem;  // sinal interno para interligacao dos componentes

    // contador_163
    contador_163 contador (
      .clock( clock ),
      .clr  ( ~zera ), // feito por mim
      .ld   ( ~carrega ),
      .ent  ( 1'b1 ),
      .enp  ( conta ),
      .D    ( chaves ), // feito por mim
      .Q    ( s_contagem ),
      .rco  ( fim ) // feito por mim
    );

    // comparador_85
    comparador_85 comparador (
      .A   ( s_contagem ), // feito por mim
      .B   ( chaves ), // feito por mim
      .ALBi( 1'b0 ), // feito por mim
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo( menor ), // feito por mim
      .AGBo( maior ), // feito por mim
      .AEBo( igual ) // feito por mim
    );

    // hexa7seg
    hexa7seg hexa7segmentos (
      .hexa( s_contagem ), // feito por mim
      .display( db_contagem ) // feito por mim
    );

 endmodule
