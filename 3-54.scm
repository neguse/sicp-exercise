#lang racket

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (mul-streams s1 s2)
  (stream-map * s1 s2))

; factorialは、!ってやつで
; 1, 2, 6, 24, 120, ...
; ってやつですね。
; 要するに、一個前のやつとかけあわせればOKと。

(define factorials
  (cons-stream 1 (mul-streams (stream-cdr integers) factorial)))

; こんなんでしょうか。

