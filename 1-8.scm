#lang racket

(define (cubic x)
  (* x x x))

(define (average x y)
	(/ (+ x y) 2))

(define (good-enough? guess prev-guess x)
  (< (abs (- prev-guess guess)) 0.001))

(define (cubic-root-iter guess prev-guess x)
	(if (good-enough? guess prev-guess x)
		guess
		(cubic-root-iter (improve guess x)
							 guess
							 x)))

(define (improve guess x)
	(/
		(+
			(/ x (* guess guess))
			(* 2 guess))
		3))

(define (cubic-root x)
	  (cubic-root-iter 1.0 0.0 x))

(define (main)
	(let ((o (read)))
		(if (eof-object? o)
			#f
			(begin
				(printf "~s\n"
								(cubic-root o))
				(main)))))

(main)

; 解いてみたけど、1e+50ぐらいだと停止しなくなる。
; なぜでしょうか…

