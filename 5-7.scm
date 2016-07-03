#lang racket

(require r5rs)
(require "test.scm")

(require "ch5-regsim.scm")

(define recursive-machine
  (make-machine
	'(n b val continue)
	(list (list '- -) (list '* *) (list '= =))
	'(
	  (assign continue (label expt-done))

  expt-loop
	  (test (op =) (reg n) (const 0))
	  (branch (label base-case))

	  (save continue)
	  (save n)
	  (assign n (op -) (reg n) (const 1))
	  (assign continue (label after-expt))
	  (goto (label expt-loop))

  after-expt
	  (restore n)
	  (restore continue)
	  (assign val (op *) (reg b) (reg val))
	  (goto (reg continue))
  base-case
	  (assign val (const 1))
	  (goto (reg continue))
  expt-done)))

(set-register-contents! recursive-machine 'n 4)
(set-register-contents! recursive-machine 'b 2)
(start recursive-machine)
(test-is (get-register-contents recursive-machine 'val) 16)




(define iterative-machine
  (make-machine
	'(n b p)
	(list (list '- -) (list '* *) (list '= =))
	'(

	  (assign p (const 1))
  expt-iter
	  (test (op =) (reg n) (const 0))
	  (branch (label expt-done))

	  (assign p (op *) (reg b) (reg p))
	  (assign n (op -) (reg n) (const 1))
	  (goto (label expt-iter))

  expt-done)))

(set-register-contents! iterative-machine 'n 4)
(set-register-contents! iterative-machine 'b 2)
(start iterative-machine)
(test-is (get-register-contents iterative-machine 'p) 16)

(test-done)

