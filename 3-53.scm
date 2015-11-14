#lang racket

(define s (cons-stream 1 (add-streams s s)))

; 0番目の要素は1
; 1番目の要素は1+1 = 2
; 2番目の要素は2+2 = 4
; ということで、2^N なんじゃないでしょうか。

; あってた
