#lang racket

(define (double x) (arithmetic-shift x 1))
(define (halve x) (arithmetic-shift x -1))
(define (even? x) (= (bitwise-and x 1) 0))

(define (mul-iter-i x y a)
	(cond
		((= y 0) a)
		((even? y)
		 (mul-iter-i (double x) (halve y) a))
		(else
		 (mul-iter-i (double x) (halve y) (+ a x)))))

(define (mul-iter x y)
	(mul-iter-i x y 0))

(= (* 1 1) (mul-iter 1 1))
(= (* 1 2) (mul-iter 1 2))
(= (* 2 1) (mul-iter 2 1))
(= (* 2 2) (mul-iter 2 2))
(= (* 3 2) (mul-iter 3 2))
(= (* 3 36) (mul-iter 3 36))

; よし。
; 反復する前にxとyの大小を比較して、
; 小さい方を右辺に持ってくるとなおよしですね。

