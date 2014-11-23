#lang racket

(define (square x) (* x x))
(define (tree-map f tree)
  (cond
	((null? tree) '())
	((not (pair? tree)) (f tree))
	(else (cons
	  (tree-map f (car tree))
	  (tree-map f (cdr tree))))))

(define (square-tree tree) (tree-map square tree))

(define l (list 1 (list 2 (list 3 4) 5) (list 6 7)))
(square-tree l)
; '(1 (4 (9 16) 25) (36 49))
; はい。
