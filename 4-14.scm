#lang racket

; map関数は、関数とリストをうけとって
; リストに関数を適用していくやつ。
; http://www.billthelizard.com/2011/01/sicp-221-223-mapping-over-lists.html
; mapは中でapplyを呼んでるんだけど、これは環境が必要なので
; システムのmapをそのまま使うと環境が使われずにだめになるんじゃないかな。

; http://community.schemewiki.org/?sicp-ex-4.14
; https://sicp-study.g.hatena.ne.jp/papamitra/20070704/sicp_ex4_14
; それ以前の問題だった

