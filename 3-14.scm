#lang racket
(require r5rs)

(define (mystery x)
  (define (loop x y)
	(if (null? x)
	  y
	  (let ((temp (cdr x)))
		(set-cdr! x y)
		(loop temp x))))
  (loop x '()))

(define v (list 'a 'b 'c 'd))

(define w (mystery v))

w

; 1ループずつ考えていくと、
; (loop '(a b c d) '())
; (loop '(b c d) '(a))
; (loop '(c d) '(b a))
; (loop '(d) '(c b a))
; (loop '() '(d c b a))
; という感じで、なんとリストを逆順にするんじゃ！

