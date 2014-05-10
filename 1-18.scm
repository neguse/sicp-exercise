#lang racket
; ロシア農民の方法(Russian peasant method)とは一体…
; …と思ったけど、これ1.17でやった方法と同じっぽい。
; とすると、ここでは何をすればいいんだろうか。
; あっ、1.17はrecursiveで、1.18はiterativeなのかな。
; どうしよう…とりあえずrecursiveで書きなおしてみるか。

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

(define (mul-recur x y)
	(cond
		((= y 0) 0)
		((even? y)
		 (mul-recur (double x) (halve y)))
		(else
		 (+ x (mul-recur (double x) (halve y))))))

(= (mul-recur 1 1) (mul-iter 1 1))
(= (mul-recur 1 2) (mul-iter 1 2))
(= (mul-recur 2 1) (mul-iter 2 1))
(= (mul-recur 2 2) (mul-iter 2 2))
(= (mul-recur 3 2) (mul-iter 3 2))
(= (mul-recur 3 36) (mul-iter 3 36))

; 釈然としないです…

