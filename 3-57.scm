#lang racket

; これです。
(define fibs
  (cons-stream 0
			   (cons-stream 1
							(add-streams (stream-cdr fibs)
										 fibs))))

; 最適化を使わなかった時にどういう感じになるかというと、
; fibsが1ステップすすむごとにadd-streamsが1段増えて
; その中身がどっちもfibsを使ったものになっているので
; まあ指数的に増えるよなぁという感じです。

; 最適化を使った場合は、メモ化がはたらくので
; 足し算は1回で済むんじゃないでしょうか。

