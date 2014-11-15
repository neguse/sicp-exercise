#lang racket

(define (reverse x)
  (define (inner y acc)
	(if (null? y)
	  acc
	  (inner (cdr y) (cons (car y) acc))))
  (inner x '()))

; 考えてたら布団で二度寝した…

(reverse '())
; '()
(reverse '(1))
; '(1)
(reverse '(1 2))
; '(2 1)
(reverse '(1 2 3))
; '(3 2 1)

; なんか適当にいじってたらできた。
; 正順のリストを作るには後ろからconsしていく必要があって
; それには普通再帰を使うんだけど、
; 逆順のリストを作るには前からconsしていけばいいから
; cons結果を持ち回しておけばOKってことですね。
