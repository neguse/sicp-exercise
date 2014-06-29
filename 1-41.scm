#lang racket

(define (double f)
  (lambda (x) (f (f x))))

(define (inc x) (+ 1 x))

((double inc) 1)
; -> 3
; よし。

(((double (double double)) inc) 5)
; これなんだけど、実行前に考えると
; (double double)によって4倍、(double (double double))で8倍になるんじゃないか
; ということで、8倍のincは+8で13となるはず。
; -> 21
; あれー？1個ずつ考えてみよう

(((double double) inc) 1)
; -> 5
; これは4倍incだからそうなるはず。
; ((double double) inc)
; -> ((lambda (x) (double (double x))) inc)
; -> (double (double inc))
; -> (double (lambda (x) (+ 1 (+ 1 x))))
; で4倍inc
(((double (double double)) inc) 1)
; -> 17
; これは8倍incだと思ったんだけど、16倍incになってるのかなー。
; そんな気がするなー

