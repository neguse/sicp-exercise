#lang racket

(define (square x) (* x x))

(define (square-list1 items)
  (if (null? items)
	'()
	(cons (square (car items)) (square-list1 (cdr items)))))

(define (square-list2 items)
  (map square items))

(define x '(1 2 3))
(equal? (square-list1 x) (square-list2 x))
; #t
; はい。

