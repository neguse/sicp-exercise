#lang racket

(require r5rs)
(require "test.scm")

(require "5-11-b.scm")

(define machine
  (make-machine
	'(x y)
	'()
	'(
  (assign x (const 1))
  (save x)
  (restore x)
  (save x)
  (restore y)
  )))

(start machine)

(test-done)

