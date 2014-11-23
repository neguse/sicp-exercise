#lang racket

(define (subsets s)
  (if (null? s)
	(list '())
	(let ((rest (subsets (cdr s))))
	  (append rest (map (lambda (r) (append (list (car s)) r)) rest)))))

(define (for-each f x)
  (if (null? x)
	#f
	(begin
	  (f (car x))
	  (for-each f (cdr x)))))

(for-each (lambda (x) (newline) (display x))
(subsets '(1 2 3)))
; ()
; (3)
; (2)
; (2 3)
; (1)
; (1 3)
; (1 2)
; (1 2 3)

; おっけい。
; えーとですね、これたぶんsubsetsの引数がuniqueであることが前提なんですけど、
; たとえば(1 2 3)の部分集合の集合は、
; (2 3)の部分集合の集合と、それの要素に1を含めたやつ、なんですよたぶん。
; たとえば要素3だったら2進数3桁の数値のパターンと、それぞれ1=含む、0=含まないという感じにして
; 総当りした場合を考えればなんとなくイメージできるんじゃないでしょうか。

