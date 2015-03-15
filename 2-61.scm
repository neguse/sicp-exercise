#lang racket

(define (adjoin-set x set)
  (if (null? set) (list x)
	(let ((s1 (car set)))
	  (cond
		((= x s1) set)
		((> x s1) (cons s1 (adjoin-set x (cdr set))))
		(else (cons x set))))))

(adjoin-set 3 '(1 2 4 5))
(adjoin-set 0 '(1 2 4 5))
(adjoin-set 6 '(1 2 4 5))

(adjoin-set 3 '(1 2 3 4 5))
(adjoin-set 0 '(0 1 2 4 5))
(adjoin-set 6 '(1 2 4 5 6))

; よし。
; > 順序の利点をどう用いるか示せ. 
; これは、setの中にxが含まれているかどうかを調べるのに
; element-of-set?を使う以前のやり方だとnステップかかってたのがn/2ステップになる、
; ということでいいんじゃないでしょうか。
; ただ、こっちのほうがconsの分けっこうな処理になりそうな気はする。
