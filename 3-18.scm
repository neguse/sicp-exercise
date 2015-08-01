#lang racket

; 循環ってなんだろう
; 単純に、同じ参照が2つ以上あるとNG、だと循環じゃない時にも引っかかりそう
; rootからたどるごとにたどった履歴をおぼえておいて、
; すでにたどったのが来たらNG、という風にするのがよさそう

(require r5rs)

(define (include-item? l i)
  (if (null? l)
	#f
	(or
	  (eq? (car l) i)
	  (include-item? (cdr l) i))))

(define (circular? x)
  (define (circular-inner? x visit)
	(cond
	  ((not (pair? x)) #f)
	  ((include-item? visit x) #t)
	  (else
		(or
		  (circular-inner? (car x) (cons x visit))
		  (circular-inner? (cdr x) (cons x visit))))))
  (circular-inner? x '()))

(circular? '(a b c))

(define (last-pair x)
  (if (null? (cdr x))
	x
	(last-pair (cdr x))))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define z (make-cycle (list 'a 'b 'c)))

(circular? z)

(define v1 '(a b c))
(define v2 (list v1 v1))

(circular? v2)

; はい。

