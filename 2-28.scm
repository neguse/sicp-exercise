#lang racket

(define (fringe x)
  (cond
	((null? x) x)
	((not (pair? x)) (list x))
	(else
	  (append (fringe (car x)) (fringe (cdr x))))))

; carに再帰的に適用した結果はlistなので、
; consじゃなくてappendにしたいところ。
; そのためlistを使って調整している。

(define x (list (list 1 2) (list 3 4)))
(fringe x)
; (1 2 3 4)
(fringe (list x x))
; (1 2 3 4 1 2 3 4)
; よし。

(define y '(1 2 (3 4 (5 6 (7 (8) 9 10)))))
(fringe y)
; '(1 2 3 4 5 6 7 8 9 10)
; よし。
