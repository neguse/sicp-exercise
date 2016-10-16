#lang racket

(require r5rs)
(require "test.scm")

(require "ch5-regsim.scm")

(define implicit-count-leaves
  (make-machine
	'(tree c val continue)
	(list (list '+ +) (list 'pair? pair?) (list 'car car) (list 'cdr cdr) (list 'null? null?)
	'(
	  (assign continue (label count-done))
  count-loop
	  (test (op null?) (reg tree))
	  (branch (label empty-case))
	  (ntest (op pair?) (reg tree))
	  (branch (label single-case))

	  (save continue)
	  (save tree)
	  (assign tree (op car) (reg tree))
	  (assign continue (label after-count-car))
	  (goto (label count-loop))

  empty-case
      (assign val (const 0))
	  (goto (reg continue))

  single-case
      (assign val (const 1))
	  (goto (reg continue))

  after-count-car
      (restore tree)
	  (restore continue)
	  (save continue)
	  (save tree)
	  (save val)
	  (assign tree (op cdr) (reg tree))
	  (assign continue (label after-count-cdr))
	  (goto (label after-count-cdr))

  after-count-cdr
  	  (restore c)
      (restore tree)
	  (restore continue)
	  (assign val (op car) (reg val) (reg c))
	  (goto (reg continue))

  count-done)))




(define explicit-count-leaves
  (make-machine
	'(tree n val continue)
	(list (list '+ +) (list 'pair? pair?) (list 'car car) (list 'cdr cdr) (list 'null? null?)
	'(
	  (assign continue (label count-done))
  count-loop
	  (test (op null?) (reg tree))
	  (branch (label empty-case))
	  (ntest (op pair?) (reg tree))
	  (branch (label single-case))

	  (save continue)
	  (save tree)
	  (assign tree (op car) (reg tree))
	  (assign continue (label after-count-car))
	  (goto (label count-loop))

  empty-case
      (assign val (reg n))
	  (goto (reg continue))

  single-case
      (assign val (op +) (reg n) (const 1))
	  (goto (reg continue))

  after-count-car
      (restore tree)
	  (restore continue)
	  (assign tree (op cdr) (reg tree))
	  (assign n (reg val))
	  (goto (label count-loop))

  count-done)))

(test-done)

; こんな感じでしょうか。
; explicit-count-leavesのほうが末尾再帰最適化されてる感があっていいですね

