#lang racket

(define (same-parity x . y)
  (define (filter-by-parity l o)
	(cond
	  ((null? l) l)
	  ((eq? (odd? (car l)) o) (cons (car l) (filter-by-parity (cdr l) o)))
	  (else (filter-by-parity (cdr l) o))))
  (cons x (filter-by-parity y (odd? x))))

(same-parity 1 2 3 4 5 6 7)
(same-parity 2 3 4 5 6 7)

; 問題を勘違いしていた。
; 奇数番目の要素からなるリストを返すんじゃなくて、
; 先頭が奇数なら奇数列、先頭が偶数なら偶数列を
; 返す関数を作ればいいんですね。

; あーなるほど。
; だから先頭だけdot notationで除外しておくんですね。
; ははー。

; はい。

