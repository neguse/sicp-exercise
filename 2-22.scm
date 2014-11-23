#lang racket

(define (square x) (* x x))

(define (square-list1 items)
  (define (iter things answer)
	(if (null? things)
	  answer
	  (iter (cdr things) 
			(cons (square (car things))
				  answer))))
  (iter items '()))

(square-list1 '(1 2 3))
; '(9 4 1)
; これはあれですよ。2.18でreverseを実装した時と同じ問題ですよ。
; consは後ろの方から逆順に適用しないとだめなんすよ。
; recursiveに解く時はconsが逆順に働くからいいんすけど…

(define (square-list2 items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items '()))

(square-list2 '(1 2 3))
; '(((() . 1) . 4) . 9)
; これはあれですよ。consの頭がanswerになっちゃってるから
; answerってlistだからだめなんすよ。
; これだから静的型付けじゃない言語は…うんぬん

