#lang racket

(require r5rs)
(require "test.scm")

(require "ch5-regsim.scm")

(define machine
  (make-machine
	'(a)
	(list)
	'(
start
  (goto (label here))
here
  (assign a (const 3))
  (goto (label there))
here
  (assign a (const 4))
  (goto (label there))
there
  )))


(set-register-contents! machine 'a 0)
(start machine)
(test-is (get-register-contents machine 'a) 3)

(test-done)

; ということで3になりました。つまり最初にある方のhereにいく。
; これはなぜかというと、extract-labelsが順序をたもったまま結果を返すのと
; ラベルのルックアップにassocを使ってて、assocは頭から見ていくからっぽい。

; どうすればいいかというと、すでに見つかったやつリストと比較するとかですかねー。

