#lang racket
(require r5rs)

; ユニークなpair列を生成して、個数を数えればよさそう

(define (include-item? l i)
  (if (null? l)
	#f
	(or
	  (eq? (car l) i)
	  (include-item? (cdr l) i))))

(define (merge-items l1 l2)
  (cond
	((null? l2) l1)
	((null? l1) l2)
	((include-item? l1 (car l2))
	 (merge-items l1 (cdr l2)))
	(else
	  (merge-items (cons (car l2) l1) (cdr l2)))))

(define (items x)
  (if (pair? x)
	(merge-items
	  (merge-items
		(items (car x))
		(items (cdr x)))
	  (list x))
	'()))

(define (count-pairs x)
  (length (items x)))

(define v3 '(a b c))
(items v3)
(count-pairs v3)

(define v4-1 '(b))
(define v4 (cons 'a (cons v4-1 v4-1)))
(items v4)
(count-pairs v4)

(define v7-1 '(c))
(define v7-2 (cons v7-1 v7-1))
(define v7 (cons v7-2 v7-2))
(items v7)
(count-pairs v7)

; よし。
