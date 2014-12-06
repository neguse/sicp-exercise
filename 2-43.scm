#lang racket

; 2.42のやりかただと1列ずつ計算して、一度計算したところは二度と計算しないんだけど
; Louisさんのだと同じ前の手を繰り返し計算してしまいそう。
; メモ化とか入ってれば同じなんだろうけど…
; 推定とかはよくわからんなぁ
; あ、T ^ board-sizeですか…

(define (accumulate op initial sequence)
  (if (null? sequence)
	initial
	(op (car sequence)
		(accumulate op initial (cdr sequence)))))

; returns #t if all items of sequence is (op item) == #t
(define (all? op sequence)
  (accumulate (lambda (i q) (and q (op i))) #t sequence))

(define (cross l1 l2) (flatmap (lambda (i2) (map (lambda (i1) (list i1 i2)) l1)) l2))

(define (flatmap proc seq)
  (accumulate append '() (map proc seq)))

(define (enumerate-interval low high)
  (if (> low high)
      '()
      (cons low (enumerate-interval (+ low 1) high))))

(define empty-board '())

(define (position row col) (list row col))
(define (position-row p) (car p))
(define (position-col p) (cadr p))
(define (position-cross-up p dcol)
  (position (- (position-row p) dcol) (- (position-col p) dcol)))
(define (position-cross-down p dcol)
  (position (+ (position-row p) dcol) (- (position-col p) dcol)))
(define (eq-pos? p1 p2)
  (and
	(= (position-row p1) (position-row p2))
	(= (position-col p1) (position-col p2))))

(define (adjoin-position row col queens)
  (append queens (list (position row col))))

(define (safe? k positions)
  (define (safe-pos? k-pos pos)
	(and
	  (not (= (position-row k-pos) (position-row pos)))
	  (not (= (position-col k-pos) (position-col pos)))
	  (not (eq-pos? (position-cross-up k-pos (- (position-col k-pos) (position-col pos))) pos))
	  (not (eq-pos? (position-cross-down k-pos (- (position-col k-pos) (position-col pos))) pos))))
  (let
	((kths (filter (lambda (p) (= (position-col p) k)) positions))
	 (oths (filter (lambda (p) (not (= (position-col p) k))) positions)))
	(display "kths")
	(display kths)
	(display "oths")
	(display oths)
	(display (and
	  (null? (cdr kths)) ; len(kths) > 0 の場合、kths同士がかぶるので駄目(すごいてきとう)
	  (all? (lambda (i) (safe-pos? (car i) (cadr i))) (cross kths oths)))) ; それ以外のkth, othの対に対してsafe-pos?が全部#tなら#t
	(newline)
	(and
	  (null? (cdr kths)) ; len(kths) > 0 の場合、kths同士がかぶるので駄目(すごいてきとう)
	  (all? (lambda (i) (safe-pos? (car i) (cadr i))) (cross kths oths))))) ; それ以外のkth, othの対に対してsafe-pos?が全部#tなら#t

(define (queens board-size)
  (define (queen-cols k)  
	(if (= k 0)
	  (list empty-board)
	  (filter
		(lambda (positions) (safe? k positions))
		(flatmap
		  (lambda (new-row)
			(map (lambda (rest-of-queens)
				   (adjoin-position new-row k rest-of-queens))
				 (queen-cols (- k 1))))
		  (enumerate-interval 1 board-size)))))
  (queen-cols board-size))

(queens 4)
; (length (queens 8))
; 92
; たぶん合ってるでしょう。

