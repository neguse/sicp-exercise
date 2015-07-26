#lang racket

; 手続き版
; factorial 6 -> factorial 5 -> factorial 4 -> factorial 3 -> factorial 2 -> factorial 1

; 反復版
; factorial 6 -> fact-iter 1 1 6 -> fact-iter 1 2 6 -> fact-iter 2 3 6 -> fact-iter 6 4 6 -> fact-iter 24 5 6 -> fact-iter 120 6 6 -> fact-iter 720 7 6

; …という感じかと思って答え見たら、それぞれの環境が大域環境に直で繋がってるんですね。
; 関数呼び出しだけでは環境はネストしていかないのかな。

