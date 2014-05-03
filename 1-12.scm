#lang racket
; 問題文がよくわからん…
; …軽くググッたところ、列と行のindexを指定して要素を返すような関数を作ればいいらしい。
;
; ということで、こんな感じにしてみる
;
; 1
; 1 1
; 1 2 1
; 1 3 3 1
;
; ↓
;
; (pascal 1 1)
; (pascal 2 1) (pascal 2 2)
; (pascal 3 1) (pascal 3 2) (pascal 3 3)
; (pascal 4 1) (pascal 4 2) (pascal 4 3) (pascal 4 4)

(define (pascal row col)
  (cond
	((> 1 row) 0)
	((> 1 col) 0)
	((< row col) 0)
	((= col 1) 1)
	((= row col) 1)
	(else
	  (+ (pascal (- row 1) col)
		 (pascal (- row 1) (- col 1))))))

(= (pascal 0 0) 0)
(= (pascal 1 1) 1)
(= (pascal 2 1) 1)
(= (pascal 2 2) 1)
(= (pascal 3 1) 1)
(= (pascal 3 2) 2)
(= (pascal 3 3) 1)
(= (pascal 4 1) 1)
(= (pascal 4 2) 3)
(= (pascal 4 3) 3)
(= (pascal 4 4) 1)
(= (pascal 5 1) 1)
(= (pascal 5 2) 4)
(= (pascal 5 3) 6)
(= (pascal 5 4) 4)
(= (pascal 5 5) 1)

; $ racket 1-12.scm  | grep f
; $ 
; よし
