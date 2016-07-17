#lang racket

(require r5rs)
(require "test.scm")

(require "ch5-regsim.scm")

(define machine
  (make-machine
	'(a)
	(list (list '= =))
	'(
start
  (ntest (op =) (const 1) (const 2))
  (branch (label then))
else
  (assign a (const 3))
  (goto (label end))
then
  (assign a (const 4))
  (goto (label end))
end
  )))


(set-register-contents! machine 'a 0)
(start machine)
(test-is (get-register-contents machine 'a) 4)

(test-done)

; testを逆転させたntestをつくってみた。
; まあ、シミュレータ部分は変更なしでできてるんじゃないでしょうか。

