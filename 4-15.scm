#lang racket

(define (run-forever) (run-forever))

(define (try p)
  (if (halts? p p)
      (run-forever)
      'halted))

; halts?の存在を仮定して、
; (try try)を評価しようとしたときのことを考える

; ifが#tをかえしたとき、
; tryは無限にループする、のでhalts?は嘘を返していることになる。
; ifが#fをかえしたとき、
; tryは'haltedをかえす、のでhalts?は嘘を返していることになる。

; ということで、前提条件としておいた「halts?の存在」がまちがってるんじゃないですか。

