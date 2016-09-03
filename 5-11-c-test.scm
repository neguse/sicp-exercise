#lang racket

(require r5rs)
(require "test.scm")

(require "5-11-c.scm")

(define machine
  (make-machine
	'(x y)
	'()
	'(
  (assign x (const 1))
  (assign y (const 2))
  ; 既存の実装だと逆順になるはずだけど、今の実装だと順番変わらないはず
  (save x)
  (save y)
  (restore x)
  (restore y)
  )))

(start machine)

(test-is (get-register-contents machine 'x) 1)
(test-is (get-register-contents machine 'y) 2)

(test-done)

; はい...

