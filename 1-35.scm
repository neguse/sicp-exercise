#lang racket
; 黄金比率Φ=(1+√5) / 2
; で、これがx -> 1+1/xの不動点であるというのを示す。
;
; とりあえず代入してみればいい気がする
; x = Φの時:
;   x -> 1 + 1 / ((1+√5) / 2)
;      = 1 + 2 / (1 + √5)
;      = ((1 + √5) + 2) / (1 + √5)
;      = (3 + √5) / (1 + √5)
;      = (3 + √5)*(1 - √5) / (1 + √5)*(1 - √5)
;      = (3 - 5 - 2√5) / (1 - 5)
;      = (-2 -2√5) / -4
;      = 1+√5 / 2 = Φ
;   よって、Φは変換xの不動点であることが示せた。

; で、次にfixed-pointを使ってΦを求める。

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(fixed-point (lambda (x) (+ 1 (/ 1 x))) 1)
; -> 987/610
; まあよし。
