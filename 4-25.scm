#lang racket

(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))

(define (factorial n)
  (unless (= n 1)
          (* n (factorial (- n 1)))
          1))

(factorial 5)

; 動かないでしょ。
; (= n 1)が#tか#fかによらず無限に再帰するんです。
