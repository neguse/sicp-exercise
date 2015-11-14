#lang racket

(define (expand num den radix)
  (cons-stream
	(quotient (* num radix) den)
	(expand (remainder (* num radix) den) den radix)))

; とりあえず、(expand 1 7 10)を追ってみましょう。
; step0 : num=1 den=7 radix=10
; 10 / 7 = 1 あまり 3
; step1 : num=3 den=7 radix=10
; 30 / 7 = 4 あまり 2
; step2 : num=2 den=7 radix=10
; 20 / 7 = 2 あまり 6
; step3 : num=6 den=7 radix=10
; 60 / 7 = 8 あまり 4
; step4 : num=4 den=7 radix=10
; 40 / 7 = 5 あまり 5

; お気づきだろうか。
; 1 / 7 を小数表記で書くと、1.4285...となる。
; つまり、これは分数をradix進数表記での小数表記であるといえる。

; このことから、(expand 3 8 10)は
; 3 / 8 = 0.375なので
; 3, 7, 5, 0, 0, 0, 0, 0.....
; となるにちがいない!と確信に至ったわけである。

