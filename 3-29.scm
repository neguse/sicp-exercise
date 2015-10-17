#lang racket
(require r5rs)

; andはこれ
; 0 0 : 0
; 1 0 : 0
; 0 1 : 0
; 1 1 : 1

; orはこれ
; 0 0 : 0
; 0 1 : 1
; 1 0 : 1
; 1 1 : 1

; つまり、入力と出力を全部invertすればよい?

(define (or-gate a1 a2 output)
  (let ((n1 (make-wire)) (n2 (make-wire)) (no (make-wire)))
	(invert a1 n1)
	(invert a2 n2)
	(and-gate n1 n2 no)
	(invert no output)
	'ok))

; delayは、invert 2回分とand1回分です

