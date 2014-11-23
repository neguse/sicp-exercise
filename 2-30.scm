#lang racket

(define (square x) (* x x))

(define (square-tree1 tree)
  (cond
	((null? tree) '())
	((not (pair? tree)) (square tree))
	(else (cons
	  (square-tree1 (car tree))
	  (square-tree1 (cdr tree))))))

(define l (list 1 (list 2 (list 3 4) 5) (list 6 7)))
(square-tree1 l)
; '(1 (4 (9 16) 25) (36 49))

; map版は…
; カンニングしたところ、サブツリーに対してmapでやればいいらしい
; でもこれ、lambdaって高階関数なんじゃないの?

(define (square-tree2 tree)
  (map (lambda (sub-tree)
		 (if (pair? sub-tree)
		   (square-tree2 sub-tree)
		   (square sub-tree)))
	   tree))

(square-tree2 l)
; '(1 (4 (9 16) 25) (36 49))
; なんか釈然としない…
